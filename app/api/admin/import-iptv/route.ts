import { promises as fs } from "fs";
import path from "path";
import { NextResponse } from "next/server";
import { getSupabaseAdminClient } from "@/lib/supabaseAdmin";
import { parseM3U } from "@/lib/m3u";
import type { ChannelInsert } from "@/types";

const BATCH_SIZE = 100;

function normalizeChannel(channel: ChannelInsert): ChannelInsert {
  return {
    name: channel.name.trim(),
    logo: channel.logo ? channel.logo.trim() : null,
    stream_url: channel.stream_url.trim(),
    category: "General",
    country: channel.country?.trim() ?? null,
    language: channel.language?.trim() ?? null,
  };
}

function chunkArray<T>(items: T[], size: number): T[][] {
  const chunks: T[][] = [];
  for (let i = 0; i < items.length; i += size) {
    chunks.push(items.slice(i, i + size));
  }
  return chunks;
}

export async function POST() {
  const playlistPath = path.join(process.cwd(), "IPTV", "playlist.m3u8");

  let playlistText: string;
  try {
    playlistText = await fs.readFile(playlistPath, "utf8");
  } catch (error) {
    return NextResponse.json(
      { error: `Unable to read IPTV playlist at ${playlistPath}. Make sure the repository is cloned and the file exists.` },
      { status: 500 },
    );
  }

  const parsedChannels = parseM3U(playlistText)
    .map(normalizeChannel)
    .filter((channel) => channel.stream_url.length > 0);

  const uniqueChannels = Array.from(
    new Map(parsedChannels.map((channel) => [channel.stream_url, channel])).values(),
  );

  if (uniqueChannels.length === 0) {
    return NextResponse.json({ error: "No channels found in the IPTV playlist." }, { status: 400 });
  }

  const supabase = getSupabaseAdminClient();

  const { data: existingChannels, error: existingError } = await supabase
    .from("channels")
    .select("stream_url");

  if (existingError) {
    return NextResponse.json({ error: existingError.message }, { status: 500 });
  }

  const existingUrls = new Set((existingChannels ?? []).map((row) => row.stream_url));
  const channelsToInsert = uniqueChannels.filter((channel) => !existingUrls.has(channel.stream_url));

  if (channelsToInsert.length === 0) {
    return NextResponse.json({ imported: 0, total: uniqueChannels.length });
  }

  let importedCount = 0;
  const batches = chunkArray(channelsToInsert, BATCH_SIZE);

  for (const batch of batches) {
    const { error } = await supabase.from("channels").insert(batch);
    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }
    importedCount += batch.length;
  }

  return NextResponse.json({ imported: importedCount, total: uniqueChannels.length });
}
