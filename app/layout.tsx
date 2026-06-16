import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import { AppShell } from "@/components/layout/AppShell";
import { ThemeController } from "@/components/layout/ThemeController";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "ManKas TV",
  description: "Legal public IPTV streaming platform built with Next.js and Supabase.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased dark`}
      suppressHydrationWarning
    >
      <head>
        <script
          dangerouslySetInnerHTML={{
            __html: `
              (function() {
                var theme = localStorage.getItem('mankas-theme');
                if (theme === 'light' || theme === 'dark') {
                  document.documentElement.className = document.documentElement.className.replace(/\bdark\b|\blight\b/g, '').trim() + ' ' + theme;
                }
              })();
            `,
          }}
        />
      </head>
      <body className="min-h-full bg-background text-foreground">
        <ThemeController />
        <AppShell>{children}</AppShell>
      </body>
    </html>
  );
}
