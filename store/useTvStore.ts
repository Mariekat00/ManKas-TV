"use client";

import { create } from "zustand";
import type { Channel, PlayerStatus } from "@/types";

type Theme = "dark" | "light";

function getInitialTheme(): Theme {
  if (typeof window === "undefined") return "dark";
  const stored = localStorage.getItem("mankas-theme");
  if (stored === "light" || stored === "dark") return stored;
  return "dark";
}

type TvState = {
  channels: Channel[];
  selectedChannel: Channel | null;
  query: string;
  category: string;
  country: string;
  favorites: string[];
  showFavoritesOnly: boolean;
  playerStatus: PlayerStatus;
  theme: Theme;
  sidebarOpen: boolean;
  authModalOpen: boolean;
  setChannels: (channels: Channel[]) => void;
  setSelectedChannel: (channel: Channel | null) => void;
  setQuery: (query: string) => void;
  setCategory: (category: string) => void;
  setCountry: (country: string) => void;
  setFavorites: (favorites: string[]) => void;
  toggleShowFavoritesOnly: () => void;
  toggleFavoriteLocal: (channelId: string) => void;
  setPlayerStatus: (status: PlayerStatus) => void;
  toggleTheme: () => void;
  setSidebarOpen: (open: boolean) => void;
  setAuthModalOpen: (open: boolean) => void;
};

export const useTvStore = create<TvState>((set) => ({
  channels: [],
  selectedChannel: null,
  query: "",
  category: "All",
  country: "All",
  favorites: [],
  showFavoritesOnly: false,
  playerStatus: "idle",
  theme: getInitialTheme(),
  sidebarOpen: false,
  authModalOpen: false,
  setChannels: (channels) => set({ channels }),
  setSelectedChannel: (selectedChannel) => set({ selectedChannel }),
  setQuery: (query) => set({ query }),
  setCategory: (category) => set({ category }),
  setCountry: (country) => set({ country }),
  setFavorites: (favorites) => set({ favorites }),
  toggleShowFavoritesOnly: () => set((state) => ({ showFavoritesOnly: !state.showFavoritesOnly })),
  toggleFavoriteLocal: (channelId) =>
    set((state) => ({
      favorites: state.favorites.includes(channelId)
        ? state.favorites.filter((id) => id !== channelId)
        : [...state.favorites, channelId],
    })),
  setPlayerStatus: (playerStatus) => set({ playerStatus }),
  toggleTheme: () =>
    set((state) => {
      const next = state.theme === "dark" ? "light" : "dark";
      localStorage.setItem("mankas-theme", next);
      return { theme: next };
    }),
  setSidebarOpen: (sidebarOpen) => set({ sidebarOpen }),
  setAuthModalOpen: (authModalOpen) => set({ authModalOpen }),
}));
