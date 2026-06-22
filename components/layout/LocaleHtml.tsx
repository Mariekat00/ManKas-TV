"use client";

import { useEffect } from "react";
import { useTvStore } from "@/store/useTvStore";

export function LocaleHtml() {
  const locale = useTvStore((s) => s.locale);

  useEffect(() => {
    document.documentElement.lang = locale;
  }, [locale]);

  return null;
}
