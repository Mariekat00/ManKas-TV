"use client";

import Link from "next/link";
import { Clock3, Heart, Home, Info, PlusCircle, Tv, Trophy, X } from "lucide-react";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";

export function Sidebar() {
  const sidebarOpen = useTvStore((state) => state.sidebarOpen);
  const setSidebarOpen = useTvStore((state) => state.setSidebarOpen);
  const locale = useTvStore((state) => state.locale);

  const navItems = [
    { href: "/", labelKey: "nav.home", icon: Home },
    { href: "/football", labelKey: "nav.worldcup", icon: Trophy },
    { href: "/#channels", labelKey: "nav.iptv", icon: Tv },
    { href: "/#favorites", labelKey: "nav.favorites", icon: Heart },
    { href: "/#recent", labelKey: "nav.recent", icon: Clock3 },
    { href: "/about", labelKey: "nav.about", icon: Info },
    { href: "/admin", labelKey: "nav.admin", icon: PlusCircle },
  ];

  return (
    <>
      {sidebarOpen ? (
        <div
          className="fixed inset-0 z-50 bg-black/60 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        >
          <aside
            className="flex h-full w-72 flex-col border-r border-border bg-panel p-4 shadow-2xl"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between">
              <span className="text-sm font-semibold">{t(locale, "nav.title")}</span>
              <button
                type="button"
                onClick={() => setSidebarOpen(false)}
                className="flex size-8 items-center justify-center rounded-md text-muted hover:text-foreground"
                aria-label={t(locale, "nav.close")}
              >
                <X size={18} />
              </button>
            </div>
            <nav className="mt-6 flex flex-1 flex-col gap-1">
              {navItems.map((item) => {
                const Icon = item.icon;
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    onClick={() => setSidebarOpen(false)}
                    className="flex h-11 items-center gap-3 rounded-md px-3 text-sm text-muted transition hover:bg-panel-strong hover:text-foreground"
                  >
                    <Icon size={18} aria-hidden="true" />
                    {t(locale, item.labelKey)}
                  </Link>
                );
              })}
            </nav>
          </aside>
        </div>
      ) : null}

      <aside className="hidden w-64 shrink-0 border-r border-border bg-panel/60 lg:block">
        <nav className="sticky top-16 flex h-[calc(100vh-4rem)] flex-col gap-1 p-4">
          {navItems.map((item) => {
            const Icon = item.icon;
            return (
              <Link
                key={item.href}
                href={item.href}
                className="flex h-11 items-center gap-3 rounded-md px-3 text-sm text-muted transition hover:bg-panel-strong hover:text-foreground"
              >
                <Icon size={18} aria-hidden="true" />
                {t(locale, item.labelKey)}
              </Link>
            );
          })}

          <div className="mt-auto rounded-md border border-border bg-background p-3 text-xs leading-5 text-muted">
            {t(locale, "sidebar.disclaimer")}
          </div>
        </nav>
      </aside>
    </>
  );
}
