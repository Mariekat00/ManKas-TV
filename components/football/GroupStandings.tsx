"use client";

import { useState } from "react";
import type { FootballGroup, FootballTeam } from "@/types";
import { getTeamFlag } from "@/lib/flags";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";

type Props = {
  groups: FootballGroup[];
  teams: Record<string, FootballTeam>;
};

function getTeamName(teamId: string, teams: Record<string, FootballTeam>): string {
  return teams[teamId]?.name_en || `Team #${teamId}`;
}

export function GroupStandings({ groups, teams }: Props) {
  const [selectedGroup, setSelectedGroup] = useState<string | null>(null);
  const locale = useTvStore((s) => s.locale);

  const filteredGroups = selectedGroup
    ? groups.filter((g) => g.name === selectedGroup)
    : groups;

  const sorted = [...filteredGroups].sort((a, b) => a.name.localeCompare(b.name));

  return (
    <div>
      <div className="mb-4 flex flex-wrap gap-2">
        <button
          type="button"
          onClick={() => setSelectedGroup(null)}
          className={`rounded-md px-3 py-1.5 text-xs font-medium transition ${
            !selectedGroup
              ? "bg-accent text-white"
              : "border border-border bg-panel text-muted hover:bg-panel-strong"
          }`}
        >
          {t(locale, "football.all")}
        </button>
        {sorted.map((g) => (
          <button
            key={g.id || g.name}
            type="button"
            onClick={() => setSelectedGroup(g.name)}
            className={`rounded-md px-3 py-1.5 text-xs font-medium transition ${
              selectedGroup === g.name
                ? "bg-accent text-white"
                : "border border-border bg-panel text-muted hover:bg-panel-strong"
            }`}
          >
            {g.name}
          </button>
        ))}
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        {sorted.map((group) => {
          const teamRows = [...(group.teams || [])].sort(
            (a, b) => b.points - a.points || b.goals_for - a.goals_for
          );
          return (
            <div
              key={group.id || group.name}
              className="overflow-hidden rounded-lg border border-border bg-panel"
            >
              <div className="flex items-center justify-between border-b border-border bg-panel-strong px-4 py-2.5">
                <span className="text-sm font-bold">{t(locale, "football.group")} {group.name}</span>
                <span className="text-xs text-muted">
                  {teamRows.length} {t(locale, "football.teams")}
                </span>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b border-border text-xs text-muted">
                      <th className="px-3 py-2 text-left font-medium">#</th>
                      <th className="px-3 py-2 text-left font-medium">{t(locale, "football.team")}</th>
                      <th className="px-2 py-2 text-center font-medium">{t(locale, "football.mp")}</th>
                      <th className="px-2 py-2 text-center font-medium">{t(locale, "football.w")}</th>
                      <th className="px-2 py-2 text-center font-medium">{t(locale, "football.d")}</th>
                      <th className="px-2 py-2 text-center font-medium">{t(locale, "football.l")}</th>
                      <th className="px-2 py-2 text-center font-medium">{t(locale, "football.gf")}</th>
                      <th className="px-2 py-2 text-center font-medium">{t(locale, "football.ga")}</th>
                      <th className="px-3 py-2 text-center font-medium">{t(locale, "football.pts")}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {teamRows.map((team, i) => (
                      <tr
                        key={team.team_id || i}
                        className={`border-b border-border/50 transition hover:bg-panel-strong ${
                          i < 2 ? "bg-accent/5" : ""
                        }`}
                      >
                        <td className="px-3 py-2.5 text-muted">{i + 1}</td>
                        <td className="px-3 py-2.5 font-medium">
                          <span className="mr-1.5">{getTeamFlag(getTeamName(team.team_id, teams))}</span>
                          {getTeamName(team.team_id, teams)}
                        </td>
                        <td className="px-2 py-2.5 text-center tabular-nums">{team.played}</td>
                        <td className="px-2 py-2.5 text-center tabular-nums">{team.win}</td>
                        <td className="px-2 py-2.5 text-center tabular-nums">{team.draw}</td>
                        <td className="px-2 py-2.5 text-center tabular-nums">{team.goals_for}</td>
                        <td className="px-2 py-2.5 text-center tabular-nums">{team.goals_against}</td>
                        <td className="px-3 py-2.5 text-center font-bold tabular-nums">{team.points}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
