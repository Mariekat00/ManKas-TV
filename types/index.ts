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
