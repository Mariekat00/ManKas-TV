import channelsData from "@/public/data/channels.json";
import type { Channel } from "@/types";

let cached: Channel[] | null = null;

export function getServerChannels(): Channel[] {
  if (cached) return cached;
  const data = channelsData as { channels: Channel[] };
  cached = data.channels;
  return cached;
}
