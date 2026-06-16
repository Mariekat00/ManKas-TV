import { getSupabaseClient } from "@/lib/supabaseClient";
import { isSupabaseConfigured } from "@/lib/mockData";

export async function signInWithGoogle() {
  if (!isSupabaseConfigured()) {
    throw new Error("Supabase not configured.");
  }

  const supabase = getSupabaseClient();
  const { error } = await supabase.auth.signInWithOAuth({
    provider: "google",
    options: {
      redirectTo:
        typeof window === "undefined" ? undefined : `${window.location.origin}/`,
    },
  });

  if (error) {
    throw new Error(error.message);
  }
}

export async function signOut() {
  if (!isSupabaseConfigured()) {
    return;
  }

  const supabase = getSupabaseClient();
  const { error } = await supabase.auth.signOut();

  if (error) {
    throw new Error(error.message);
  }
}

export async function getCurrentUser() {
  if (!isSupabaseConfigured()) {
    return null;
  }

  const supabase = getSupabaseClient();
  const { data: { user } } = await supabase.auth.getUser();
  return user;
}

export function isAdminEmail(email: string | undefined | null): boolean {
  if (!email) return false;
  const adminEmail = process.env.NEXT_PUBLIC_ADMIN_EMAIL;
  return !!adminEmail && email.toLowerCase() === adminEmail.toLowerCase();
}
