import { getSupabaseClient } from "@/lib/supabaseClient";
import {
  isSupabaseConfigured,
  mockCategories,
  mockChannels,
  mockFavorites,
  mockWatchHistory,
} from "@/lib/mockData";
import type { Category, Channel, ChannelInsert, WatchHistory } from "@/types";

const CHANNEL_CACHE_TTL = 1000 * 60 * 5;

let channelCache:
  | {
      expiresAt: number;
      data: Channel[];
    }
  | null = null;

let nextMockId = 100;

export async function getChannels() {
  if (channelCache && channelCache.expiresAt > Date.now()) {
    return channelCache.data;
  }

  if (!isSupabaseConfigured()) {
    try {
      const response = await fetch("/api/channels");
      if (response.ok) {
        const data = await response.json();
        channelCache = {
          expiresAt: Date.now() + CHANNEL_CACHE_TTL,
          data: data.channels,
        };
        return channelCache.data;
      }
    } catch {
      // Fallback to mock channels if API fails
    }
    channelCache = {
      expiresAt: Date.now() + CHANNEL_CACHE_TTL,
      data: [...mockChannels],
    };
    return channelCache.data;
  }

  const supabase = getSupabaseClient();
  const { data, error } = await supabase
    .from("channels")
    .select("*")
    .order("name", { ascending: true });

  if (error) {
    throw new Error(error.message);
  }

  channelCache = {
    expiresAt: Date.now() + CHANNEL_CACHE_TTL,
    data: data ?? [],
  };

  return channelCache.data;
}

export async function getChannel(id: string) {
  if (!isSupabaseConfigured()) {
    const channels = await getChannels();
    const channel = channels.find((ch) => ch.id === id);
    if (!channel) throw new Error("Channel not found.");
    return channel;
  }

  const supabase = getSupabaseClient();
  const { data, error } = await supabase.from("channels").select("*").eq("id", id).single();

  if (error) {
    throw new Error(error.message);
  }

  return data;
}

export async function getCategories() {
  if (!isSupabaseConfigured()) {
    return mockCategories;
  }

  const supabase = getSupabaseClient();
  const { data, error } = await supabase
    .from("categories")
    .select("*")
    .order("name", { ascending: true });

  if (error) {
    throw new Error(error.message);
  }

  return (data ?? []) as Category[];
}

export async function addFavorite(channelId: string) {
  if (!isSupabaseConfigured()) {
    if (!mockFavorites.includes(channelId)) {
      mockFavorites.push(channelId);
    }
    return;
  }

  const supabase = getSupabaseClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    throw new Error("Sign in to save favorites.");
  }

  const { error } = await supabase
    .from("favorites")
    .upsert({ user_id: user.id, channel_id: channelId }, { onConflict: "user_id,channel_id" });

  if (error) {
    throw new Error(error.message);
  }
}

export async function removeFavorite(channelId: string) {
  if (!isSupabaseConfigured()) {
    const idx = mockFavorites.indexOf(channelId);
    if (idx !== -1) mockFavorites.splice(idx, 1);
    return;
  }

  const supabase = getSupabaseClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    throw new Error("Sign in to manage favorites.");
  }

  const { error } = await supabase
    .from("favorites")
    .delete()
    .eq("user_id", user.id)
    .eq("channel_id", channelId);

  if (error) {
    throw new Error(error.message);
  }
}

export async function getFavorites() {
  if (!isSupabaseConfigured()) {
    return [...mockFavorites];
  }

  const supabase = getSupabaseClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return [];
  }

  const { data, error } = await supabase.from("favorites").select("channel_id").eq("user_id", user.id);

  if (error) {
    throw new Error(error.message);
  }

  return (data ?? []).map((favorite) => favorite.channel_id);
}

export async function addWatchHistory(channelId: string) {
  if (!isSupabaseConfigured()) {
    mockWatchHistory.unshift({ channel_id: channelId, watched_at: new Date().toISOString() });
    return;
  }

  const supabase = getSupabaseClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return;
  }

  const { error } = await supabase
    .from("watch_history")
    .insert({ user_id: user.id, channel_id: channelId });

  if (error) {
    throw new Error(error.message);
  }
}

export async function getWatchHistory() {
  if (!isSupabaseConfigured()) {
    const channels = await getChannels();
    const seen = new Set<string>();
    const recent = mockWatchHistory.filter((item) => {
      if (seen.has(item.channel_id)) return false;
      seen.add(item.channel_id);
      return true;
    });
    return recent.slice(0, 12).map((item) => {
      const channel = channels.find((ch) => ch.id === item.channel_id);
      return {
        id: `wh-${item.channel_id}`,
        user_id: "mock-user",
        channel_id: item.channel_id,
        watched_at: item.watched_at,
        channels: channel ?? null,
      } as WatchHistory;
    });
  }

  const supabase = getSupabaseClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return [] as WatchHistory[];
  }

  const { data, error } = await supabase
    .from("watch_history")
    .select("*, channels(*)")
    .eq("user_id", user.id)
    .order("watched_at", { ascending: false })
    .limit(12);

  if (error) {
    throw new Error(error.message);
  }

  return (data ?? []) as WatchHistory[];
}

export async function createChannel(payload: ChannelInsert) {
  if (!isSupabaseConfigured()) {
    const newChannel: Channel = {
      id: `mock-${nextMockId++}`,
      name: payload.name,
      logo: payload.logo ?? null,
      stream_url: payload.stream_url,
      category: payload.category ?? null,
      country: payload.country ?? null,
      language: payload.language ?? null,
      created_at: new Date().toISOString(),
    };
    mockChannels.push(newChannel);
    channelCache = null;
    return newChannel;
  }

  const response = await fetch("/api/admin/channels", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

  const body = (await response.json()) as { data?: Channel; error?: string };

  if (!response.ok) {
    throw new Error(body.error ?? "Unable to add channel.");
  }

  channelCache = null;
  return body.data;
}

export async function importIptvPlaylist() {
  if (!isSupabaseConfigured()) {
    throw new Error("Supabase is not configured for import.");
  }

  const response = await fetch("/api/admin/import-iptv", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
  });

  const body = (await response.json()) as { imported?: number; total?: number; error?: string };

  if (!response.ok) {
    throw new Error(body.error ?? "Unable to import IPTV playlist.");
  }

  channelCache = null;
  return body;
}

export async function deleteChannel(id: string) {
  if (!isSupabaseConfigured()) {
    const idx = mockChannels.findIndex((ch) => ch.id === id);
    if (idx !== -1) mockChannels.splice(idx, 1);
    channelCache = null;
    return;
  }

  const response = await fetch("/api/admin/channels", {
    method: "DELETE",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ id }),
  });

  const body = (await response.json()) as { error?: string };

  if (!response.ok) {
    throw new Error(body.error ?? "Unable to delete channel.");
  }

  channelCache = null;
}
