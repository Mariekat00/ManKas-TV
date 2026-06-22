import { describe, it, expect, beforeEach } from "vitest";
import { isSupabaseConfigured, mockCategories, mockChannels } from "@/lib/mockData";

describe("mockData", () => {
  const OLD_ENV = process.env;

  beforeEach(() => {
    process.env = { ...OLD_ENV };
  });

  describe("isSupabaseConfigured", () => {
    it("returns false when URL is missing", () => {
      delete process.env.NEXT_PUBLIC_SUPABASE_URL;
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = "key";
      expect(isSupabaseConfigured()).toBe(false);
    });

    it("returns false when anon key is missing", () => {
      process.env.NEXT_PUBLIC_SUPABASE_URL = "https://example.supabase.co";
      delete process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
      expect(isSupabaseConfigured()).toBe(false);
    });

    it("returns false when URL contains placeholder", () => {
      process.env.NEXT_PUBLIC_SUPABASE_URL = "https://your-project.supabase.co";
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = "your-anon-key";
      expect(isSupabaseConfigured()).toBe(false);
    });

    it("returns true when valid credentials are set", () => {
      process.env.NEXT_PUBLIC_SUPABASE_URL = "https://real-project.supabase.co";
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = "real-anon-key-123";
      expect(isSupabaseConfigured()).toBe(true);
    });
  });

  describe("mock data structures", () => {
    it("has 7 categories", () => {
      expect(mockCategories).toHaveLength(7);
    });

    it("has 12 mock channels", () => {
      expect(mockChannels).toHaveLength(12);
    });

    it("each channel has required fields", () => {
      for (const ch of mockChannels) {
        expect(ch).toHaveProperty("id");
        expect(ch).toHaveProperty("name");
        expect(ch).toHaveProperty("stream_url");
      }
    });
  });
});
