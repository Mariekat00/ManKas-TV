"use client";

import Link from "next/link";
import { ArrowLeft, Heart, Play } from "lucide-react";
import { useEffect, useState } from "react";
import { VideoPlayer } from "@/components/player/VideoPlayer";
import { addFavorite, addWatchHistory, getChannel, removeFavorite } from "@/services/channels";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";
import type { Channel } from "@/types";

export function ChannelDetail({ channelId }: { channelId: string }) {
  const [channel, setChannel] = useState<Channel | null>(null);
  const [error, setError] = useState<string | null>(null);
  const setSelectedChannel = useTvStore((state) => state.setSelectedChannel);
  const favorites = useTvStore((state) => state.favorites);
  const toggleFavoriteLocal = useTvStore((state) => state.toggleFavoriteLocal);
  const locale = useTvStore((state) => state.locale);
  const isFavorite = channel ? favorites.includes(channel.id) : false;

  useEffect(() => {
    window.scrollTo(0, 0);
    let isMounted = true;

    getChannel(channelId)
      .then((data) => {
        if (isMounted) {
          setChannel(data);
          setSelectedChannel(data);
          void addWatchHistory(data.id).catch(() => undefined);
        }
      })
      .catch((detailError) => {
        if (isMounted) {
          setError(detailError instanceof Error ? detailError.message : t(locale, "channel.notfound"));
        }
      });

    return () => {
      isMounted = false;
    };
  }, [channelId, setSelectedChannel, locale]);

  async function toggleFavorite() {
    if (!channel) return;
    toggleFavoriteLocal(channel.id);

    try {
      if (isFavorite) {
        await removeFavorite(channel.id);
      } else {
        await addFavorite(channel.id);
      }
    } catch {
      toggleFavoriteLocal(channel.id);
    }
  }

  function handleWatch() {
    if (channel) setSelectedChannel(channel);
  }

  if (error) {
    return <div className="p-6 text-muted">{error}</div>;
  }

  return (
    <div className="mx-auto flex max-w-6xl flex-col gap-6 px-4 py-6 sm:px-6">
      <Link href="/" className="flex w-fit items-center gap-2 text-sm text-muted hover:text-foreground">
        <ArrowLeft size={16} aria-hidden="true" />
        {t(locale, "channel.back")}
      </Link>
      <VideoPlayer channel={channel} />
      <section className="rounded-md border border-border bg-panel p-5">
        <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
          <div>
            <h1 className="text-3xl font-semibold">{channel?.name ?? t(locale, "channel.loading")}</h1>
            <p className="mt-2 text-sm text-muted">
              {[channel?.category, channel?.country, channel?.language].filter(Boolean).join(" / ")}
            </p>
          </div>
          <div className="flex gap-2">
            <button
              type="button"
              onClick={handleWatch}
              className="flex h-10 items-center gap-2 rounded-md bg-accent px-4 text-sm font-medium text-white"
            >
              <Play size={16} fill="currentColor" aria-hidden="true" />
              {t(locale, "channel.watch")}
            </button>
            <button
              type="button"
              onClick={toggleFavorite}
              className="flex h-10 items-center gap-2 rounded-md border border-border px-4 text-sm text-muted hover:text-foreground"
            >
              <Heart size={16} fill={isFavorite ? "currentColor" : "none"} aria-hidden="true" />
              {isFavorite ? t(locale, "channel.saved") : t(locale, "channel.favorite")}
            </button>
          </div>
        </div>
      </section>
    </div>
  );
}
