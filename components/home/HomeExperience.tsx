"use client";

import { Tv } from "lucide-react";
import { ChannelFilters } from "@/components/channels/ChannelFilters";
import { ChannelGrid } from "@/components/channels/ChannelGrid";
import { RecentlyWatched } from "@/components/channels/RecentlyWatched";
import { FavoritesSection } from "@/components/home/FavoritesSection";
import { VideoPlayer } from "@/components/player/VideoPlayer";
import { useChannels } from "@/hooks/useChannels";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";

export function HomeExperience() {
  const { channels, filteredChannels, isLoading, error } = useChannels();
  const selectedChannel = useTvStore((state) => state.selectedChannel);
  const locale = useTvStore((state) => state.locale);

  return (
    <div className="mx-auto flex max-w-[1800px] flex-col gap-8 px-4 py-6 sm:px-6 lg:px-8">
      {/* Hero with video player */}
      <section className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_380px]">
        <VideoPlayer channel={selectedChannel} />
        <div className="flex flex-col justify-end gap-4">
          <div>
            <p className="text-sm font-medium uppercase tracking-[0.22em] text-accent">
              {t(locale, "home.public.iptv")}
            </p>
            <h1 className="mt-3 max-w-2xl text-4xl font-semibold tracking-normal text-foreground sm:text-5xl">
              ManKas TV
            </h1>
            <p className="mt-4 max-w-xl text-base leading-7 text-muted">
              {t(locale, "home.description")}
            </p>
          </div>

          {/* Main navigation button */}
          <div>
            <a
              href="#channels"
              className="flex flex-col items-center gap-2 rounded-xl bg-accent p-5 text-white transition hover:opacity-90"
            >
              <Tv size={28} />
              <span className="text-sm font-bold">{t(locale, "home.iptv")}</span>
            </a>
          </div>

          {/* Metrics */}
          <div className="grid grid-cols-3 gap-3">
            <Metric label={t(locale, "home.channels")} value={channels.length} />
            <Metric label={t(locale, "home.countries")} value={new Set(channels.map((item) => item.country).filter(Boolean)).size} />
            <Metric label={t(locale, "home.categories")} value={new Set(channels.map((item) => item.category).filter(Boolean)).size} />
          </div>
        </div>
      </section>

      <RecentlyWatched />

      <FavoritesSection />

      <section id="channels" className="space-y-4">
        <ChannelFilters channels={channels} />
        <ChannelGrid channels={filteredChannels} isLoading={isLoading} error={error} />
      </section>
    </div>
  );
}

function Metric({ label, value }: { label: string; value: number }) {
  return (
    <div className="rounded-md border border-border bg-panel p-4">
      <div className="font-mono text-2xl font-semibold">{value}</div>
      <div className="mt-1 text-xs uppercase tracking-[0.18em] text-muted">{label}</div>
    </div>
  );
}
