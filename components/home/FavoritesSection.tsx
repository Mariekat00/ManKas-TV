"use client";

import { HeartIcon } from "@/components/icons/heart";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";
import { ChannelGrid } from "@/components/channels/ChannelGrid";

export function FavoritesSection() {
  const channels = useTvStore((state) => state.channels);
  const favorites = useTvStore((state) => state.favorites);
  const locale = useTvStore((state) => state.locale);
  const favoriteChannels = channels.filter((ch) => favorites.includes(ch.id));

  if (favoriteChannels.length === 0) {
    return (
      <section id="favorites" className="space-y-4">
        <div className="flex items-center gap-2">
          <HeartIcon size={18} className="text-accent" aria-hidden="true" />
          <h2 className="text-lg font-semibold">{t(locale, "nav.favorites")}</h2>
        </div>
        <div className="flex flex-col items-center gap-3 rounded-md border border-border bg-panel p-8 text-center text-sm text-muted">
          <HeartIcon className="size-10 text-muted/40" />
          <p className="max-w-xs">{t(locale, "grid.no.favorites")}</p>
        </div>
      </section>
    );
  }

  return (
    <section id="favorites" className="space-y-4">
      <div className="flex items-center gap-2">
        <HeartIcon size={18} className="text-accent" aria-hidden="true" />
        <h2 className="text-lg font-semibold">{t(locale, "nav.favorites")}</h2>
      </div>
      <ChannelGrid channels={favoriteChannels} isLoading={false} error={null} />
    </section>
  );
}
