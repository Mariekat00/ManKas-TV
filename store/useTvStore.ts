"use client";

import { create } from "zustand";
import type { Channel, PlayerStatus } from "@/types";
import type { Locale } from "@/lib/translations";

type Theme = "dark" | "light";

function getInitialTheme(): Theme {
  if (typeof window === "undefined") return "dark";
  const stored = localStorage.getItem("mankas-theme");
  if (stored === "light" || stored === "dark") return stored;
  return "dark";
}

function getInitialLocale(): Locale {
  if (typeof window === "undefined") return "en";
  const stored = localStorage.getItem("mankas-locale");
  if (stored === "en" || stored === "fr") return stored;
  const browserLang = navigator.language?.startsWith("fr") ? "fr" : "en";
  return browserLang;
}

function getSearchHistory(): string[] {
  if (typeof window === "undefined") return [];
  try {
    const stored = localStorage.getItem("mankas-search");
    if (!stored) return [];
    const parsed = JSON.parse(stored);
    if (Array.isArray(parsed)) return parsed.slice(0, 5);
    return [];
  } catch {
    return [];
  }
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
  locale: Locale;
  searchHistory: string[];
  isOnline: boolean;
  onboardingDone: boolean;
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
  setLocale: (locale: Locale) => void;
  addSearchHistory: (q: string) => void;
  clearSearchHistory: () => void;
  setIsOnline: (online: boolean) => void;
  setOnboardingDone: (done: boolean) => void;
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
  locale: getInitialLocale(),
  searchHistory: getSearchHistory(),
  isOnline: typeof window !== "undefined" ? navigator.onLine : true,
  onboardingDone: typeof window !== "undefined" ? localStorage.getItem("mankas-onboarding") === "1" : true,
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
  setLocale: (locale) => {
    localStorage.setItem("mankas-locale", locale);
    document.cookie = `mankas-locale=${locale};path=/;max-age=31536000`;
    set({ locale });
  },
  addSearchHistory: (q) =>
    set((state) => {
      const next = [q, ...state.searchHistory.filter((s) => s !== q)].slice(0, 5);
      localStorage.setItem("mankas-search", JSON.stringify(next));
      return { searchHistory: next };
    }),
  clearSearchHistory: () => {
    localStorage.removeItem("mankas-search");
    set({ searchHistory: [] });
  },
  setIsOnline: (isOnline) => set({ isOnline }),
  setOnboardingDone: (done) => {
    localStorage.setItem("mankas-onboarding", done ? "1" : "0");
    set({ onboardingDone: done });
  },
}));
