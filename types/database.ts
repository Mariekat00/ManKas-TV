import type { Category, Channel, Favorite, WatchHistory } from "@/types";

export type Database = {
  public: {
    Tables: {
      categories: {
        Row: Category;
        Insert: Omit<Category, "id"> & { id?: string };
        Update: Partial<Omit<Category, "id">>;
        Relationships: [];
      };
      channels: {
        Row: Channel;
        Insert: Omit<Channel, "id" | "created_at"> & {
          id?: string;
          created_at?: string;
        };
        Update: Partial<Omit<Channel, "id" | "created_at">>;
        Relationships: [];
      };
      favorites: {
        Row: Favorite;
        Insert: Omit<Favorite, "id"> & { id?: string };
        Update: Partial<Omit<Favorite, "id">>;
        Relationships: [];
      };
      watch_history: {
        Row: WatchHistory;
        Insert: Omit<WatchHistory, "id" | "watched_at" | "channels"> & {
          id?: string;
          watched_at?: string;
        };
        Update: Partial<Omit<WatchHistory, "id" | "channels">>;
        Relationships: [];
      };
    };
    Views: Record<string, never>;
    Functions: Record<string, never>;
    Enums: Record<string, never>;
    CompositeTypes: Record<string, never>;
  };
};
