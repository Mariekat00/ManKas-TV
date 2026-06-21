import type { Metadata } from "next";
import { AboutPage } from "@/components/about/AboutPage";

export const metadata: Metadata = {
  title: "À propos — ManKas TV",
  description: "À propos de ManKas TV et ManKas Corporation",
};

export default function About() {
  return <AboutPage />;
}
