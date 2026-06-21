"use client";

export default function ErrorPage({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div className="flex min-h-96 items-center justify-center">
      <div className="max-w-md rounded-md border border-red-500/30 bg-red-950/80 p-6 text-center">
        <h2 className="text-lg font-semibold text-red-100">Something went wrong</h2>
        <p className="mt-2 text-sm text-red-200/80">
          {error.message || "An unexpected error occurred."}
        </p>
        <button
          type="button"
          onClick={reset}
          className="mt-4 rounded-md bg-accent px-4 py-2 text-sm font-medium text-white transition hover:bg-accent/90"
        >
          Try again
        </button>
      </div>
    </div>
  );
}
