"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { ClockIcon } from "@/components/icons/clock";
import { getWatchHistory } from "@/services/channels";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";
import type { WatchHistory } from "@/types";

export function RecentlyWatched() {
  const router = useRouter();
  const [items, setItems] = useState<WatchHistory[]>([]);
  const setSelectedChannel = useTvStore((state) => state.setSelectedChannel);
  const locale = useTvStore((state) => state.locale);

  useEffect(() => {
    let isMounted = true;

    getWatchHistory()
      .then((history) => {
        if (isMounted) {
          setItems(history.filter((item) => item.channels));
        }
      })
      .catch(() => undefined);

    return () => {
      isMounted = false;
    };
  }, []);

  if (items.length === 0) {
    return (
      <section id="recent" className="space-y-3">
        <div className="flex items-center gap-2">
          <ClockIcon size={18} className="text-accent" aria-hidden="true" />
          <h2 className="text-lg font-semibold">{t(locale, "home.recent")}</h2>
        </div>
        <div className="flex flex-col items-center gap-3 rounded-md border border-border bg-panel p-8 text-center text-sm text-muted">
          <ClockIcon className="size-10 text-muted/40" />
          <p className="max-w-xs">{t(locale, "grid.no.recent")}</p>
        </div>
      </section>
    );
  }

  return (
    <section id="recent" className="space-y-3">
      <div className="flex items-center gap-2">
        <ClockIcon size={18} className="text-accent" aria-hidden="true" />
        <h2 className="text-lg font-semibold">{t(locale, "home.recent")}</h2>
      </div>
      <div className="flex gap-3 overflow-x-auto pb-2">
        {items.map((item) =>
          item.channels ? (
            <button
              key={item.id}
              type="button"
              onClick={() => {
                setSelectedChannel(item.channels ?? null);
                router.push(`/channels/${item.channels!.id}`);
              }}
              className="min-w-52 rounded-md border border-border bg-panel p-3 text-left transition hover:border-accent"
            >
              <div className="truncate font-medium">{item.channels.name}</div>
              <div className="mt-1 text-xs text-muted">
                {new Date(item.watched_at).toLocaleString()}
              </div>
            </button>
          ) : null,
        )}
      </div>
    </section>
  );
}
