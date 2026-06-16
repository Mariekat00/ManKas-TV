"use client";

import { FormEvent, useState } from "react";
import { Loader2, Mail, X } from "lucide-react";
import { signInWithEmail } from "@/services/auth";
import { useTvStore } from "@/store/useTvStore";

export function AuthModal() {
  const authModalOpen = useTvStore((state) => state.authModalOpen);
  const setAuthModalOpen = useTvStore((state) => state.setAuthModalOpen);
  const [email, setEmail] = useState("");
  const [status, setStatus] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  if (!authModalOpen) return null;

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsSubmitting(true);
    setStatus(null);

    try {
      await signInWithEmail(email);
      setStatus("Check your email for the sign-in link.");
      setEmail("");
    } catch (err) {
      setStatus(err instanceof Error ? err.message : "Unable to send sign-in link.");
    } finally {
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
          <h2 className="text-lg font-semibold">Sign in</h2>
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
          Enter your email to receive a magic sign-in link.
        </p>

        {status ? (
          <div className="mt-4 rounded-md border border-border bg-background p-3 text-sm text-muted">
            {status}
          </div>
        ) : null}

        <form onSubmit={handleSubmit} className="mt-4 space-y-4">
          <label className="space-y-2 text-sm text-muted">
            <span>Email</span>
            <div className="flex h-10 items-center gap-2 rounded-md border border-border bg-background px-3">
              <Mail size={16} aria-hidden="true" />
              <input
                type="email"
                value={email}
                required
                onChange={(e) => setEmail(e.target.value)}
                placeholder="you@example.com"
                className="w-full bg-transparent text-foreground outline-none placeholder:text-muted"
              />
            </div>
          </label>
          <button
            disabled={isSubmitting}
            className="flex h-10 w-full items-center justify-center gap-2 rounded-md bg-accent text-sm font-medium text-white disabled:cursor-not-allowed disabled:opacity-60"
          >
            {isSubmitting ? <Loader2 size={16} className="animate-spin" /> : null}
            Send sign-in link
          </button>
        </form>
      </div>
    </div>
  );
}
