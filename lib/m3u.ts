import type { M3UChannel } from "@/types";

const attrPattern = /([a-zA-Z0-9_-]+)="([^"]*)"/g;

export function parseM3U(input: string): M3UChannel[] {
  const lines = input
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean);

  const channels: M3UChannel[] = [];

  for (let index = 0; index < lines.length; index += 1) {
    const line = lines[index];

    if (!line.startsWith("#EXTINF")) {
      continue;
    }

    const nextLine = lines[index + 1];
    if (!nextLine || nextLine.startsWith("#")) {
      continue;
    }

    const attrs = new Map<string, string>();
    for (const match of line.matchAll(attrPattern)) {
      attrs.set(match[1].toLowerCase(), match[2]);
    }

    const [, rawName = attrs.get("tvg-name") ?? "Untitled channel"] = line.split(",");

    channels.push({
      tvg_id: attrs.get("tvg-id"),
      name: rawName.trim(),
      logo: attrs.get("tvg-logo") ?? null,
      stream_url: nextLine,
      category: attrs.get("group-title") ?? "General",
      country: attrs.get("tvg-country") ?? null,
      language: attrs.get("tvg-language") ?? null,
    });
  }

  return channels;
}
