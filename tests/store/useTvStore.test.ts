import { describe, it, expect, beforeEach } from "vitest";
import { useTvStore } from "@/store/useTvStore";
import type { Channel } from "@/types";

const sampleChannel: Channel = {
  id: "test-1",
  name: "Test Channel",
  logo: null,
  stream_url: "https://example.com/stream.m3u8",
  category: "Sports",
  country: "US",
  language: "English",
  created_at: "2025-01-01T00:00:00Z",
};

describe("useTvStore", () => {
  beforeEach(() => {
    useTvStore.setState({
      channels: [],
      selectedChannel: null,
      query: "",
      category: "All",
      country: "All",
      favorites: [],
      showFavoritesOnly: false,
      playerStatus: "idle",
      sidebarOpen: false,
      authModalOpen: false,
    });
  });

  it("starts with default state", () => {
    const state = useTvStore.getState();
    expect(state.channels).toEqual([]);
    expect(state.query).toBe("");
    expect(state.category).toBe("All");
    expect(state.playerStatus).toBe("idle");
  });

  it("setChannels updates channels", () => {
    useTvStore.getState().setChannels([sampleChannel]);
    expect(useTvStore.getState().channels).toHaveLength(1);
    expect(useTvStore.getState().channels[0].name).toBe("Test Channel");
  });

  it("setSelectedChannel sets selected channel", () => {
    useTvStore.getState().setSelectedChannel(sampleChannel);
    expect(useTvStore.getState().selectedChannel?.id).toBe("test-1");
  });

  it("setSelectedChannel with null clears selection", () => {
    useTvStore.getState().setSelectedChannel(sampleChannel);
    useTvStore.getState().setSelectedChannel(null);
    expect(useTvStore.getState().selectedChannel).toBeNull();
  });

  it("setQuery updates search query", () => {
    useTvStore.getState().setQuery("football");
    expect(useTvStore.getState().query).toBe("football");
  });

  it("setCategory updates category filter", () => {
    useTvStore.getState().setCategory("News");
    expect(useTvStore.getState().category).toBe("News");
  });

  it("setCountry updates country filter", () => {
    useTvStore.getState().setCountry("France");
    expect(useTvStore.getState().country).toBe("France");
  });

  it("setFavorites replaces favorites array", () => {
    useTvStore.getState().setFavorites(["ch-1", "ch-2"]);
    expect(useTvStore.getState().favorites).toEqual(["ch-1", "ch-2"]);
  });

  it("toggleShowFavoritesOnly toggles the flag", () => {
    expect(useTvStore.getState().showFavoritesOnly).toBe(false);
    useTvStore.getState().toggleShowFavoritesOnly();
    expect(useTvStore.getState().showFavoritesOnly).toBe(true);
    useTvStore.getState().toggleShowFavoritesOnly();
    expect(useTvStore.getState().showFavoritesOnly).toBe(false);
  });

  it("toggleFavoriteLocal adds channel to favorites", () => {
    useTvStore.getState().toggleFavoriteLocal("ch-1");
    expect(useTvStore.getState().favorites).toContain("ch-1");
  });

  it("toggleFavoriteLocal removes channel from favorites", () => {
    useTvStore.getState().toggleFavoriteLocal("ch-1");
    useTvStore.getState().toggleFavoriteLocal("ch-1");
    expect(useTvStore.getState().favorites).not.toContain("ch-1");
  });

  it("setPlayerStatus updates player status", () => {
    useTvStore.getState().setPlayerStatus("loading");
    expect(useTvStore.getState().playerStatus).toBe("loading");
    useTvStore.getState().setPlayerStatus("playing");
    expect(useTvStore.getState().playerStatus).toBe("playing");
    useTvStore.getState().setPlayerStatus("error");
    expect(useTvStore.getState().playerStatus).toBe("error");
  });

  it("setSidebarOpen controls sidebar", () => {
    useTvStore.getState().setSidebarOpen(true);
    expect(useTvStore.getState().sidebarOpen).toBe(true);
  });

  it("setAuthModalOpen controls auth modal", () => {
    useTvStore.getState().setAuthModalOpen(true);
    expect(useTvStore.getState().authModalOpen).toBe(true);
  });
});
