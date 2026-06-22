import { describe, it, expect } from "vitest";
import { parseM3U } from "@/lib/m3u";

describe("parseM3U", () => {
  it("parses a single channel", () => {
    const input = `#EXTM3U
#EXTINF:-1 tvg-id="1" tvg-logo="https://example.com/logo.png" group-title="Sports",Sports Channel
https://example.com/stream.m3u8`;

    const channels = parseM3U(input);
    expect(channels).toHaveLength(1);
    expect(channels[0].name).toBe("Sports Channel");
    expect(channels[0].logo).toBe("https://example.com/logo.png");
    expect(channels[0].stream_url).toBe("https://example.com/stream.m3u8");
    expect(channels[0].category).toBe("Sports");
  });

  it("parses multiple channels", () => {
    const input = `#EXTM3U
#EXTINF:-1 tvg-id="1" group-title="News",News One
https://example.com/news1.m3u8
#EXTINF:-1 tvg-id="2" group-title="News",News Two
https://example.com/news2.m3u8
#EXTINF:-1 tvg-id="3" group-title="Sports",Sports One
https://example.com/sports1.m3u8`;

    const channels = parseM3U(input);
    expect(channels).toHaveLength(3);
    expect(channels[0].name).toBe("News One");
    expect(channels[1].name).toBe("News Two");
    expect(channels[2].name).toBe("Sports One");
  });

  it("skips lines without a URL", () => {
    const input = `#EXTM3U
#EXTINF:-1 tvg-id="1",No URL
#EXTINF:-1 tvg-id="2",Has URL
https://example.com/stream.m3u8`;

    const channels = parseM3U(input);
    expect(channels).toHaveLength(1);
    expect(channels[0].name).toBe("Has URL");
  });

  it("uses tvg-name as fallback when no comma", () => {
    const input = `#EXTM3U
#EXTINF:-1 tvg-id="1" tvg-name="Named Channel"
https://example.com/stream.m3u8`;

    const channels = parseM3U(input);
    expect(channels).toHaveLength(1);
    expect(channels[0].name).toBe("Named Channel");
  });

  it("falls back to 'Untitled channel'", () => {
    const input = `#EXTM3U
#EXTINF:-1 tvg-id="1"
https://example.com/stream.m3u8`;

    const channels = parseM3U(input);
    expect(channels).toHaveLength(1);
    expect(channels[0].name).toBe("Untitled channel");
  });

  it("defaults category to General", () => {
    const input = `#EXTM3U
#EXTINF:-1 tvg-id="1",Channel
https://example.com/stream.m3u8`;

    const channels = parseM3U(input);
    expect(channels).toHaveLength(1);
    expect(channels[0].category).toBe("General");
  });

  it("returns empty array for empty input", () => {
    expect(parseM3U("")).toEqual([]);
  });

  it("handles Windows line endings", () => {
    const input = "#EXTM3U\r\n#EXTINF:-1 tvg-id=\"1\",Channel\r\nhttps://example.com/stream.m3u8\r\n";
    const channels = parseM3U(input);
    expect(channels).toHaveLength(1);
  });

  it("extracts attributes with special characters in URL values", () => {
    const input = `#EXTM3U
#EXTINF:-1 tvg-id="123" tvg-logo="https://example.com/path?query=1&key=val" group-title="TV & Movies",My Channel
https://example.com/stream.m3u8`;

    const channels = parseM3U(input);
    expect(channels).toHaveLength(1);
    expect(channels[0].logo).toBe("https://example.com/path?query=1&key=val");
    expect(channels[0].category).toBe("TV & Movies");
  });

  it("sets tvg_id when present", () => {
    const input = `#EXTM3U
#EXTINF:-1 tvg-id="abc-123",Channel
https://example.com/stream.m3u8`;

    const channels = parseM3U(input);
    expect(channels[0].tvg_id).toBe("abc-123");
  });

  it("sets tvg_id to undefined when absent", () => {
    const input = `#EXTM3U
#EXTINF:-1,Channel
https://example.com/stream.m3u8`;

    const channels = parseM3U(input);
    expect(channels[0].tvg_id).toBeUndefined();
  });

  it("extracts country and language", () => {
    const input = `#EXTM3U
#EXTINF:-1 tvg-id="1" tvg-country="FR" tvg-language="French",French Channel
https://example.com/stream.m3u8`;

    const channels = parseM3U(input);
    expect(channels[0].country).toBe("FR");
    expect(channels[0].language).toBe("French");
  });
});
