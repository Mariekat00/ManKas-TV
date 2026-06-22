import { describe, it, expect } from "vitest";
import { getTeamFlag } from "@/lib/flags";

describe("getTeamFlag", () => {
  it("returns flag for known team", () => {
    expect(getTeamFlag("Brazil")).toBe("🇧🇷");
    expect(getTeamFlag("France")).toBe("🇫🇷");
    expect(getTeamFlag("Argentina")).toBe("🇦🇷");
    expect(getTeamFlag("England")).toBe("🏴󠁧󠁢󠁥󠁮󠁧󠁿");
  });

  it("returns white flag for unknown team", () => {
    expect(getTeamFlag("Unknown Team")).toBe("🏳️");
    expect(getTeamFlag("")).toBe("🏳️");
  });

  it("is case-sensitive", () => {
    expect(getTeamFlag("brazil")).toBe("🏳️");
  });
});
