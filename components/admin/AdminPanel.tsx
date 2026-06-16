"use client";

import { FormEvent, useMemo, useState } from "react";
import { FileUp, Plus, Trash2 } from "lucide-react";
import { parseM3U } from "@/lib/m3u";
import { createChannel, deleteChannel, importIptvPlaylist } from "@/services/channels";
import { useChannels } from "@/hooks/useChannels";
import type { ChannelInsert, M3UChannel } from "@/types";

const emptyChannel: ChannelInsert = {
  name: "",
  logo: "",
  stream_url: "",
  category: "General",
  country: "",
  language: "",
};

export function AdminPanel() {
  const { channels, isLoading, error } = useChannels();
  const [form, setForm] = useState<ChannelInsert>(emptyChannel);
  const [m3uText, setM3uText] = useState("");
  const [status, setStatus] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const parsedChannels = useMemo(() => parseM3U(m3uText), [m3uText]);

  async function submitChannel(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsSubmitting(true);
    setStatus(null);

    try {
      await createChannel(normalizeChannel(form));
      setForm(emptyChannel);
      setStatus("Channel added.");
    } catch (submitError) {
      setStatus(submitError instanceof Error ? submitError.message : "Unable to add channel.");
    } finally {
      setIsSubmitting(false);
    }
  }

  async function importParsedChannels() {
    setIsSubmitting(true);
    setStatus(null);

    try {
      for (const channel of parsedChannels) {
        await createChannel(normalizeChannel(channel));
      }

      setM3uText("");
      setStatus(`${parsedChannels.length} channels imported.`);
    } catch (importError) {
      setStatus(importError instanceof Error ? importError.message : "Unable to import channels.");
    } finally {
      setIsSubmitting(false);
    }
  }

  async function removeChannel(id: string) {
    setStatus(null);

    try {
      await deleteChannel(id);
      setStatus("Channel deleted.");
    } catch (deleteError) {
      setStatus(deleteError instanceof Error ? deleteError.message : "Unable to delete channel.");
    }
  }

  return (
    <div className="mx-auto flex max-w-6xl flex-col gap-6 px-4 py-6 sm:px-6">
      <header>
        <p className="text-sm font-medium uppercase tracking-[0.22em] text-accent">Admin mode</p>
        <h1 className="mt-3 text-3xl font-semibold">Channel management</h1>
        <p className="mt-2 max-w-2xl text-sm leading-6 text-muted">
          Add only legal public IPTV streams. Admin writes require `SUPABASE_SERVICE_ROLE_KEY` on
          the server.
        </p>
      </header>

      {status ? (
        <div className="rounded-md border border-border bg-panel p-3 text-sm text-muted">{status}</div>
      ) : null}

      <section className="grid gap-4 lg:grid-cols-[minmax(0,1fr)_420px]">
        <form onSubmit={submitChannel} className="rounded-md border border-border bg-panel p-4">
          <h2 className="flex items-center gap-2 text-lg font-semibold">
            <Plus size={18} className="text-accent" aria-hidden="true" />
            Add channel
          </h2>
          <div className="mt-4 grid gap-3 sm:grid-cols-2">
            <TextField label="Name" value={form.name} required onChange={(name) => setForm({ ...form, name })} />
            <TextField
              label="Stream URL"
              value={form.stream_url}
              required
              onChange={(stream_url) => setForm({ ...form, stream_url })}
            />
            <TextField label="Logo URL" value={form.logo ?? ""} onChange={(logo) => setForm({ ...form, logo })} />
            <TextField
              label="Category"
              value={form.category ?? ""}
              onChange={(category) => setForm({ ...form, category })}
            />
            <TextField
              label="Country"
              value={form.country ?? ""}
              onChange={(country) => setForm({ ...form, country })}
            />
            <TextField
              label="Language"
              value={form.language ?? ""}
              onChange={(language) => setForm({ ...form, language })}
            />
          </div>
          <button
            disabled={isSubmitting}
            className="mt-4 flex h-10 items-center justify-center gap-2 rounded-md bg-accent px-4 text-sm font-medium text-white disabled:cursor-not-allowed disabled:opacity-60"
          >
            <Plus size={16} aria-hidden="true" />
            Add channel
          </button>
        </form>

        <section className="rounded-md border border-border bg-panel p-4">
          <h2 className="flex items-center gap-2 text-lg font-semibold">
            <FileUp size={18} className="text-accent" aria-hidden="true" />
            Import M3U
          </h2>
          <textarea
            value={m3uText}
            onChange={(event) => setM3uText(event.target.value)}
            placeholder="#EXTM3U"
            className="mt-4 min-h-48 w-full rounded-md border border-border bg-background p-3 font-mono text-sm outline-none transition focus:border-accent"
          />
          <div className="mt-3 flex flex-col gap-3 text-sm text-muted sm:flex-row sm:items-center sm:justify-between">
            <span>{parsedChannels.length} parsed</span>
            <div className="flex flex-wrap gap-3">
              <button
                type="button"
                disabled={isSubmitting || parsedChannels.length === 0}
                onClick={importParsedChannels}
                className="flex h-10 items-center justify-center gap-2 rounded-md border border-border px-4 text-foreground disabled:cursor-not-allowed disabled:opacity-60"
              >
                <FileUp size={16} aria-hidden="true" />
                Import
              </button>
              <button
                type="button"
                disabled={isSubmitting}
                onClick={async () => {
                  setIsSubmitting(true);
                  setStatus(null);
                  try {
                    const result = await importIptvPlaylist();
                    setStatus(`Imported ${result.imported ?? 0} new channels from IPTV playlist.`);
                  } catch (importError) {
                    setStatus(importError instanceof Error ? importError.message : "Unable to import IPTV playlist.");
                  } finally {
                    setIsSubmitting(false);
                  }
                }}
                className="flex h-10 items-center justify-center gap-2 rounded-md border border-border px-4 text-foreground disabled:cursor-not-allowed disabled:opacity-60"
              >
                <FileUp size={16} aria-hidden="true" />
                Import IPTV playlist
              </button>
            </div>
          </div>
        </section>
      </section>

      <section className="rounded-md border border-border bg-panel">
        <div className="border-b border-border p-4">
          <h2 className="text-lg font-semibold">Existing channels</h2>
          <p className="mt-1 text-sm text-muted">Delete test or expired streams from Supabase.</p>
        </div>
        {error ? <div className="p-4 text-sm text-muted">{error}</div> : null}
        {isLoading ? <div className="p-4 text-sm text-muted">Loading channels...</div> : null}
        <div className="divide-y divide-border">
          {channels.map((channel) => (
            <div key={channel.id} className="flex items-center justify-between gap-3 p-4">
              <div className="min-w-0">
                <div className="truncate font-medium">{channel.name}</div>
                <div className="mt-1 truncate text-xs text-muted">{channel.stream_url}</div>
              </div>
              <button
                type="button"
                onClick={() => removeChannel(channel.id)}
                className="flex size-10 shrink-0 items-center justify-center rounded-md border border-border text-muted hover:border-accent hover:text-foreground"
                title="Delete channel"
                aria-label={`Delete ${channel.name}`}
              >
                <Trash2 size={16} aria-hidden="true" />
              </button>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}

function TextField({
  label,
  value,
  required,
  onChange,
}: {
  label: string;
  value: string;
  required?: boolean;
  onChange: (value: string) => void;
}) {
  return (
    <label className="space-y-2 text-sm text-muted">
      <span>{label}</span>
      <input
        value={value}
        required={required}
        onChange={(event) => onChange(event.target.value)}
        className="h-10 w-full rounded-md border border-border bg-background px-3 text-foreground outline-none transition focus:border-accent"
      />
    </label>
  );
}

function normalizeChannel(channel: M3UChannel | ChannelInsert): ChannelInsert {
  return {
    name: channel.name.trim(),
    logo: emptyToNull(channel.logo),
    stream_url: channel.stream_url.trim(),
    category: emptyToNull(channel.category) ?? "General",
    country: emptyToNull(channel.country),
    language: emptyToNull(channel.language),
  };
}

function emptyToNull(value: string | null | undefined) {
  const trimmed = value?.trim();
  return trimmed ? trimmed : null;
}
