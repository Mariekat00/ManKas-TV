import type { FootballMatch } from "@/types";
import { getTeamFlag } from "@/lib/flags";

function getStatusLabel(match: FootballMatch): string {
  if (match.finished === "TRUE" || match.finished === "true") return "Terminé";
  if (match.time_elapsed === "HT") return "Mi-temps";
  if (match.time_elapsed === "notstarted") return "À venir";
  if (match.time_elapsed === "finished") return "Terminé";
  return `${match.time_elapsed}'`;
}

function isLive(match: FootballMatch): boolean {
  return (
    match.time_elapsed !== "notstarted" &&
    match.time_elapsed !== "finished" &&
    match.finished !== "TRUE" &&
    match.finished !== "true"
  );
}

function getRoundLabel(type: string, group: string): string {
  switch (type) {
    case "r32": return "⅛ de finale";
    case "r16": return "¼ de finale";
    case "qf": return "¼ de finale";
    case "sf": return "½ finale";
    case "third": return "3ème place";
    case "final": return "Finale";
    default: return `Groupe ${group}`;
  }
}

export function MatchCard({ match }: { match: FootballMatch }) {
  const live = isLive(match);
  const status = getStatusLabel(match);
  const homeFlag = getTeamFlag(match.home_team_name_en);
  const awayFlag = getTeamFlag(match.away_team_name_en);
  const homeName = match.home_team_label || match.home_team_name_en || "TBD";
  const awayName = match.away_team_label || match.away_team_name_en || "TBD";
  const hasScore =
    match.finished === "TRUE" ||
    match.finished === "true" ||
    (match.time_elapsed !== "notstarted" && match.time_elapsed !== "");
  const dateStr = match.local_date.split(" ")[0];
  const timeStr = match.local_date.split(" ")[1] || "";

  return (
    <div
      className={`rounded-lg border bg-panel p-4 transition ${
        live
          ? "border-red-500/40 shadow-[0_0_15px_rgba(239,68,68,0.08)]"
          : "border-border hover:border-accent/30"
      }`}
    >
      <div className="mb-2 flex items-center justify-between text-xs text-muted">
        <span>{getRoundLabel(match.type, match.group)}</span>
        <span
          className={`rounded-full px-2 py-0.5 text-xs font-medium ${
            live
              ? "bg-red-500/15 text-red-400"
              : match.finished === "TRUE" || match.finished === "true"
                ? "bg-muted/10 text-muted"
                : "bg-accent/10 text-accent"
          }`}
        >
          {live && (
            <span className="mr-1 inline-block size-1.5 rounded-full bg-red-500 animate-pulse" />
          )}
          {status}
        </span>
      </div>

      <div className="flex items-center justify-between gap-2">
        <div className="flex flex-1 items-center gap-2">
          <span className="text-lg">{homeFlag}</span>
          <span className="text-sm font-medium truncate">{homeName}</span>
        </div>

        {hasScore ? (
          <span className="px-3 text-lg font-bold tabular-nums">
            {match.home_score} - {match.away_score}
          </span>
        ) : (
          <span className="px-3 text-xs text-muted">
            {dateStr} {timeStr}
          </span>
        )}

        <div className="flex flex-1 items-center justify-end gap-2">
          <span className="text-sm font-medium truncate text-right">{awayName}</span>
          <span className="text-lg">{awayFlag}</span>
        </div>
      </div>

      {(match.home_scorers && match.home_scorers !== "null") ||
      (match.away_scorers && match.away_scorers !== "null") ? (
        <div className="mt-3 border-t border-border pt-2 text-xs text-muted">
          {match.home_scorers && match.home_scorers !== "null" && (
            <p>⚽ {match.home_scorers}</p>
          )}
          {match.away_scorers && match.away_scorers !== "null" && (
            <p>⚽ {match.away_scorers}</p>
          )}
        </div>
      ) : null}
    </div>
  );
}
