import { NextRequest } from "next/server";

export const runtime = "nodejs";

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ slug: string[] }> }
) {
  const resolvedParams = await params;
  const segments = resolvedParams.slug;

  if (segments.length === 0) {
    return new Response("Missing URL path", { status: 400 });
  }

  const encodedHost = segments[0];
  let host: string;
  try {
    const std = encodedHost.replace(/-/g, "+").replace(/_/g, "/");
    const padded = std + "=".repeat((4 - (std.length % 4)) % 4);
    host = atob(padded);
  } catch {
    return new Response("Invalid host encoding", { status: 400 });
  }

  const remainingPath = segments.slice(1).join("/");
  const targetUrl = `${host}/${remainingPath}`;

  try {
    const upstream = await fetch(targetUrl, {
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
      },
      redirect: "follow",
    });

    if (!upstream.ok) {
      return new Response(`Upstream ${upstream.status}`, { status: upstream.status });
    }

    const contentType = upstream.headers.get("content-type") ?? "application/octet-stream";
    const body = await upstream.arrayBuffer();

    const headers = new Headers();
    headers.set("Content-Type", contentType);
    headers.set("Access-Control-Allow-Origin", "*");
    headers.set("Cache-Control", "public, max-age=30");

    return new Response(body, { status: 200, headers });
  } catch {
    return new Response("Proxy fetch failed", { status: 502 });
  }
}
