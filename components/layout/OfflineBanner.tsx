"use client";

import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";
import { WifiIcon } from "@/components/icons/wifi";

export function OfflineBanner() {
  const isOnline = useTvStore((state) => state.isOnline);
  const locale = useTvStore((state) => state.locale);

  if (isOnline) return null;

  return (
    <div className="flex items-center justify-center gap-2 bg-yellow-600 px-4 py-2 text-sm font-medium text-white">
      <WifiIcon size={16} aria-hidden="true" />
      <span>{t(locale, "offline.banner")}</span>
    </div>
  );
}
