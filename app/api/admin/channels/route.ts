import { NextResponse } from "next/server";
import { getSupabaseAdminClient } from "@/lib/supabaseAdmin";
import { verifyAdminAuth } from "@/lib/adminAuth";
import type { ChannelInsert } from "@/types";

export async function POST(request: Request) {
  if (!(await verifyAdminAuth(request))) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const payload = (await request.json()) as ChannelInsert;
    if (!payload.name || typeof payload.name !== "string" || payload.name.trim().length === 0) {
      return NextResponse.json({ error: "Channel name is required." }, { status: 400 });
    }
    if (!payload.stream_url || typeof payload.stream_url !== "string" || !payload.stream_url.startsWith("http")) {
      return NextResponse.json({ error: "Valid stream URL is required." }, { status: 400 });
    }
    const supabase = getSupabaseAdminClient();
    const { data, error } = await supabase
      .from("channels")
      .insert(payload)
      .select()
      .single();

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 400 });
    }

    return NextResponse.json({ data });
  } catch (error) {
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Unable to add channel." },
      { status: 500 },
    );
  }
}

export async function DELETE(request: Request) {
  if (!(await verifyAdminAuth(request))) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const { id } = (await request.json()) as { id?: string };

    if (!id || typeof id !== "string" || id.length > 100) {
      return NextResponse.json({ error: "Invalid channel id." }, { status: 400 });
    }

    const supabase = getSupabaseAdminClient();
    const { error } = await supabase.from("channels").delete().eq("id", id);

    if (error) {
      return NextResponse.json({ error: error.message }, { status: 400 });
    }

    return NextResponse.json({ ok: true });
  } catch (error) {
    return NextResponse.json(
      { error: error instanceof Error ? error.message : "Unable to delete channel." },
      { status: 500 },
    );
  }
}
