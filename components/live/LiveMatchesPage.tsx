"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { Radio, RefreshCw, Tv } from "lucide-react";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";

type StreamFreeMatch = {
  id: string;
  name: string;
  stream_key: string;
  category: string;
  league: string;
  viewers: number;
  team1?: { name: string; logo: string };
  team2?: { name: string; logo: string };
};

const categoryEmoji: Record<string, string> = {
  soccer: "⚽",
  combat: "🥊",
  basketball: "🏀",
  baseball: "⚾",
  racing: "🏎️",
  tennis: "🎾",
  cricket: "🏏",
  football: "🏈",
  hockey: "🏒",
};

export function LiveMatchesPage() {
  const [matches, setMatches] = useState<StreamFreeMatch[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const locale = useTvStore((s) => s.locale);

  const fetchMatches = async () => {
    setLoading(true);
    setError(null);
    try {
      const res = await fetch("/api/streamfree");
      const data = await res.json();
      setMatches(data.channels || []);
    } catch {
      setError(t(locale, "live.error"));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchMatches();
  }, []);

  return (
    <div className="mx-auto max-w-5xl px-4 py-6 sm:px-6 lg:px-8">
      <div className="mb-8 flex items-center justify-between">
        <div>
          <h1 className="flex items-center gap-2 text-3xl font-bold">
            <Radio className="text-red-500" size={28} />
            {t(locale, "live.title")}
          </h1>
          <p className="mt-2 text-sm text-muted">
            {t(locale, "live.subtitle")}
          </p>
        </div>
        <button
          onClick={fetchMatches}
          disabled={loading}
          className="flex items-center gap-2 rounded-lg border border-border bg-panel px-4 py-2 text-sm text-muted transition hover:bg-panel-strong hover:text-foreground disabled:opacity-50"
        >
          <RefreshCw size={16} className={loading ? "animate-spin" : ""} />
          {t(locale, "live.refresh")}
        </button>
      </div>

      {loading && matches.length === 0 && (
        <div className="flex flex-col items-center justify-center py-20 text-muted">
          <RefreshCw size={32} className="mb-4 animate-spin text-red-500" />
          <p>{t(locale, "live.loading")}</p>
        </div>
      )}

      {error && (
        <div className="rounded-lg border border-red-500/30 bg-red-500/10 p-6 text-center text-red-400">
          {error}
        </div>
      )}

      {!loading && matches.length === 0 && !error && (
        <div className="flex flex-col items-center justify-center py-20 text-muted">
          <Tv size={48} className="mb-4 opacity-30" />
          <p className="text-lg">{t(locale, "live.empty")}</p>
          <p className="mt-2 text-sm">{t(locale, "live.empty.desc")}</p>
        </div>
      )}

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {matches.map((match) => {
          const emoji = categoryEmoji[match.category] || "📺";
          return (
            <Link
              key={match.id}
              href={`/channels/sf-${match.stream_key}`}
              className="group rounded-xl border border-red-500/30 bg-panel p-5 transition hover:border-red-500/60 hover:bg-panel-strong"
            >
              <div className="mb-3 flex items-center gap-2">
                <span className="rounded-md bg-red-500/20 px-2 py-0.5 text-xs font-bold text-red-400">
                  {t(locale, "live.live")}
                </span>
                <span className="text-xs text-muted">
                  {match.viewers > 0 ? `${match.viewers} ${t(locale, "live.viewers")}` : ""}
                </span>
              </div>
              <h3 className="text-lg font-semibold text-foreground group-hover:text-red-400">
                {emoji} {match.name}
              </h3>
              <p className="mt-2 text-xs text-muted">
                {match.league} · {match.category}
              </p>
              {match.team1 && match.team2 && (
                <div className="mt-3 flex items-center gap-3">
                  <div className="flex items-center gap-2">
                    {match.team1.logo && (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img src={match.team1.logo} alt="" className="h-6 w-6 object-contain" />
                    )}
                    <span className="text-sm font-medium">{match.team1.name}</span>
                  </div>
                  <span className="text-xs text-muted">vs</span>
                  <div className="flex items-center gap-2">
                    {match.team2.logo && (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img src={match.team2.logo} alt="" className="h-6 w-6 object-contain" />
                    )}
                    <span className="text-sm font-medium">{match.team2.name}</span>
                  </div>
                </div>
              )}
            </Link>
          );
        })}
      </div>
    </div>
  );
}
