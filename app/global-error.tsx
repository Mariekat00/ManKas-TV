"use client";

import * as Sentry from "@sentry/nextjs";
import { useEffect, useState } from "react";

function getCookieLocale(): string {
  if (typeof document === "undefined") return "en";
  const match = document.cookie.match(/(?:^|;\s*)mankas-locale=([^;]*)/);
  return match ? match[1] : "en";
}

export default function GlobalError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  const [locale] = useState(getCookieLocale);

  useEffect(() => {
    Sentry.captureException(error);
  }, [error]);

  const isFr = locale === "fr";

  return (
    <html lang={locale}>
      <body className="flex min-h-screen items-center justify-center bg-black p-4">
        <div className="max-w-md rounded-md border border-red-500/30 bg-red-950/80 p-6 text-center">
          <h2 className="text-lg font-semibold text-red-100">
            {isFr ? "Une erreur est survenue" : "Something went wrong"}
          </h2>
          <p className="mt-2 text-sm text-red-200/80">
            {error.message || (isFr ? "Une erreur inattendue s'est produite." : "An unexpected error occurred.")}
          </p>
          <button
            type="button"
            onClick={reset}
            className="mt-4 rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white transition hover:bg-blue-700"
          >
            {isFr ? "Réessayer" : "Try again"}
          </button>
        </div>
      </body>
    </html>
  );
}
