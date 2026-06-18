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

    if (!id) {
      return NextResponse.json({ error: "Channel id is required." }, { status: 400 });
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
