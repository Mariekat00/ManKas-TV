import { describe, it, expect, vi, beforeEach } from "vitest";

const mockFetch = vi.fn();
vi.stubGlobal("fetch", mockFetch);

// We import after stubbing fetch
import { GET } from "@/app/api/stream/[...slug]/route";

function encodeHost(host: string): string {
  const b64 = btoa(host);
  return b64.replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

describe("GET /api/stream/[...slug]", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("returns 400 when no segments", async () => {
    const request = new Request("https://example.com/api/stream/");
    const response = await GET(request, { params: Promise.resolve({ slug: [] }) });
    expect(response.status).toBe(400);
  });

  it("returns 400 when host encoding is invalid", async () => {
    const request = new Request("https://example.com/api/stream/invalid!!/path");
    const response = await GET(request, { params: Promise.resolve({ slug: ["invalid!!"] }) });
    expect(response.status).toBe(400);
  });

  it("returns 403 for non-allowed host", async () => {
    const encoded = encodeHost("https://evil.com");
    const request = new Request(`https://example.com/api/stream/${encoded}/stream.m3u8`);
    const response = await GET(request, { params: Promise.resolve({ slug: [encoded, "stream.m3u8"] }) });
    expect(response.status).toBe(403);
  });

  it("returns 502 when upstream fetch fails", async () => {
    mockFetch.mockRejectedValue(new Error("Network error"));

    const encoded = encodeHost("https://live.akamized.net");
    const request = new Request(`https://example.com/api/stream/${encoded}/live/stream.m3u8`);
    const response = await GET(request, {
      params: Promise.resolve({ slug: [encoded, "live", "stream.m3u8"] }),
    });
    expect(response.status).toBe(502);
  });

  it("returns upstream status code on non-ok response", async () => {
    mockFetch.mockResolvedValue({ ok: false, status: 404 });

    const encoded = encodeHost("https://live.akamized.net");
    const request = new Request(`https://example.com/api/stream/${encoded}/live/stream.m3u8`);
    const response = await GET(request, {
      params: Promise.resolve({ slug: [encoded, "live", "stream.m3u8"] }),
    });
    expect(response.status).toBe(404);
  });

  it("proxies successfully with CORS headers", async () => {
    const m3u8Content = "#EXTM3U\n#EXTINF:-1,Test\nhttps://example.com/segment.ts";
    mockFetch.mockResolvedValue({
      ok: true,
      status: 200,
      headers: new Map([["content-type", "application/vnd.apple.mpegurl"]]),
      arrayBuffer: () => Promise.resolve(new TextEncoder().encode(m3u8Content).buffer),
    });

    const encoded = encodeHost("https://live.akamized.net");
    const request = new Request(`https://example.com/api/stream/${encoded}/live/stream.m3u8`);
    const response = await GET(request, {
      params: Promise.resolve({ slug: [encoded, "live", "stream.m3u8"] }),
    });

    expect(response.status).toBe(200);
    expect(response.headers.get("Access-Control-Allow-Origin")).toBe("*");
    expect(response.headers.get("Content-Type")).toBe("application/vnd.apple.mpegurl");
  });

  it("detects allowed hosts by subdomain", async () => {
    mockFetch.mockResolvedValue({
      ok: true,
      status: 200,
      headers: new Map([["content-type", "video/mp2t"]]),
      arrayBuffer: () => Promise.resolve(new ArrayBuffer(0)),
    });

    // subdomain of an allowed CDN should be allowed
    const encoded = encodeHost("https://sub.live.akamized.net");
    const request = new Request(`https://example.com/api/stream/${encoded}/playlist.m3u8`);
    const response = await GET(request, {
      params: Promise.resolve({ slug: [encoded, "playlist.m3u8"] }),
    });

    expect(response.status).toBe(200);
  });
});
