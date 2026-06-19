"use client";

import type { Channel } from "@/types";
import { useTvStore } from "@/store/useTvStore";

export function ChannelFilters({ channels }: { channels: Channel[] }) {
  const category = useTvStore((s) => s.category);
  const country = useTvStore((s) => s.country);
  const query = useTvStore((s) => s.query);
  const showFavoritesOnly = useTvStore((s) => s.showFavoritesOnly);
  const setCategory = useTvStore((s) => s.setCategory);
  const setCountry = useTvStore((s) => s.setCountry);
  const setQuery = useTvStore((s) => s.setQuery);
  const toggleShowFavoritesOnly = useTvStore((s) => s.toggleShowFavoritesOnly);

  const categories = [
    "All",
    ...Array.from(new Set(channels.map((i) => i.category).filter(Boolean) as string[])),
  ];
  const countries = [
    "All",
    ...Array.from(new Set(channels.map((i) => i.country).filter(Boolean) as string[])),
  ];

  return (
    <div className="flex flex-col gap-3">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 className="text-xl font-semibold">Channels</h2>
          <p className="mt-1 text-sm text-muted">Browse public streams by category and region.</p>
        </div>
        <div className="text-sm text-muted">
          {channels.length} channels
        </div>
      </div>

      <div className="flex flex-col gap-2 sm:flex-row sm:items-center">
        <input
          type="text"
          placeholder="Rechercher une chaîne..."
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          className="flex-1 rounded-md border border-border bg-panel px-4 py-2.5 text-sm text-foreground outline-none focus:border-primary"
        />
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
          Favoris
        </button>
        <FilterSelect label="Category" value={category} values={categories} onChange={setCategory} />
        <FilterSelect label="Country" value={country} values={countries} onChange={setCountry} />
      </div>
    </div>
  );
}

function FilterSelect({
  label,
  value,
  values,
  onChange,
}: {
  label: string;
  value: string;
  values: string[];
  onChange: (value: string) => void;
}) {
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
            {item}
          </option>
        ))}
      </select>
    </label>
  );
}
