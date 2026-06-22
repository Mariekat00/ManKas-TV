import { NextResponse } from "next/server";
import { getServerChannels } from "@/lib/get-channels-server";

export async function GET() {
  return NextResponse.json({ channels: getServerChannels() }, {
    headers: { "Cache-Control": "public, max-age=300" },
  });
}
