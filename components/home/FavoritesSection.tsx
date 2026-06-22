"use client";

import { Heart } from "lucide-react";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";
import { ChannelGrid } from "@/components/channels/ChannelGrid";

export function FavoritesSection() {
  const channels = useTvStore((state) => state.channels);
  const favorites = useTvStore((state) => state.favorites);
  const locale = useTvStore((state) => state.locale);
  const favoriteChannels = channels.filter((ch) => favorites.includes(ch.id));

  if (favoriteChannels.length === 0) return null;

  return (
    <section id="favorites" className="space-y-4">
      <div className="flex items-center gap-2">
        <Heart size={18} className="text-accent" aria-hidden="true" />
        <h2 className="text-lg font-semibold">{t(locale, "nav.favorites")}</h2>
      </div>
      <ChannelGrid channels={favoriteChannels} isLoading={false} error={null} />
    </section>
  );
}
