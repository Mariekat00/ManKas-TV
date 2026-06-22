"use client";

import Link from "next/link";
import { LogIn, Menu, Moon, Sun, RadioTower, Search, Languages } from "lucide-react";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";

export function Navbar() {
  const query = useTvStore((state) => state.query);
  const setQuery = useTvStore((state) => state.setQuery);
  const theme = useTvStore((state) => state.theme);
  const toggleTheme = useTvStore((state) => state.toggleTheme);
  const setSidebarOpen = useTvStore((state) => state.setSidebarOpen);
  const setAuthModalOpen = useTvStore((state) => state.setAuthModalOpen);
  const locale = useTvStore((state) => state.locale);
  const setLocale = useTvStore((state) => state.setLocale);
  const addSearchHistory = useTvStore((state) => state.addSearchHistory);

  function handleSearchChange(value: string) {
    setQuery(value);
  }

  function handleSearchKeyDown(e: React.KeyboardEvent<HTMLInputElement>) {
    if (e.key === "Enter" && query.trim()) {
      addSearchHistory(query.trim());
    }
  }

  function toggleLocale() {
    setLocale(locale === "en" ? "fr" : "en");
  }

  return (
    <header className="sticky top-0 z-40 border-b border-border bg-background/92 backdrop-blur">
      <div className="flex h-16 items-center gap-3 px-4 sm:px-6">
        <Link href="/" className="flex min-w-fit items-center gap-2 text-lg font-semibold">
          <span className="flex size-9 items-center justify-center rounded-md bg-accent text-white">
            <RadioTower size={19} aria-hidden="true" />
          </span>
          <span>ManKas TV</span>
        </Link>

        <label className="ml-auto hidden h-10 w-full max-w-md items-center gap-2 rounded-md border border-border bg-panel px-3 text-muted md:flex">
          <Search size={17} aria-hidden="true" />
          <input
            value={query}
            onChange={(event) => handleSearchChange(event.target.value)}
            onKeyDown={handleSearchKeyDown}
            placeholder={t(locale, "search.placeholder")}
            aria-label={t(locale, "search.placeholder")}
            className="w-full bg-transparent text-sm text-foreground outline-none placeholder:text-muted"
          />
        </label>

        <div className="flex items-center gap-2">
          <button
            type="button"
            onClick={toggleLocale}
            className="flex size-10 items-center justify-center rounded-md border border-border bg-panel text-muted hover:text-foreground"
            title={locale === "en" ? "Français" : "English"}
            aria-label={locale === "en" ? "Français" : "English"}
          >
            <Languages size={18} aria-hidden="true" />
          </button>
          <button
            type="button"
            onClick={() => setAuthModalOpen(true)}
            className="flex size-10 items-center justify-center rounded-md border border-border bg-panel text-muted hover:text-foreground"
            title={t(locale, "sign.in")}
            aria-label={t(locale, "sign.in")}
          >
            <LogIn size={18} aria-hidden="true" />
          </button>
          <Link
            href="/admin"
            className="hidden rounded-md border border-border px-3 py-2 text-sm text-muted transition hover:border-accent hover:text-foreground sm:block"
          >
            {t(locale, "nav.admin")}
          </Link>
          <button
            type="button"
            onClick={toggleTheme}
            className="flex size-10 items-center justify-center rounded-md border border-border bg-panel text-muted hover:text-foreground"
            title={theme === "dark" ? t(locale, "light.mode") : t(locale, "dark.mode")}
            aria-label={theme === "dark" ? t(locale, "light.mode") : t(locale, "dark.mode")}
          >
            {theme === "dark" ? <Sun size={18} aria-hidden="true" /> : <Moon size={18} aria-hidden="true" />}
          </button>
          <button
            type="button"
            onClick={() => setSidebarOpen(true)}
            className="flex size-10 items-center justify-center rounded-md border border-border bg-panel text-muted hover:text-foreground lg:hidden"
            title={t(locale, "menu")}
            aria-label={t(locale, "menu")}
          >
            <Menu size={18} aria-hidden="true" />
          </button>
        </div>
      </div>

      <div className="border-t border-border px-4 py-3 md:hidden">
        <label className="flex h-10 items-center gap-2 rounded-md border border-border bg-panel px-3 text-muted">
          <Search size={17} aria-hidden="true" />
          <input
            value={query}
            onChange={(event) => handleSearchChange(event.target.value)}
            onKeyDown={handleSearchKeyDown}
            placeholder={t(locale, "search.placeholder.mobile")}
            aria-label={t(locale, "search.placeholder.mobile")}
            className="w-full bg-transparent text-sm text-foreground outline-none placeholder:text-muted"
          />
        </label>
      </div>
    </header>
  );
}
