"use client";

import Hls from "hls.js";
import { Maximize2, RefreshCw, Volume2 } from "lucide-react";
import { SatelliteDishIcon } from "@/components/icons/satellite-dish";
import { FrownIcon } from "@/components/icons/frown";
import { useEffect, useRef, useState } from "react";
import type { Channel } from "@/types";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";
import { getStreamProxyUrl } from "@/lib/proxy";

function isYouTubeUrl(url: string): boolean {
  return url.includes("youtube.com") || url.includes("youtu.be");
}

function isTwitchUrl(url: string): boolean {
  return url.includes("twitch.tv");
}

function isDailymotionUrl(url: string): boolean {
  return url.includes("dailymotion.com");
}

function getYouTubeEmbedUrl(url: string): string {
  const parsed = new URL(url);

  const liveMatch = parsed.pathname.match(/\/c\/([^/]+)\/live/);
  if (liveMatch) {
    return `https://www.youtube.com/embed?channel=${liveMatch[1]}&autoplay=1`;
  }

  const channelMatch = parsed.pathname.match(/\/channel\/([^/]+)/);
  if (channelMatch) {
    return `https://www.youtube.com/embed?channel=${channelMatch[1]}&autoplay=1`;
  }

  const userMatch = parsed.pathname.match(/\/user\/([^/]+)/);
  if (userMatch) {
    return `https://www.youtube.com/embed?channel=${userMatch[1]}&autoplay=1`;
  }

  const handleMatch = parsed.pathname.match(/\/@([^/]+)/);
  if (handleMatch) {
    return `https://www.youtube.com/embed?channel=${handleMatch[1]}&autoplay=1`;
  }

  const videoId = parsed.searchParams.get("v");
  if (videoId) {
    return `https://www.youtube.com/embed/${videoId}?autoplay=1`;
  }

  const shortMatch = parsed.pathname.match(/\/shorts\/([^/]+)/);
  if (shortMatch) {
    return `https://www.youtube.com/embed/${shortMatch[1]}?autoplay=1`;
  }

  return `https://www.youtube.com/embed?channel=${parsed.pathname.replace(/^\//, "").replace(/\/$/, "")}&autoplay=1`;
}

function getTwitchEmbedUrl(url: string): string {
  const parsed = new URL(url);
  const channelMatch = parsed.pathname.match(/\/([^/]+)\/?$/);
  if (channelMatch) {
    return `https://player.twitch.tv/?channel=${channelMatch[1]}&parent=${window.location.hostname}&autoplay=true`;
  }
  return url;
}

function getDailymotionEmbedUrl(url: string): string {
  const parsed = new URL(url);
  const videoMatch = parsed.pathname.match(/\/video\/([^/]+)/);
  if (videoMatch) {
    return `https://www.dailymotion.com/embed/video/${videoMatch[1]}?autoplay=1`;
  }
  const channelMatch = parsed.pathname.match(/\/([^/]+)\/?$/);
  if (channelMatch) {
    return `https://www.dailymotion.com/embed/live/${channelMatch[1]}?autoplay=1`;
  }
  return url;
}

function getEmbedUrl(url: string): string | null {
  if (isYouTubeUrl(url)) return getYouTubeEmbedUrl(url);
  if (isTwitchUrl(url)) return getTwitchEmbedUrl(url);
  if (isDailymotionUrl(url)) return getDailymotionEmbedUrl(url);
  return null;
}

