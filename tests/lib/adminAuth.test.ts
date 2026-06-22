import { describe, it, expect, vi, beforeEach } from "vitest";

const mockGetUser = vi.fn();

vi.mock("@supabase/supabase-js", () => ({
  createClient: vi.fn(() => ({
    auth: {
      getUser: mockGetUser,
    },
  })),
}));

import { verifyAdminAuth } from "@/lib/adminAuth";

describe("verifyAdminAuth", () => {
  const OLD_ENV = process.env;

  beforeEach(() => {
    process.env = { ...OLD_ENV };
    process.env.NEXT_PUBLIC_SUPABASE_URL = "https://test.supabase.co";
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = "test-anon-key";
    process.env.NEXT_PUBLIC_ADMIN_EMAIL = "admin@test.com";
    mockGetUser.mockReset();
  });

  it("returns false when no Authorization header", async () => {
    const request = new Request("https://example.com");
    const result = await verifyAdminAuth(request);
    expect(result).toBe(false);
  });

  it("returns false when header is not Bearer", async () => {
    const request = new Request("https://example.com", {
      headers: { Authorization: "Basic token" },
    });
    const result = await verifyAdminAuth(request);
    expect(result).toBe(false);
  });

  it("returns false when env vars are missing", async () => {
    delete process.env.NEXT_PUBLIC_ADMIN_EMAIL;
    const request = new Request("https://example.com", {
      headers: { Authorization: "Bearer token123" },
    });
    const result = await verifyAdminAuth(request);
    expect(result).toBe(false);
  });

  it("returns false when supabase auth fails", async () => {
    mockGetUser.mockResolvedValue({ data: { user: null }, error: new Error("Invalid token") });
    const request = new Request("https://example.com", {
      headers: { Authorization: "Bearer bad-token" },
    });
    const result = await verifyAdminAuth(request);
    expect(result).toBe(false);
  });

  it("returns false when user email does not match admin", async () => {
    mockGetUser.mockResolvedValue({
      data: { user: { email: "other@test.com" } },
      error: null,
    });
    const request = new Request("https://example.com", {
      headers: { Authorization: "Bearer valid-token" },
    });
    const result = await verifyAdminAuth(request);
    expect(result).toBe(false);
  });

  it("returns true when user email matches admin", async () => {
    mockGetUser.mockResolvedValue({
      data: { user: { email: "admin@test.com" } },
      error: null,
    });
    const request = new Request("https://example.com", {
      headers: { Authorization: "Bearer valid-token" },
    });
    const result = await verifyAdminAuth(request);
    expect(result).toBe(true);
  });

  it("is case-insensitive when comparing emails", async () => {
    mockGetUser.mockResolvedValue({
      data: { user: { email: "Admin@Test.com" } },
      error: null,
    });
    const request = new Request("https://example.com", {
      headers: { Authorization: "Bearer valid-token" },
    });
    const result = await verifyAdminAuth(request);
    expect(result).toBe(true);
  });
});
