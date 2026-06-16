"use client";

import { useEffect, useMemo, useState } from "react";
import { getChannels, getFavorites } from "@/services/channels";
import { useTvStore } from "@/store/useTvStore";

export function useChannels() {
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const channels = useTvStore((state) => state.channels);
  const query = useTvStore((state) => state.query);
  const category = useTvStore((state) => state.category);
  const country = useTvStore((state) => state.country);
  const setChannels = useTvStore((state) => state.setChannels);
  const setFavorites = useTvStore((state) => state.setFavorites);

  useEffect(() => {
    let isMounted = true;

    async function load() {
      try {
        setIsLoading(true);
        const [channelData, favoriteIds] = await Promise.all([getChannels(), getFavorites()]);

        if (isMounted) {
          setChannels(channelData);
          setFavorites(favoriteIds);
          setError(null);
        }
      } catch (loadError) {
        if (isMounted) {
          setError(loadError instanceof Error ? loadError.message : "Unable to load channels.");
        }
      } finally {
        if (isMounted) {
          setIsLoading(false);
        }
      }
    }

    load();

    return () => {
      isMounted = false;
    };
  }, [setChannels, setFavorites]);

  const filteredChannels = useMemo(() => {
    const normalizedQuery = query.trim().toLowerCase();

    return channels.filter((channel) => {
      const matchesSearch =
        normalizedQuery.length === 0 ||
        channel.name.toLowerCase().includes(normalizedQuery) ||
        channel.country?.toLowerCase().includes(normalizedQuery) ||
        channel.language?.toLowerCase().includes(normalizedQuery);

      const matchesCategory = category === "All" || channel.category === category;
      const matchesCountry = country === "All" || channel.country === country;

      return matchesSearch && matchesCategory && matchesCountry;
    });
  }, [category, channels, country, query]);

  return {
    channels,
    filteredChannels,
    isLoading,
    error,
  };
}
