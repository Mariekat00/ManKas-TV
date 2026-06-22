import { NextResponse } from "next/server";

export const runtime = "nodejs";

interface StreamFreeStream {
  id: string;
  name: string;
  stream_key: string;
  match_timestamp: number;
  is_external: boolean;
  category: string;
  league: string;
  team1?: { name: string; logo: string };
  team2?: { name: string; logo: string };
  viewers: number;
}

interface Tokens {
  [quality: string]: { _t: string; _e: number; _n: string };
}

async function fetchTokens(streamKey: string, category: string): Promise<Tokens | null> {
  try {
    const res = await fetch(
      `https://streamfree.app/embed/${category}/${streamKey}`,
      {
        headers: {
          "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
        },
      }
    );
    if (!res.ok) return null;
    const html = await res.text();

    const match = html.match(/const _0x = (\{[\s\S]*?\});/);
    if (!match) return null;
    return JSON.parse(match[1]) as Tokens;
  } catch {
    return null;
  }
}

async function getBestQuality(
  streamKey: string
): Promise<string> {
  try {
    const res = await fetch(
      `https://streamfree.app/api/stream-status/${streamKey}`
    );
    if (!res.ok) return "720p";
    const data = await res.json();
    const q = data.qualities || {};
    if (q["1080p"]) return "1080p";
    if (q["720p"]) return "720p";
    if (q["2160p"]) return "2160p";
    if (q["540p"]) return "540p";
    return "720p";
  } catch {
    return "720p";
  }
}

const categoryEmoji: Record<string, string> = {
  soccer: "⚽",
  combat: "🥊",
  basketball: "🏀",
  baseball: "⚾",
  racing: "🏎️",
  tennis: "🎾",
  cricket: "🏏",
  football: "🏈",
  hockey: "🏒",
};

export async function GET() {
  try {
    const streamsRes = await fetch("https://streamfree.app/streams", {
      headers: {
        "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
      },
    });

    if (!streamsRes.ok) {
      return NextResponse.json({ channels: [] });
    }

    const data = await streamsRes.json();
    const streams = data.streams || {};
    const channels: unknown[] = [];

    for (const [cat, items] of Object.entries(streams) as [
      string,
      StreamFreeStream[]
    ][]) {
      for (const stream of items) {
        const [tokens, quality] = await Promise.all([
          fetchTokens(stream.stream_key, cat),
          getBestQuality(stream.stream_key),
        ]);

        if (!tokens) continue;

        const t = tokens[quality];
        if (!t) continue;

        const emoji = categoryEmoji[cat] || "📺";
        const hlsUrl = `https://streamfree.app/live/${stream.stream_key}${quality}/index.m3u8?_t=${t._t}&_e=${t._e}&_n=${t._n}`;

        channels.push({
          id: `sf-${stream.stream_key}`,
          name: `${emoji} ${stream.name}`,
          logo: stream.team1?.logo || null,
          stream_url: hlsUrl,
          category: "Sports",
          country: "International",
          language: "English",
        });
      }
    }

    return NextResponse.json({ channels });
  } catch {
    console.error("StreamFree API fetch failed");
    return NextResponse.json({ channels: [] });
  }
}
