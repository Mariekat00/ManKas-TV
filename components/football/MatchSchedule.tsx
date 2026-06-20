"use client";

import { useState } from "react";
import type { FootballMatch } from "@/types";
import { MatchCard } from "./MatchCard";

type RoundFilter = "all" | "group" | "r32" | "r16" | "qf" | "sf" | "final";

export function MatchSchedule({ matches }: { matches: FootballMatch[] }) {
  const [roundFilter, setRoundFilter] = useState<RoundFilter>("all");
  const [selectedGroup, setSelectedGroup] = useState<string>("all");

  const filteredMatches = matches.filter((m) => {
    if (roundFilter === "group" && m.type !== "group") return false;
    if (roundFilter !== "all" && roundFilter !== "group" && m.type !== roundFilter) return false;
    if (selectedGroup !== "all" && m.group !== selectedGroup) return false;
    return true;
  });

  const sortedMatches = [...filteredMatches].sort((a, b) =>
    a.local_date.localeCompare(b.local_date)
  );

  const groupLetters = [
    ...new Set(matches.filter((m) => m.type === "group").map((m) => m.group)),
  ].sort();

  const rounds: { id: RoundFilter; label: string }[] = [
    { id: "all", label: "Tous" },
    { id: "group", label: "Groupes" },
    { id: "r32", label: "⅛" },
    { id: "r16", label: "¼" },
    { id: "qf", label: "½" },
    { id: "sf", label: "Finale" },
  ];

  const groupedByDate: Record<string, FootballMatch[]> = {};
  for (const match of sortedMatches) {
    const dateKey = match.local_date.split(" ")[0];
    if (!groupedByDate[dateKey]) groupedByDate[dateKey] = [];
    groupedByDate[dateKey].push(match);
  }

  function formatDate(dateStr: string): string {
    const [month, day, year] = dateStr.split("/");
    const d = new Date(Number(year), Number(month) - 1, Number(day));
    return d.toLocaleDateString("fr-FR", {
      weekday: "long",
      day: "numeric",
      month: "long",
    });
  }

  return (
    <div>
      <div className="mb-4 flex flex-wrap gap-2">
        {rounds.map((r) => (
          <button
            key={r.id}
            type="button"
            onClick={() => setRoundFilter(r.id)}
            className={`rounded-md px-3 py-1.5 text-xs font-medium transition ${
              roundFilter === r.id
                ? "bg-accent text-white"
                : "border border-border bg-panel text-muted hover:bg-panel-strong"
            }`}
          >
            {r.label}
          </button>
        ))}
      </div>

      {roundFilter === "group" && (
        <div className="mb-4 flex flex-wrap gap-2">
          <button
            type="button"
            onClick={() => setSelectedGroup("all")}
            className={`rounded-md px-3 py-1.5 text-xs font-medium transition ${
              selectedGroup === "all"
                ? "bg-accent/80 text-white"
                : "border border-border bg-panel text-muted hover:bg-panel-strong"
            }`}
          >
            Tous les groupes
          </button>
          {groupLetters.map((g) => (
            <button
              key={g}
              type="button"
              onClick={() => setSelectedGroup(g)}
              className={`rounded-md px-3 py-1.5 text-xs font-medium transition ${
                selectedGroup === g
                  ? "bg-accent/80 text-white"
                  : "border border-border bg-panel text-muted hover:bg-panel-strong"
              }`}
            >
              {g}
            </button>
          ))}
        </div>
      )}

      {sortedMatches.length === 0 ? (
        <p className="py-12 text-center text-muted">Aucun match trouvé</p>
      ) : (
        Object.entries(groupedByDate).map(([date, dateMatches]) => (
          <section key={date} className="mb-6">
            <h3 className="mb-3 text-sm font-semibold text-muted uppercase">
              {formatDate(date)}
            </h3>
            <div className="grid gap-3 sm:grid-cols-2">
              {dateMatches.map((match) => (
                <MatchCard key={match.id} match={match} />
              ))}
            </div>
          </section>
        ))
      )}

      <p className="mt-6 text-center text-xs text-muted">
        {sortedMatches.length} matchs affichés · Données : worldcup26.ir
      </p>
    </div>
  );
}
