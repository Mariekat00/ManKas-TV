import { NextResponse } from "next/server";
import channelsData from "@/public/data/channels.json";

export async function GET() {
  return NextResponse.json(channelsData, {
    headers: { "Cache-Control": "public, max-age=300" },
  });
}