export function VideoPlayer({ channel }: { channel: Channel | null }) {
  const videoRef = useRef<HTMLVideoElement>(null);
  const hlsRef = useRef<Hls | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [volume, setVolume] = useState(0.8);
  const setPlayerStatus = useTvStore((state) => state.setPlayerStatus);
  const locale = useTvStore((state) => state.locale);

  const isEmbed = channel ? getEmbedUrl(channel.stream_url) : null;
  const [embedUrl, setEmbedUrl] = useState<string | null>(null);

  useEffect(() => {
    if (isEmbed) {
      setEmbedUrl(isEmbed);
      setPlayerStatus("playing");
      setLoading(false);
      return;
    }
    setEmbedUrl(null);
  }, [isEmbed, setPlayerStatus]);

  useEffect(() => {
    const video = videoRef.current;

    if (!video || !channel || isEmbed) {
      return undefined;
    }

    const currentVideo = video;
    let retryCount = 0;

    function destroyHls() {
      hlsRef.current?.destroy();
      hlsRef.current = null;
    }

    function loadStream() {
      if (!channel) return;
      destroyHls();
      setError(null);
      setLoading(true);
      setPlayerStatus("loading");

      const streamUrl = getStreamProxyUrl(channel.stream_url);

      if (currentVideo.canPlayType("application/vnd.apple.mpegurl")) {
        currentVideo.src = streamUrl;
        void currentVideo.play().catch(() => undefined);
        setPlayerStatus("playing");
        setLoading(false);
        return;
      }

      if (!Hls.isSupported()) {
        setError(t(locale, "player.error.hls"));
        setPlayerStatus("error");
        setLoading(false);
        return;
      }

      const hls = new Hls({
        enableWorker: true,
        lowLatencyMode: true,
        backBufferLength: 60,
      });

      hlsRef.current = hls;
      hls.loadSource(streamUrl);
      hls.attachMedia(currentVideo);
      hls.on(Hls.Events.MANIFEST_PARSED, () => {
        currentVideo.volume = volume;
        void currentVideo.play().catch(() => undefined);
        setPlayerStatus("playing");
        setLoading(false);
      });
      hls.on(Hls.Events.ERROR, (_, data) => {
        if (!data.fatal) {
          return;
        }

        if (retryCount < 2) {
          retryCount += 1;
          window.setTimeout(loadStream, 1200 * retryCount);
          return;
        }

        setError(t(locale, "player.error.stream"));
        setPlayerStatus("error");
        setLoading(false);
        destroyHls();
      });
    }

    loadStream();

    return () => {
      destroyHls();
      currentVideo.removeAttribute("src");
      currentVideo.load();
    };
  }, [channel, setPlayerStatus, volume, isEmbed, locale]);

  useEffect(() => {
    if (videoRef.current && !isEmbed) {
      videoRef.current.volume = volume;
    }
  }, [volume, isEmbed]);

  function requestFullscreen() {
    void videoRef.current?.requestFullscreen();
  }

  return (
    <section className="overflow-hidden rounded-md border border-border bg-black shadow-2xl shadow-black/40">
      <div className="relative aspect-video bg-black">
        {channel ? (
          embedUrl ? (
            <iframe
              src={embedUrl}
              className="h-full w-full border-0"
              allow="autoplay; encrypted-media; picture-in-picture"
              allowFullScreen
              title={channel.name}
            />
          ) : (
            <>
              <video
                ref={videoRef}
                controls
                playsInline
                autoPlay
                muted
                className="h-full w-full bg-black"
                poster={channel.logo ?? undefined}
              />
              {loading && (
                <div className="absolute inset-0 flex items-center justify-center bg-black/60">
                  <div className="flex flex-col items-center gap-3">
                    <div className="size-8 animate-spin rounded-full border-2 border-white/20 border-t-white" />
                    <p className="text-sm text-white/70">{t(locale, "player.loading")}</p>
                  </div>
                </div>
              )}

            </>
          )
        ) : (
          <div className="flex h-full flex-col items-center justify-center gap-4 text-muted">
            <SatelliteDishIcon size={56} className="text-muted/50" aria-hidden="true" />
            <div className="text-center">
              <p className="text-sm font-medium">{t(locale, "player.select")}</p>
              <p className="mt-1 text-xs text-muted/60">{t(locale, "player.waiting")}</p>
            </div>
          </div>
        )}

        {error ? (
          <div className="absolute inset-x-4 bottom-4 flex items-start gap-3 rounded-md border border-red-500/30 bg-red-950/90 p-4 text-sm text-red-100 backdrop-blur-sm">
            <FrownIcon className="mt-0.5 shrink-0 size-5 text-red-400" />
            <div className="flex-1">
              <p>{error}</p>
              <button
                type="button"
                onClick={() => videoRef.current?.load()}
                className="mt-2 flex items-center gap-1.5 text-xs text-red-300 underline hover:text-red-200"
              >
                <RefreshCw size={12} />
                {t(locale, "player.retry")}
              </button>
            </div>
          </div>
        ) : null}
      </div>

      <div className="flex flex-col gap-3 border-t border-white/10 bg-panel p-4 sm:flex-row sm:items-center sm:justify-between">
        <div className="min-w-0">
          <p className="truncate font-medium">{channel?.name ?? t(locale, "player.no.channel")}</p>
          <p className="mt-1 truncate text-xs text-muted">
            {[channel?.category, channel?.country, channel?.language].filter(Boolean).join(" / ") ||
              t(locale, "player.waiting")}
          </p>
        </div>

        {!embedUrl && (
          <div className="flex items-center gap-2">
            <label className="flex h-10 items-center gap-2 rounded-md border border-border px-3 text-muted">
              <Volume2 size={16} aria-hidden="true" />
              <input
                type="range"
                min="0"
                max="1"
                step="0.05"
                value={volume}
                onChange={(event) => setVolume(Number(event.target.value))}
                className="w-24 accent-[var(--accent)]"
                aria-label="Volume"
              />
            </label>
            <button
              type="button"
              onClick={() => videoRef.current?.load()}
              className="flex size-10 items-center justify-center rounded-md border border-border text-muted hover:text-foreground"
              title={t(locale, "player.retry")}
              aria-label={t(locale, "player.retry")}
            >
              <RefreshCw size={16} aria-hidden="true" />
            </button>
            <button
              type="button"
              onClick={requestFullscreen}
              className="flex size-10 items-center justify-center rounded-md border border-border text-muted hover:text-foreground"
              title={t(locale, "player.fullscreen")}
              aria-label={t(locale, "player.fullscreen")}
            >
              <Maximize2 size={16} aria-hidden="true" />
            </button>
          </div>
        )}
      </div>
    </section>
  );
}
