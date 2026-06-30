"use client";

import { useEffect, useState } from "react";
import type { FootballMatch, FootballGroup, FootballTeam } from "@/types";
import { MatchCard } from "./MatchCard";
import { GroupStandings } from "./GroupStandings";
import { MatchSchedule } from "./MatchSchedule";
import { Trophy, Calendar, BarChart3 } from "lucide-react";
import { LoaderIcon } from "@/components/icons/loader";
import { FrownIcon } from "@/components/icons/frown";
import { SatelliteDishIcon } from "@/components/icons/satellite-dish";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";

type Tab = "today" | "standings" | "schedule";

export function FootballPage() {
  const [tab, setTab] = useState<Tab>("today");
  const [matches, setMatches] = useState<FootballMatch[]>([]);
  const [groups, setGroups] = useState<FootballGroup[]>([]);
  const [teams, setTeams] = useState<Record<string, FootballTeam>>({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const locale = useTvStore((s) => s.locale);

  useEffect(() => {
    async function fetchData() {
      try {
        const [matchRes, groupRawRes, teamRawRes] = await Promise.all([
          fetch("https://worldcup26.ir/api/matches"),
          fetch("https://worldcup26.ir/api/groups"),
          fetch("https://worldcup26.ir/api/teams"),
        ]);

        const matchData = await matchRes.json();
        const groupRaw = await groupRawRes.json();
        const teamRaw = await teamRawRes.json();

        const groupMap: Record<string, FootballGroup> = {};
        for (const g of groupRaw?.data ?? []) {
          const name = g.name?.replace("Group ", "") ?? "?";
          groupMap[name] = {
            id: g.id,
            name,
            teams: g.teams?.map((t: { team_id: string; played: string; win: string; draw: string; lose: string; goals_for: string; goals_against: string; points: string }) => ({
              team_id: t.team_id,
              played: Number(t.played),
              win: Number(t.win),
              draw: Number(t.draw),
              lose: Number(t.lose),
              goals_for: Number(t.goals_for),
              goals_against: Number(t.goals_against),
              points: Number(t.points),
            })) ?? [],
          };
        }

        setMatches(matchData?.data ?? []);
        setGroups(Object.values(groupMap));
        setTeams(teamRaw?.data ?? {});
      } catch {
        setError(t(locale, "football.error"));
      } finally {
        setLoading(false);
      }
    }

    fetchData();
  }, [locale]);

  const todayMatches = matches.filter((m) => {
    const todayStr = new Date().toLocaleDateString("en-US", {
      month: "2-digit",
      day: "2-digit",
      year: "numeric",
    }).replace(/\//g, "/");
    const matchDate = m.local_date?.split(" ")[0];
    return matchDate === todayStr;
  });

  const tabs: { id: Tab; icon: typeof Trophy; labelKey: string }[] = [
    { id: "today", icon: Trophy, labelKey: "football.today" },
    { id: "standings", icon: BarChart3, labelKey: "football.standings" },
    { id: "schedule", icon: Calendar, labelKey: "football.schedule" },
  ];

  if (loading) {
    return (
      <div className="mx-auto max-w-5xl px-4 py-12 text-center">
        <LoaderIcon size={40} className="mx-auto text-muted" />
        <p className="mt-4 text-sm text-muted">{t(locale, "common.loading")}</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="mx-auto max-w-5xl px-4 py-12 text-center">
        <div className="flex flex-col items-center gap-3">
          <FrownIcon className="size-10 text-muted/60" />
          <p className="text-muted">{error}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-5xl px-4 py-6 sm:px-6 lg:px-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold">
          <Trophy className="mr-2 inline-block text-yellow-500" size={28} />
          {t(locale, "football.title")}
        </h1>
        <p className="mt-2 text-sm text-muted">
          {t(locale, "football.subtitle")}
        </p>
      </div>

      <div className="mb-6 flex gap-2 border-b border-border">
        {tabs.map(({ id, icon: Icon, labelKey }) => (
          <button
            key={id}
            type="button"
            onClick={() => setTab(id)}
            className={`flex items-center gap-2 border-b-2 px-4 py-3 text-sm font-medium transition ${
              tab === id
                ? "border-accent text-accent"
                : "border-transparent text-muted hover:text-foreground"
            }`}
          >
            <Icon size={16} aria-hidden="true" />
            {t(locale, labelKey)}
          </button>
        ))}
      </div>

      {tab === "today" && (
        <div>
          <h2 className="mb-4 text-lg font-semibold">
            {t(locale, "football.matches.today")} ({todayMatches.length})
          </h2>
          {todayMatches.length > 0 ? (
            <div className="grid gap-3 sm:grid-cols-2">
              {todayMatches.map((m) => (
                <MatchCard key={m.id} match={m} />
              ))}
            </div>
          ) : (
            <div className="flex flex-col items-center gap-3 py-12 text-muted">
              <SatelliteDishIcon className="size-10 text-muted/40" />
              <p>{t(locale, "football.no.matches")}</p>
            </div>
          )}
        </div>
      )}

      {tab === "standings" && <GroupStandings groups={groups} teams={teams} />}

      {tab === "schedule" && <MatchSchedule matches={matches} />}
    </div>
  );
}
