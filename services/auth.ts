import { getSupabaseClient } from "@/lib/supabaseClient";
import { isSupabaseConfigured } from "@/lib/mockData";

export async function signInWithEmail(email: string) {
  if (!isSupabaseConfigured()) {
    return;
  }

  const supabase = getSupabaseClient();
  const { error } = await supabase.auth.signInWithOtp({
    email,
    options: {
      emailRedirectTo:
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
