"use client";

import { useEffect, type ReactNode } from "react";
import { useTvStore } from "@/store/useTvStore";

export function OnlineStatusProvider({ children }: { children: ReactNode }) {
  const setIsOnline = useTvStore((state) => state.setIsOnline);

  useEffect(() => {
    function goOnline() { setIsOnline(true); }
    function goOffline() { setIsOnline(false); }

    setIsOnline(navigator.onLine);
    window.addEventListener("online", goOnline);
    window.addEventListener("offline", goOffline);
    return () => {
      window.removeEventListener("online", goOnline);
      window.removeEventListener("offline", goOffline);
    };
  }, [setIsOnline]);

  return <>{children}</>;
}
