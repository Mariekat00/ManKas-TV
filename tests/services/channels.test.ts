import { describe, it, expect, vi, beforeEach } from "vitest";

vi.mock("@/lib/mockData", () => ({
  isSupabaseConfigured: vi.fn(),
  mockCategories: [{ id: "1", name: "Sports" }],
  mockChannels: [
    {
      id: "mock-1",
      name: "Mock Channel",
      logo: null,
      stream_url: "https://example.com/stream.m3u8",
      category: "Sports",
      country: "US",
      language: "English",
      created_at: "2024-01-01T00:00:00.000Z",
    },
  ],
  mockFavorites: [] as string[],
  mockWatchHistory: [] as { channel_id: string; watched_at: string }[],
}));

vi.mock("@/lib/supabaseClient", () => ({
  getSupabaseClient: vi.fn(),
  getAuthHeaders: vi.fn(),
}));

const mockData = await import("@/lib/mockData");

import { getChannels, getCategories, addFavorite, removeFavorite, getFavorites, createChannel, deleteChannel } from "@/services/channels";
import { getSupabaseClient, getAuthHeaders } from "@/lib/supabaseClient";

describe("channels service", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockData.mockFavorites.length = 0;
    mockData.mockChannels.length = 0;
    mockData.mockChannels.push({
      id: "mock-1",
      name: "Mock Channel",
      logo: null,
      stream_url: "https://example.com/stream.m3u8",
      category: "Sports",
      country: "US",
      language: "English",
      created_at: "2024-01-01T00:00:00.000Z",
    });
  });

  describe("getChannels", () => {
    it("returns mock channels when Supabase is not configured", async () => {
      vi.mocked(mockData.isSupabaseConfigured).mockReturnValue(false);

      const channels = await getChannels();

      expect(channels).toHaveLength(1);
      expect(channels[0].name).toBe("Mock Channel");
    });
  });

  describe("getCategories", () => {
    it("returns mock categories when Supabase is not configured", async () => {
      vi.mocked(mockData.isSupabaseConfigured).mockReturnValue(false);

      const categories = await getCategories();

      expect(categories).toHaveLength(1);
      expect(categories[0].name).toBe("Sports");
    });
  });

  describe("favorites (mock mode)", () => {
    it("addFavorite adds to mock array", async () => {
      vi.mocked(mockData.isSupabaseConfigured).mockReturnValue(false);

      await addFavorite("channel-1");
      expect(mockData.mockFavorites).toContain("channel-1");
    });

    it("removeFavorite removes from mock array", async () => {
      vi.mocked(mockData.isSupabaseConfigured).mockReturnValue(false);
      mockData.mockFavorites.push("channel-1");

      await removeFavorite("channel-1");
      expect(mockData.mockFavorites).not.toContain("channel-1");
    });

    it("getFavorites returns mock array", async () => {
      vi.mocked(mockData.isSupabaseConfigured).mockReturnValue(false);
      mockData.mockFavorites.push("channel-1", "channel-2");

      const favorites = await getFavorites();
      expect(favorites).toEqual(["channel-1", "channel-2"]);
    });
  });

  describe("createChannel (mock mode)", () => {
    it("creates a channel and adds to mock array", async () => {
      vi.mocked(mockData.isSupabaseConfigured).mockReturnValue(false);

      const channel = await createChannel({
        name: "New Channel",
        stream_url: "https://example.com/new.m3u8",
      });

      expect(channel.name).toBe("New Channel");
      expect(channel.stream_url).toBe("https://example.com/new.m3u8");
      expect(mockData.mockChannels.length).toBe(2);
    });
  });

  describe("deleteChannel (mock mode)", () => {
    it("deletes a channel from mock array", async () => {
      vi.mocked(mockData.isSupabaseConfigured).mockReturnValue(false);

      await deleteChannel("mock-1");
      expect(mockData.mockChannels.find((ch) => ch.id === "mock-1")).toBeUndefined();
    });
  });
});
