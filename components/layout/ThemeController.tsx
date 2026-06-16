"use client";

import { useTvStore } from "@/store/useTvStore";
import { useEffect } from "react";

export function ThemeController() {
  const theme = useTvStore((state) => state.theme);

  useEffect(() => {
    document.documentElement.classList.remove("dark", "light");
    document.documentElement.classList.add(theme);
  }, [theme]);

  return null;
}
