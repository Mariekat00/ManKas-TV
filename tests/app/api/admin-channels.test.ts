import { describe, it, expect, vi, beforeEach } from "vitest";
import { POST, DELETE } from "@/app/api/admin/channels/route";

const mockVerifyAdminAuth = vi.fn();
const mockInsert = vi.fn();
const mockDelete = vi.fn();
const mockSingle = vi.fn();
const mockSelect = vi.fn();

vi.mock("@/lib/adminAuth", () => ({
  verifyAdminAuth: (...args: unknown[]) => mockVerifyAdminAuth(...args),
}));

vi.mock("@/lib/supabaseAdmin", () => ({
  getSupabaseAdminClient: vi.fn(() => ({
    from: vi.fn(() => ({
      insert: vi.fn(() => ({
        select: vi.fn(() => ({
          single: mockSingle,
        })),
      })),
      delete: vi.fn(() => ({
        eq: mockDelete,
      })),
    })),
  })),
}));

describe("POST /api/admin/channels", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockVerifyAdminAuth.mockResolvedValue(true);
  });

  it("returns 401 when unauthorized", async () => {
    mockVerifyAdminAuth.mockResolvedValue(false);

    const request = new Request("https://example.com/api/admin/channels", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name: "Test", stream_url: "https://example.com/stream.m3u8" }),
    });

    const response = await POST(request);
    expect(response.status).toBe(401);
  });

  it("returns 400 when name is missing", async () => {
    const request = new Request("https://example.com/api/admin/channels", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ stream_url: "https://example.com/stream.m3u8" }),
    });

    const response = await POST(request);
    expect(response.status).toBe(400);
    const body = await response.json();
    expect(body.error).toBe("Channel name is required.");
  });

  it("returns 400 when stream_url is missing", async () => {
    const request = new Request("https://example.com/api/admin/channels", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name: "Test" }),
    });

    const response = await POST(request);
    expect(response.status).toBe(400);
    const body = await response.json();
    expect(body.error).toBe("Valid stream URL is required.");
  });

  it("returns 400 when stream_url does not start with http", async () => {
    const request = new Request("https://example.com/api/admin/channels", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name: "Test", stream_url: "ftp://example.com/stream" }),
    });

    const response = await POST(request);
    expect(response.status).toBe(400);
  });

  it("returns 200 on success", async () => {
    const createdChannel = { id: "new-1", name: "Test Channel", stream_url: "https://example.com/stream.m3u8" };
    mockSingle.mockResolvedValue({ data: createdChannel, error: null });

    const request = new Request("https://example.com/api/admin/channels", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name: "Test Channel", stream_url: "https://example.com/stream.m3u8" }),
    });

    const response = await POST(request);
    expect(response.status).toBe(200);
    const body = await response.json();
    expect(body.data.name).toBe("Test Channel");
  });
});

describe("DELETE /api/admin/channels", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    mockVerifyAdminAuth.mockResolvedValue(true);
  });

  it("returns 401 when unauthorized", async () => {
    mockVerifyAdminAuth.mockResolvedValue(false);

    const request = new Request("https://example.com/api/admin/channels", {
      method: "DELETE",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ id: "ch-1" }),
    });

    const response = await DELETE(request);
    expect(response.status).toBe(401);
  });

  it("returns 400 when id is missing", async () => {
    const request = new Request("https://example.com/api/admin/channels", {
      method: "DELETE",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({}),
    });

    const response = await DELETE(request);
    expect(response.status).toBe(400);
    const body = await response.json();
    expect(body.error).toBe("Invalid channel id.");
  });

  it("returns 200 on successful delete", async () => {
    mockDelete.mockResolvedValue({ error: null });

    const request = new Request("https://example.com/api/admin/channels", {
      method: "DELETE",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ id: "ch-1" }),
    });

    const response = await DELETE(request);
    expect(response.status).toBe(200);
    const body = await response.json();
    expect(body.ok).toBe(true);
  });
});
