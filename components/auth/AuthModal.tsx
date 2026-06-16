"use client";

import { useState } from "react";
import { Loader2, X } from "lucide-react";
import { signInWithGoogle, signOut } from "@/services/auth";
import { useTvStore } from "@/store/useTvStore";

export function AuthModal() {
  const authModalOpen = useTvStore((state) => state.authModalOpen);
  const setAuthModalOpen = useTvStore((state) => state.setAuthModalOpen);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  if (!authModalOpen) return null;

  async function handleGoogleSignIn() {
    setIsSubmitting(true);
    setError(null);
    try {
      await signInWithGoogle();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unable to sign in with Google.");
      setIsSubmitting(false);
    }
  }

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4"
      onClick={() => setAuthModalOpen(false)}
    >
      <div
        className="w-full max-w-md rounded-md border border-border bg-panel p-6 shadow-2xl"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-semibold">Admin sign in</h2>
          <button
            type="button"
            onClick={() => setAuthModalOpen(false)}
            className="flex size-8 items-center justify-center rounded-md text-muted hover:text-foreground"
            aria-label="Close"
          >
            <X size={18} />
          </button>
        </div>
        <p className="mt-2 text-sm text-muted">
          Sign in with your authorized Google account to access the admin panel.
        </p>

        {error ? (
          <div className="mt-4 rounded-md border border-red-500/30 bg-red-950/80 p-3 text-sm text-red-100">
            {error}
          </div>
        ) : null}

        <button
          onClick={handleGoogleSignIn}
          disabled={isSubmitting}
          className="mt-6 flex h-12 w-full items-center justify-center gap-3 rounded-md border border-border bg-background text-sm font-medium text-foreground transition hover:bg-accent/10 disabled:cursor-not-allowed disabled:opacity-60"
        >
          {isSubmitting ? (
            <Loader2 size={18} className="animate-spin" />
          ) : (
            <svg viewBox="0 0 24 24" width="18" height="18" xmlns="http://www.w3.org/2000/svg">
              <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 01-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z" fill="#4285F4"/>
              <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
              <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
              <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
            </svg>
          )}
          Sign in with Google
        </button>
      </div>
    </div>
  );
}
