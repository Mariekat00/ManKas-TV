import { describe, it, expect, vi, beforeEach } from "vitest";
import { isAdminEmail } from "@/services/auth";

describe("isAdminEmail", () => {
  const OLD_ENV = process.env;

  beforeEach(() => {
    process.env = { ...OLD_ENV };
    process.env.NEXT_PUBLIC_ADMIN_EMAIL = "admin@test.com";
  });

  it("returns false for null/undefined", () => {
    expect(isAdminEmail(null)).toBe(false);
    expect(isAdminEmail(undefined)).toBe(false);
  });

  it("returns false for non-matching email", () => {
    expect(isAdminEmail("user@test.com")).toBe(false);
  });

  it("returns true for matching email", () => {
    expect(isAdminEmail("admin@test.com")).toBe(true);
  });

  it("is case-insensitive", () => {
    expect(isAdminEmail("Admin@Test.com")).toBe(true);
    expect(isAdminEmail("ADMIN@TEST.COM")).toBe(true);
  });

  it("returns false when env var is not set", () => {
    delete process.env.NEXT_PUBLIC_ADMIN_EMAIL;
    expect(isAdminEmail("admin@test.com")).toBe(false);
  });
});
