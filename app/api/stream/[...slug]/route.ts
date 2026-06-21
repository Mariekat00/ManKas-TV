import { NextRequest } from "next/server";

export const runtime = "nodejs";

const ALLOWED_HOSTS = [
  "live.akamized.net",
  "cdn77.org",
  "cloudfront.net",
  "videos-fms.jwpltx.com",
  "cloudflare.com",
  "live.medialab.ma",
  "live.media.ma",
  "b4a5d5d5b5e5f5g5h5i5j5k5l5m5n5o5p5q5r5s5t5u5v5w5x5y5z5.alkass.net",
  "live.alkass.net",
  "6cloud.fr",
  "nrjaudio.fm",
  "cgtn.com",
  "dailymotion.com",
  "youtube.com",
  "twitch.tv",
  "jwpcdn.com",
  "jwpltx.com",
  "amagi.tv",
  "23.237.104.106",
  // World Cup 2026 broadcasters
  "queazified.co.uk",
  "canlitvapp.com",
  "80.194.62.172",
  "151.80.18.177",
  "adriatelekom.com",
  "ard-mcdn.de",
  "138.121.15.230",
  "thetvapp.to",
  "38.75.136.137",
  "tvsen7.aynaott.com",
  "190.11.225.124",
  "162.19.255.233",
  "mcdn.br.de",
  "hopslan.com",
  "filegear-sg.me",
  "daserste-live.ard-mcdn.de",
  "streamup.eu",
  "iptv-playoutcenter.de",
  "originstream12.rai.it",
  "aloula-redirect.vercel.app",
  "multistream.it",
  "softwarecreation.it",
  "3catdirectes.cat",
  "190.60.40.34",
  "45.170.130.224",
  "d4whmvwm0rdvi.cloudfront.net",
  "cors-proxy.cooks.fyi",
  "africa24.vedge.infomaniak.com",
  "goldenboy.duckhunting.playout.vju.tv",
  "rpn.bozztv.com",
  "2-fss-2.streamhoster.com",
  "live.sportstv.com.tr",
  "di-yx2saj20.vo.lswcdn.net",
  "di-g7ij0rwh.vo.lswcdn.net",
  "distribution.sportitalialive.it",
  "streamfree.app",
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

  if (!isAllowedHost(host)) {
    return new Response("Host not allowed", { status: 403 });
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
