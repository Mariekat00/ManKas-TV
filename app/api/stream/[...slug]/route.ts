import { NextRequest } from "next/server";

export const runtime = "nodejs";

const ALLOWED_HOSTS = [
  // ── Sports ──
  "live.akamized.net",
  "1657061170.rsc.cdn77.org",
  "nbculocallive.akamaized.net",
  "lightning-tracesport-samsungau.amagi.tv",
  "bein-xtra-bein.amagi.tv",
  "dc1644a9jazgj.cloudfront.net",
  "d71gqtnep83vb.cloudfront.net",
  // ── LiveMedia.ma (Arryadia) ──
  "stream-lb.livemediama.com",
  // ── World Cup 2026 ──
  "liveeu-gcp.alkassdigital.net",
  "a.files.bbci.co.uk",
  "daserste-live.ard-mcdn.de",
  // ── Other ──
  "raw.githubusercontent.com",
  "30a-tv.com",
  "streamtv.as3sport.online",
  "5c7b683162943.streamlock.net",
  "streams2.sofast.tv",
  "na.linear.zype.com",
  "videos-fms.jwpltx.com",
  "d4whmvwm0rdvi.cloudfront.net",
  "africa24.vedge.infomaniak.com",
  "goldenboy.duckhunting.playout.vju.tv",
  "rpn.bozztv.com",
  "2-fss-2.streamhoster.com",
  "live.sportstv.com.tr",
  "di-yx2saj20.vo.lswcdn.net",
  "di-g7ij0rwh.vo.lswcdn.net",
  "distribution.sportitalialive.it",
  "streamfree.app",
  // ── IP addresses (keep as-is) ──
  "23.237.104.106",
  "80.194.62.172",
  "151.80.18.177",
  "138.121.15.230",
  "38.75.136.137",
  "190.11.225.124",
  "162.19.255.233",
  "190.60.40.34",
  "45.170.130.224",
];

function isAllowedHost(host: string): boolean {
  try {
    const parsed = new URL(host);
    const hostname = parsed.hostname.toLowerCase();
    return ALLOWED_HOSTS.some(
      (allowed) => hostname === allowed || hostname.endsWith("." + allowed)
    );
  } catch {
    return false;
  }
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ slug: string[] }> }
) {
  const resolvedParams = await params;
  const segments = resolvedParams.slug;

  if (segments.length === 0) {
    return Response.json({ error: "Missing URL path" }, { status: 400 });
  }

  const encodedHost = segments[0];
  let host: string;
  try {
    const std = encodedHost.replace(/-/g, "+").replace(/_/g, "/");
    const padded = std + "=".repeat((4 - (std.length % 4)) % 4);
    host = atob(padded);
  } catch {
    return Response.json({ error: "Invalid host encoding" }, { status: 400 });
  }

  if (!isAllowedHost(host)) {
    return Response.json({ error: "Host not allowed" }, { status: 403 });
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
      return Response.json({ error: `Upstream returned ${upstream.status}` }, { status: upstream.status });
    }

    const contentType = upstream.headers.get("content-type") ?? "application/octet-stream";
    const body = await upstream.arrayBuffer();

    const headers = new Headers();
    headers.set("Content-Type", contentType);
    headers.set("Access-Control-Allow-Origin", "*");
    headers.set("Cache-Control", "public, max-age=30");

    return new Response(body, { status: 200, headers });
  } catch {
    return Response.json({ error: "Proxy fetch failed" }, { status: 502 });
  }
}
