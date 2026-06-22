import type { ReactNode } from "react";
import { Navbar } from "@/components/layout/Navbar";
import { Sidebar } from "@/components/layout/Sidebar";
import { AuthModal } from "@/components/auth/AuthModal";
import { OnlineStatusProvider } from "@/components/layout/OnlineStatusProvider";
import { OfflineBanner } from "@/components/layout/OfflineBanner";
import { OnboardingModal } from "@/components/layout/OnboardingModal";

export function AppShell({ children }: { children: ReactNode }) {
  return (
    <OnlineStatusProvider>
      <div className="min-h-screen bg-background">
        <Navbar />
        <OfflineBanner />
        <div className="flex">
          <Sidebar />
          <main className="min-w-0 flex-1">{children}</main>
        </div>
        <AuthModal />
        <OnboardingModal />
      </div>
    </OnlineStatusProvider>
  );
}
