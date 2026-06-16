"use client";

import type { Channel } from "@/types";
import { useTvStore } from "@/store/useTvStore";

export function ChannelFilters({ channels }: { channels: Channel[] }) {
  const category = useTvStore((state) => state.category);
  const country = useTvStore((state) => state.country);
  const setCategory = useTvStore((state) => state.setCategory);
  const setCountry = useTvStore((state) => state.setCountry);

  const categories = [
    "All",
    ...Array.from(new Set(channels.map((item) => item.category).filter(isPresent))),
  ];
  const countries = [
    "All",
    ...Array.from(new Set(channels.map((item) => item.country).filter(isPresent))),
  ];

  return (
    <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
      <div>
        <h2 className="text-xl font-semibold">Channels</h2>
        <p className="mt-1 text-sm text-muted">Browse public streams by category and region.</p>
      </div>

      <div className="flex flex-col gap-2 sm:flex-row">
        <FilterSelect label="Category" value={category} values={categories} onChange={setCategory} />
        <FilterSelect label="Country" value={country} values={countries} onChange={setCountry} />
      </div>
    </div>
  );
}

function isPresent(value: string | null): value is string {
  return Boolean(value);
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
    <label className="flex min-w-44 items-center gap-2 rounded-md border border-border bg-panel px-3 py-2 text-sm text-muted">
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
