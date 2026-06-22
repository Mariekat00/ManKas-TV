import Link from "next/link";

export default function NotFound() {
  return (
    <div className="flex min-h-[60vh] flex-col items-center justify-center gap-4">
      <h1 className="text-6xl font-bold text-muted/20">404</h1>
      <p className="text-muted">Page introuvable</p>
      <Link
        href="/"
        className="rounded-lg bg-accent px-6 py-2 text-sm font-medium text-white transition hover:opacity-90"
      >
        Retour à l&apos;accueil
      </Link>
    </div>
  );
}
