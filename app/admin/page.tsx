"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { getCurrentUser, isAdminEmail, signOut } from "@/services/auth";
import { isSupabaseConfigured } from "@/lib/mockData";
import { AdminPanel } from "@/components/admin/AdminPanel";
import { Loader2, LogOut, ShieldAlert } from "lucide-react";

export default function AdminPage() {
  const router = useRouter();
  const [status, setStatus] = useState<"loading" | "authorized" | "unauthorized" | "no-supabase">("loading");

  useEffect(() => {
    async function check() {
      if (!isSupabaseConfigured()) {
        setStatus("no-supabase");
        return;
      }

      try {
        const user = await getCurrentUser();
        if (user && isAdminEmail(user.email)) {
          setStatus("authorized");
        } else {
          setStatus("unauthorized");
        }
      } catch {
        setStatus("unauthorized");
      }
    }
    check();
  }, []);

  if (status === "loading") {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="flex flex-col items-center gap-3">
          <Loader2 size={32} className="animate-spin text-muted" />
          <p className="text-sm text-muted">Checking access...</p>
        </div>
      </div>
    );
  }

  if (status === "no-supabase") {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="flex flex-col items-center gap-4 text-center">
          <ShieldAlert size={48} className="text-yellow-500" />
          <h1 className="text-xl font-semibold">Supabase not configured</h1>
          <p className="max-w-md text-sm text-muted">
            Set up Supabase environment variables to enable admin authentication.
          </p>
          <button
            onClick={() => router.push("/")}
            className="mt-2 rounded-md bg-accent px-4 py-2 text-sm font-medium text-white"
          >
            Go home
          </button>
        </div>
      </div>
    );
  }

  if (status === "unauthorized") {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="flex flex-col items-center gap-4 text-center">
          <ShieldAlert size={48} className="text-red-500" />
          <h1 className="text-xl font-semibold">Access denied</h1>
          <p className="max-w-md text-sm text-muted">
            Your Google account is not authorized to access the admin panel.
          </p>
          <div className="flex gap-3">
            <button
              onClick={() => router.push("/")}
              className="rounded-md border border-border px-4 py-2 text-sm font-medium text-foreground"
            >
              Go home
            </button>
            <button
              onClick={async () => { await signOut(); router.push("/"); }}
              className="flex items-center gap-2 rounded-md bg-accent px-4 py-2 text-sm font-medium text-white"
            >
              <LogOut size={14} /> Sign out
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div>
      <div className="flex items-center justify-between border-b border-border bg-panel px-4 py-3">
        <span className="text-sm text-muted">Admin Mode</span>
        <button
          onClick={async () => { await signOut(); router.push("/"); }}
          className="flex items-center gap-2 rounded-md border border-border px-3 py-1.5 text-xs text-muted hover:text-foreground"
        >
          <LogOut size={12} /> Sign out
        </button>
      </div>
      <AdminPanel />
    </div>
  );
}
