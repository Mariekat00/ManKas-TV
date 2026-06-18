"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import Image from "next/image";
import { Heart, Play, RadioTower } from "lucide-react";
import { addFavorite, addWatchHistory, removeFavorite } from "@/services/channels";
import { useTvStore } from "@/store/useTvStore";
import type { Channel } from "@/types";

export function ChannelGrid({
  channels,
  isLoading,
  error,
}: {
  channels: Channel[];
  isLoading: boolean;
  error: string | null;
}) {
  if (isLoading) {
    return <ChannelSkeleton />;
  }

  if (error) {
    return (
      <div className="rounded-md border border-border bg-panel p-6 text-sm text-muted">
        {error}
      </div>
    );
  }

  if (channels.length === 0) {
    return (
      <div className="rounded-md border border-border bg-panel p-6 text-sm text-muted">
        No channels match the current filters.
      </div>
    );
  }

  return (
    <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 2xl:grid-cols-6">
      {channels.map((channel) => (
        <ChannelCard key={channel.id} channel={channel} />
      ))}
    </div>
  );
}

function ChannelCard({ channel }: { channel: Channel }) {
  const router = useRouter();
  const favorites = useTvStore((state) => state.favorites);
  const setSelectedChannel = useTvStore((state) => state.setSelectedChannel);
  const toggleFavoriteLocal = useTvStore((state) => state.toggleFavoriteLocal);
  const isFavorite = favorites.includes(channel.id);

  async function selectChannel() {
    setSelectedChannel(channel);
    await addWatchHistory(channel.id).catch(() => undefined);
    router.push(`/channels/${channel.id}`);
  }

  async function toggleFavorite() {
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

  return (
    <article className="group overflow-hidden rounded-md border border-border bg-panel transition hover:-translate-y-0.5 hover:border-accent">
      <button type="button" onClick={selectChannel} className="block w-full text-left">
        <div className="relative aspect-video bg-panel-strong">
          {channel.logo ? (
            <Image
              src={channel.logo}
              alt={`${channel.name} logo`}
              fill
              sizes="(min-width: 1536px) 16vw, (min-width: 1024px) 25vw, 50vw"
              className="object-contain p-6"
              unoptimized
            />
          ) : (
            <div className="flex h-full items-center justify-center text-muted">
              <RadioTower size={34} aria-hidden="true" />
            </div>
          )}
          <span className="absolute bottom-2 right-2 flex size-9 items-center justify-center rounded-md bg-accent text-white opacity-0 transition group-hover:opacity-100">
            <Play size={17} fill="currentColor" aria-hidden="true" />
          </span>
        </div>
      </button>
      <div className="space-y-3 p-3">
        <div className="min-w-0">
          <Link href={`/channels/${channel.id}`} className="block truncate font-medium hover:text-accent">
            {channel.name}
          </Link>
          <p className="mt-1 truncate text-xs text-muted">
            {[channel.category, channel.country, channel.language].filter(Boolean).join(" / ")}
          </p>
        </div>
        <button
          type="button"
          onClick={toggleFavorite}
          className="flex h-9 w-full items-center justify-center gap-2 rounded-md border border-border text-sm text-muted transition hover:border-accent hover:text-foreground"
        >
          <Heart size={16} fill={isFavorite ? "currentColor" : "none"} aria-hidden="true" />
          {isFavorite ? "Saved" : "Favorite"}
        </button>
      </div>
    </article>
  );
}

function ChannelSkeleton() {
  return (
    <div className="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 2xl:grid-cols-6">
      {Array.from({ length: 12 }).map((_, index) => (
        <div key={index} className="h-44 animate-pulse rounded-md border border-border bg-panel" />
      ))}
    </div>
  );
}
