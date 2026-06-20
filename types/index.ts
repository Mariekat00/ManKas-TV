export type Channel = {
  id: string;
  name: string;
  logo: string | null;
  stream_url: string;
  category: string | null;
  country: string | null;
  language: string | null;
  created_at: string;
};

export type Category = {
  id: string;
  name: string;
};

export type Favorite = {
  id: string;
  user_id: string;
  channel_id: string;
};

export type WatchHistory = {
  id: string;
  user_id: string;
  channel_id: string;
  watched_at: string;
  channels?: Channel | null;
};

export type ChannelInsert = Omit<Channel, "id" | "created_at">;

export type M3UChannel = ChannelInsert & {
  tvg_id?: string;
};

export type PlayerStatus = "idle" | "loading" | "playing" | "error";

// ── FIFA World Cup 2026 ──

export type FootballMatch = {
  id: string;
  home_team_id: string;
  away_team_id: string;
  home_team_name_en: string;
  away_team_name_en: string;
  home_score: string;
  away_score: string;
  home_scorers: string;
  away_scorers: string;
  group: string;
  matchday: string;
  local_date: string;
  finished: string;
  time_elapsed: string;
  type: string;
  stadium_id?: string;
  home_team_label?: string;
  away_team_label?: string;
};

export type FootballTeam = {
  id: string;
  name_en: string;
  name_fa: string;
  flag: string;
  fifa_code: string;
  iso2: string;
  group: string;
};

export type FootballGroup = {
  id: string;
  name: string;
  teams: FootballGroupTeam[];
};

export type FootballGroupTeam = {
  team_id: string;
  team_name_en: string;
  played: number;
  win: number;
  draw: number;
  loss: number;
  goals_for: number;
  goals_against: number;
  points: number;
};

export type FootballStadium = {
  id: string;
  name: string;
  city: string;
  country: string;
};
