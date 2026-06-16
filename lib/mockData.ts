import type { Channel, Category } from "@/types";

export const mockCategories: Category[] = [
  { id: "cat-1", name: "News" },
  { id: "cat-2", name: "Sports" },
  { id: "cat-3", name: "Education" },
  { id: "cat-4", name: "Culture" },
  { id: "cat-5", name: "General" },
  { id: "cat-6", name: "Music" },
  { id: "cat-7", name: "Documentary" },
];

export const mockChannels: Channel[] = [
  {
    id: "ch-1",
    name: "France 24",
    logo: "https://upload.wikimedia.org/wikipedia/commons/6/65/France_24_logo.svg",
    stream_url: "https://france24.mb.tfi-e.co/live/clea/clean-mid.m3u8",
    category: "News",
    country: "France",
    language: "French",
    created_at: "2025-01-01T00:00:00Z",
  },
  {
    id: "ch-2",
    name: "DW News",
    logo: "https://upload.wikimedia.org/wikipedia/commons/7/78/Deutsche_Welle_symbol_2012.svg",
    stream_url: "https://dw.mdstrm.com/live-c/est/dw_deutsch.m3u8",
    category: "News",
    country: "Germany",
    language: "German",
    created_at: "2025-01-01T00:00:00Z",
  },
  {
    id: "ch-3",
    name: "Arte",
    logo: "https://upload.wikimedia.org/wikipedia/commons/3/37/Arte_logo.svg",
    stream_url: "https://arte.mdstrm.com/live-c/est/arte.m3u8",
    category: "Culture",
    country: "France",
    language: "French",
    created_at: "2025-01-01T00:00:00Z",
  },
  {
    id: "ch-4",
    name: "NASA TV",
    logo: "https://upload.wikimedia.org/wikipedia/commons/e/e5/NASA_logo.svg",
    stream_url: "https://ntv1.akamaized.net/hls/live/2014075/NASA-NTV1-HLS/master.m3u8",
    category: "Education",
    country: "United States",
    language: "English",
    created_at: "2025-01-01T00:00:00Z",
  },
  {
    id: "ch-5",
    name: "Bloomberg TV",
    logo: "https://upload.wikimedia.org/wikipedia/commons/5/5d/Bloomberg_logo.svg",
    stream_url: "https://live.bloomberg.com/stream/master.m3u8",
    category: "News",
    country: "United States",
    language: "English",
    created_at: "2025-01-01T00:00:00Z",
  },
  {
    id: "ch-6",
    name: "CCTV",
    logo: "https://upload.wikimedia.org/wikipedia/commons/7/7f/CCTV_Logo.svg",
    stream_url: "https://cctv.mdstrm.com/live-c/est/cctv.m3u8",
    category: "News",
    country: "China",
    language: "Chinese",
    created_at: "2025-01-01T00:00:00Z",
  },
  {
    id: "ch-7",
    name: "NHK World",
    logo: "https://upload.wikimedia.org/wikipedia/commons/1/13/NHK_World_logo.svg",
    stream_url: "https://nhkworld.mdstrm.com/live-c/est/nhkworld.m3u8",
    category: "News",
    country: "Japan",
    language: "English",
    created_at: "2025-01-01T00:00:00Z",
  },
  {
    id: "ch-8",
    name: "RTBF",
    logo: "https://upload.wikimedia.org/wikipedia/commons/1/1a/RTBF_logo.svg",
    stream_url: "https://rtbf.mdstrm.com/live-c/est/rtbf.m3u8",
    category: "General",
    country: "Belgium",
    language: "French",
    created_at: "2025-01-01T00:00:00Z",
  },
  {
    id: "ch-9",
    name: "RTS",
    logo: "https://upload.wikimedia.org/wikipedia/commons/6/6c/RTS_logo.svg",
    stream_url: "https://rts.mdstrm.com/live-c/est/rts.m3u8",
    category: "General",
    country: "Switzerland",
    language: "French",
    created_at: "2025-01-01T00:00:00Z",
  },
  {
    id: "ch-10",
    name: "TV5 Monde",
    logo: "https://upload.wikimedia.org/wikipedia/commons/3/33/TV5Monde_logo.svg",
    stream_url: "https://tv5monde.mdstrm.com/live-c/est/tv5monde.m3u8",
    category: "Culture",
    country: "France",
    language: "French",
    created_at: "2025-01-01T00:00:00Z",
  },
  {
    id: "ch-11",
    name: "Euronews",
    logo: "https://upload.wikimedia.org/wikipedia/commons/6/66/Euronews_logo.svg",
    stream_url: "https://euronews.mdstrm.com/live-c/est/euronews.m3u8",
    category: "News",
    country: "France",
    language: "English",
    created_at: "2025-01-01T00:00:00Z",
  },
  {
    id: "ch-12",
    name: "Al Jazeera",
    logo: "https://upload.wikimedia.org/wikipedia/commons/f/f4/Al_Jazeera_English_logo.svg",
    stream_url: "https://aljazeera.mdstrm.com/live-c/est/aljazeera.m3u8",
    category: "News",
    country: "Qatar",
    language: "English",
    created_at: "2025-01-01T00:00:00Z",
  },
];

export const mockFavorites: string[] = [];
export const mockWatchHistory: Array<{ channel_id: string; watched_at: string }> = [];

export function isSupabaseConfigured(): boolean {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  return Boolean(url && key && !url.includes("your-project") && !key.includes("your-anon"));
}
