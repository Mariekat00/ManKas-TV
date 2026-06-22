import { describe, it, expect } from "vitest";
import { getStreamProxyUrl } from "@/lib/proxy";

describe("getStreamProxyUrl", () => {
  it("encodes host in base64 and keeps path", () => {
    const url = "https://example.com/live/stream.m3u8";
    const result = getStreamProxyUrl(url);

    expect(result).toMatch(/^\/api\/stream\//);
    expect(result).toContain("/live/stream.m3u8");
  });

  it("includes query parameters", () => {
    const url = "https://example.com/stream.m3u8?token=abc&exp=123";
    const result = getStreamProxyUrl(url);

    expect(result).toContain("?token=abc&exp=123");
  });

  it("handles URL with port", () => {
    const url = "https://example.com:8080/live/stream.m3u8";
    const result = getStreamProxyUrl(url);

    expect(result).toMatch(/^\/api\/stream\//);
    expect(result).toContain("/live/stream.m3u8");
  });

  it("returns original URL on invalid input", () => {
    const url = "not-a-valid-url";
    const result = getStreamProxyUrl(url);

    expect(result).toBe(url);
  });

  it("encodes host without trailing slashes", () => {
    const url = "http://cdn.example.com/live/stream.m3u8";
    const result = getStreamProxyUrl(url);

    expect(result).toMatch(/^\/api\/stream\//);
    expect(result).not.toContain("http://");
    expect(result).not.toContain("//");
  });

  it("base64 encoding is reversible to original host", () => {
    const url = "https://cdn.akamai.net/live/channel.m3u8";
    const result = getStreamProxyUrl(url);

    const match = result.match(/^\/api\/stream\/([^/]+)\//);
    expect(match).not.toBeNull();

    const encoded = match![1];
    const std = encoded.replace(/-/g, "+").replace(/_/g, "/");
    const padded = std + "=".repeat((4 - (std.length % 4)) % 4);
    const decoded = atob(padded);

    expect(decoded).toBe("https://cdn.akamai.net");
  });
});
