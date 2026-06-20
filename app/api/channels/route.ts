import { NextResponse } from "next/server";
import { readFileSync } from "fs";
import { join } from "path";

export async function GET() {
  try {
    const filePath = join(process.cwd(), "public", "data", "channels.json");
    const content = readFileSync(filePath, "utf-8");
    const channels = JSON.parse(content);
    return NextResponse.json({ channels }, {
      headers: { "Cache-Control": "no-store" },
    });
  } catch (e: unknown) {
    return NextResponse.json({ channels: [], error: String(e) }, {
      headers: { "Cache-Control": "no-store" },
    });
  }
}
