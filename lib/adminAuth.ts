import { createClient } from "@supabase/supabase-js";

export async function verifyAdminAuth(request: Request): Promise<boolean> {
  const authHeader = request.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return false;
  }

  const token = authHeader.slice(7);
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  const adminEmail = process.env.NEXT_PUBLIC_ADMIN_EMAIL;

  if (!supabaseUrl || !supabaseAnonKey || !adminEmail) {
    return false;
  }

  const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { data: { user }, error } = await supabase.auth.getUser(token);

  if (error || !user) {
    return false;
  }

  return user.email?.toLowerCase() === adminEmail.toLowerCase();
}
