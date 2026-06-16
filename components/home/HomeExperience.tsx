"use client";

import { useEffect } from "react";
import { ChannelFilters } from "@/components/channels/ChannelFilters";
import { ChannelGrid } from "@/components/channels/ChannelGrid";
import { RecentlyWatched } from "@/components/channels/RecentlyWatched";
import { FavoritesSection } from "@/components/home/FavoritesSection";
import { VideoPlayer } from "@/components/player/VideoPlayer";
import { useChannels } from "@/hooks/useChannels";
import { useTvStore } from "@/store/useTvStore";

export function HomeExperience() {
  const { channels, filteredChannels, isLoading, error } = useChannels();
  const selectedChannel = useTvStore((state) => state.selectedChannel);
  const setSelectedChannel = useTvStore((state) => state.setSelectedChannel);

  useEffect(() => {
    if (!selectedChannel && channels.length > 0) {
      setSelectedChannel(channels[0]);
    }
  }, [channels, selectedChannel, setSelectedChannel]);

  return (
    <div className="mx-auto flex max-w-[1800px] flex-col gap-8 px-4 py-6 sm:px-6 lg:px-8">
      <section className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_380px]">
        <VideoPlayer channel={selectedChannel} />
        <div className="flex flex-col justify-end gap-4">
          <div>
            <p className="text-sm font-medium uppercase tracking-[0.22em] text-accent">
              Public IPTV
            </p>
            <h1 className="mt-3 max-w-2xl text-4xl font-semibold tracking-normal text-foreground sm:text-5xl">
              ManKas TV
            </h1>
            <p className="mt-4 max-w-xl text-base leading-7 text-muted">
              Stream verified public HLS channels, save favorites, and continue from your recent
              history across devices.
            </p>
          </div>
          <div className="grid grid-cols-3 gap-3">
            <Metric label="Channels" value={channels.length} />
            <Metric label="Countries" value={new Set(channels.map((item) => item.country).filter(Boolean)).size} />
            <Metric label="Categories" value={new Set(channels.map((item) => item.category).filter(Boolean)).size} />
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
