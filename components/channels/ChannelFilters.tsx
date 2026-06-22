"use client";

import React, { useState, useRef, useEffect } from "react";
import type { Channel } from "@/types";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";
import { X, Clock } from "lucide-react";

export function ChannelFilters({ channels }: { channels: Channel[] }) {
  const category = useTvStore((s) => s.category);
  const country = useTvStore((s) => s.country);
  const query = useTvStore((s) => s.query);
  const showFavoritesOnly = useTvStore((s) => s.showFavoritesOnly);
  const setCategory = useTvStore((s) => s.setCategory);
  const setCountry = useTvStore((s) => s.setCountry);
  const setQuery = useTvStore((s) => s.setQuery);
  const toggleShowFavoritesOnly = useTvStore((s) => s.toggleShowFavoritesOnly);
  const locale = useTvStore((s) => s.locale);
  const searchHistory = useTvStore((s) => s.searchHistory);
  const addSearchHistory = useTvStore((s) => s.addSearchHistory);
  const clearSearchHistory = useTvStore((s) => s.clearSearchHistory);

  const [showHistory, setShowHistory] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);
  const historyRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function handleClick(e: MouseEvent) {
      if (historyRef.current && !historyRef.current.contains(e.target as Node) &&
          inputRef.current && !inputRef.current.contains(e.target as Node)) {
        setShowHistory(false);
      }
    }
    document.addEventListener("mousedown", handleClick);
    return () => document.removeEventListener("mousedown", handleClick);
  }, []);

  const categories = [
    "All",
    ...Array.from(new Set(channels.map((i) => i.category).filter(Boolean) as string[])),
  ];
  const countries = [
    "All",
    ...Array.from(new Set(channels.map((i) => i.country).filter(Boolean) as string[])),
  ];

  function handleSearchChange(value: string) {
    setQuery(value);
  }

  function handleSearchKeyDown(e: React.KeyboardEvent<HTMLInputElement>) {
    if (e.key === "Enter" && query.trim()) {
      addSearchHistory(query.trim());
      setShowHistory(false);
    }
    if (e.key === "Escape") {
      setShowHistory(false);
      inputRef.current?.blur();
    }
  }

  function handleHistoryClick(item: string) {
    setQuery(item);
    setShowHistory(false);
  }

  return (
    <div className="flex flex-col gap-3">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 className="text-xl font-semibold">{t(locale, "filters.title")}</h2>
          <p className="mt-1 text-sm text-muted">{t(locale, "filters.subtitle")}</p>
        </div>
        <div className="text-sm text-muted">
          {channels.length} {t(locale, "filters.title").toLowerCase()}
        </div>
      </div>

      <div className="flex flex-col gap-2 sm:flex-row sm:items-center">
        <div className="relative flex-1">
          <input
            ref={inputRef}
            type="text"
            placeholder={t(locale, "filters.search")}
            value={query}
            onChange={(e) => handleSearchChange(e.target.value)}
            onFocus={() => setShowHistory(searchHistory.length > 0)}
            onKeyDown={handleSearchKeyDown}
            className="w-full rounded-md border border-border bg-panel px-4 py-2.5 text-sm text-foreground outline-none focus:border-primary"
          />
          {query && (
            <button
              type="button"
              onClick={() => setQuery("")}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-muted hover:text-foreground"
            >
              <X size={16} />
            </button>
          )}
          {showHistory && searchHistory.length > 0 && (
            <div
              ref={historyRef}
              className="absolute left-0 right-0 top-full z-10 mt-1 rounded-md border border-border bg-panel p-2 shadow-xl"
            >
              <div className="mb-1 flex items-center justify-between px-2">
                <span className="text-xs text-muted">Recent</span>
                <button
                  type="button"
                  onClick={clearSearchHistory}
                  className="text-xs text-muted hover:text-foreground"
                >
                  Clear
                </button>
              </div>
              {searchHistory.map((item) => (
                <button
                  key={item}
                  type="button"
                  onClick={() => handleHistoryClick(item)}
                  className="flex w-full items-center gap-2 rounded px-2 py-1.5 text-sm text-muted hover:bg-panel-strong hover:text-foreground"
                >
                  <Clock size={14} aria-hidden="true" />
                  {item}
                </button>
              ))}
            </div>
          )}
        </div>
        <button
          onClick={toggleShowFavoritesOnly}
          className={`flex items-center gap-2 rounded-md border px-4 py-2.5 text-sm transition-colors ${
            showFavoritesOnly
              ? "border-red-500 bg-red-500/20 text-red-400"
              : "border-border bg-panel text-muted hover:border-red-500/50"
          }`}
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill={showFavoritesOnly ? "currentColor" : "none"} stroke="currentColor" strokeWidth="2" className="h-4 w-4">
            <path strokeLinecap="round" strokeLinejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z" />
          </svg>
          {t(locale, "filters.favorites")}
        </button>
        <FilterSelect label={t(locale, "filters.category")} value={category} values={categories} onChange={setCategory} locale={locale} />
        <FilterSelect label={t(locale, "filters.country")} value={country} values={countries} onChange={setCountry} locale={locale} />
      </div>
    </div>
  );
}

const FilterSelect = React.memo(function FilterSelect({
  label,
  value,
  values,
  onChange,
  locale,
}: {
  label: string;
  value: string;
  values: string[];
  onChange: (value: string) => void;
  locale: "en" | "fr";
}) {
  const allLabel = locale === "fr" ? "Tout" : "All";
  return (
    <label className="flex min-w-44 items-center gap-2 rounded-md border border-border bg-panel px-3 py-2.5 text-sm text-muted">
      <span>{label}</span>
      <select
        value={value}
        onChange={(event) => onChange(event.target.value)}
        className="min-w-0 flex-1 bg-transparent text-foreground outline-none"
      >
        {values.map((item) => (
          <option key={item} value={item} className="bg-panel text-foreground">
            {item === "All" ? allLabel : item}
          </option>
        ))}
      </select>
    </label>
  );
});
