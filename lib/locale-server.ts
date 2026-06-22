import { cookies } from "next/headers";
import type { Locale } from "@/lib/translations";

export async function getServerLocale(): Promise<Locale> {
  try {
    const cookieStore = await cookies();
    const locale = cookieStore.get("mankas-locale")?.value;
    if (locale === "en" || locale === "fr") return locale;
  } catch {
    // cookies() may throw in certain contexts
  }
  return "en";
}
