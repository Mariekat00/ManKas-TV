"use client";

import { useEffect, useState } from "react";
import type { FootballMatch, FootballGroup } from "@/types";
import { MatchCard } from "./MatchCard";
import { GroupStandings } from "./GroupStandings";
import { MatchSchedule } from "./MatchSchedule";
import { Trophy, Calendar, BarChart3, Loader2 } from "lucide-react";

type Tab = "today" | "standings" | "schedule";

export function FootballPage() {
  const [tab, setTab] = useState<Tab>("today");
  const [matches, setMatches] = useState<FootballMatch[]>([]);
  const [groups, setGroups] = useState<FootballGroup[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchData() {
      try {
        const [gamesRes, groupsRes] = await Promise.all([
          fetch("https://worldcup26.ir/get/games"),
          fetch("https://worldcup26.ir/get/groups"),
        ]);
        if (!gamesRes.ok || !groupsRes.ok) throw new Error("Failed to fetch");
        const gamesData = await gamesRes.json();
        const groupsData = await groupsRes.json();
        setMatches(gamesData.games || gamesData);
        setGroups(groupsData.groups || groupsData);
      } catch {
        setError("Impossible de charger les données de la Coupe du Monde.");
      } finally {
        setLoading(false);
      }
    }
    fetchData();
  }, []);

  const now = new Date();
  const todayStr = `${String(now.getMonth() + 1).padStart(2, "0")}/${String(now.getDate()).padStart(2, "0")}/${now.getFullYear()}`;

  const liveMatches = matches.filter(
    (m) =>
      m.time_elapsed !== "notstarted" &&
      m.time_elapsed !== "finished" &&
      m.finished !== "TRUE"
  );

  const todayMatches = matches.filter((m) => {
    const matchDate = m.local_date.split(" ")[0];
    return matchDate === todayStr;
  });

  const upcomingMatches = matches
    .filter(
      (m) =>
        m.time_elapsed === "notstarted" &&
        (m.finished === "FALSE" || m.finished === "false")
    )
    .sort((a, b) => a.local_date.localeCompare(b.local_date))
    .slice(0, 8);

  const tabs = [
    { id: "today" as Tab, label: "Aujourd'hui", icon: Trophy },
    { id: "standings" as Tab, label: "Classements", icon: BarChart3 },
    { id: "schedule" as Tab, label: "Calendrier", icon: Calendar },
  ];

  if (loading) {
    return (
      <div className="flex h-96 items-center justify-center">
        <Loader2 className="size-8 animate-spin text-accent" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex h-96 items-center justify-center">
        <p className="text-muted">{error}</p>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-6xl px-4 py-6">
      <div className="mb-6">
        <h1 className="text-2xl font-bold">
          <span className="mr-2">⚽</span>
          FIFA World Cup 2026
        </h1>
        <p className="mt-1 text-sm text-muted">
          {matches.length} matchs · 12 groupes · USA, Mexique & Canada
        </p>
      </div>

      <div className="mb-6 flex gap-1 rounded-lg border border-border bg-panel p-1">
        {tabs.map((t) => {
          const Icon = t.icon;
          return (
            <button
              key={t.id}
              type="button"
              onClick={() => setTab(t.id)}
              className={`flex flex-1 items-center justify-center gap-2 rounded-md px-4 py-2.5 text-sm font-medium transition ${
                tab === t.id
                  ? "bg-accent text-white"
                  : "text-muted hover:bg-panel-strong hover:text-foreground"
              }`}
            >
              <Icon size={16} />
              {t.label}
            </button>
          );
        })}
      </div>

      {tab === "today" && (
        <div>
          {liveMatches.length > 0 && (
            <section className="mb-8">
              <h2 className="mb-4 flex items-center gap-2 text-lg font-semibold">
                <span className="size-2 rounded-full bg-red-500 animate-pulse" />
                En direct
              </h2>
              <div className="grid gap-4 sm:grid-cols-2">
                {liveMatches.map((match) => (
                  <MatchCard key={match.id} match={match} />
                ))}
              </div>
            </section>
          )}

          {todayMatches.length > 0 && (
            <section className="mb-8">
              <h2 className="mb-4 text-lg font-semibold">
                Matchs du jour ({todayMatches.length})
              </h2>
              <div className="grid gap-4 sm:grid-cols-2">
                {todayMatches.map((match) => (
                  <MatchCard key={match.id} match={match} />
                ))}
              </div>
            </section>
          )}

          {liveMatches.length === 0 && todayMatches.length === 0 && (
            <section className="mb-8">
              <h2 className="mb-4 text-lg font-semibold">
                Aucun match en cours aujourd&apos;hui
              </h2>
            </section>
          )}

          <section>
            <h2 className="mb-4 text-lg font-semibold">Prochains matchs</h2>
            <div className="grid gap-4 sm:grid-cols-2">
              {upcomingMatches.map((match) => (
                <MatchCard key={match.id} match={match} />
              ))}
            </div>
          </section>
        </div>
      )}

      {tab === "standings" && <GroupStandings groups={groups} />}

      {tab === "schedule" && <MatchSchedule matches={matches} />}
    </div>
  );
}
