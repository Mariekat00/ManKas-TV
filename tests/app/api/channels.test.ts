import { describe, it, expect } from "vitest";
import { GET } from "@/app/api/channels/route";

describe("GET /api/channels", () => {
  it("returns a list of channels", async () => {
    // Re-import to ensure fresh module
    const response = await GET();
    expect(response.status).toBe(200);

    const body = await response.json();
    expect(body).toHaveProperty("channels");
    expect(Array.isArray(body.channels)).toBe(true);
    expect(body.channels.length).toBeGreaterThan(0);
  });

  it("each channel has required fields", async () => {
    const response = await GET();
    const body = await response.json();

    for (const channel of body.channels) {
      expect(channel).toHaveProperty("id");
      expect(channel).toHaveProperty("name");
      expect(channel).toHaveProperty("stream_url");
      expect(typeof channel.id).toBe("string");
      expect(typeof channel.name).toBe("string");
      expect(typeof channel.stream_url).toBe("string");
    }
  });

  it("includes specific guaranteed channels", async () => {
    const response = await GET();
    const body = await response.json();
    const names = body.channels.map((ch: { name: string }) => ch.name);

    expect(names).toContain("Real Madrid TV");
    expect(names).toContain("Alkass One");
    expect(names).toContain("CazéTV");
  });
});
