"use client";

import { useState } from "react";
import { useTvStore } from "@/store/useTvStore";
import { t } from "@/lib/translations";
import { RadioTower, Search, Play } from "lucide-react";

const slides = [
  {
    icon: RadioTower,
    titleKey: "onboarding.welcome",
    descKey: "onboarding.welcome.desc",
  },
  {
    icon: Search,
    titleKey: "onboarding.browse",
    descKey: "onboarding.browse.desc",
  },
  {
    icon: Play,
    titleKey: "onboarding.player",
    descKey: "onboarding.player.desc",
  },
];

export function OnboardingModal() {
  const onboardingDone = useTvStore((state) => state.onboardingDone);
  const setOnboardingDone = useTvStore((state) => state.setOnboardingDone);
  const locale = useTvStore((state) => state.locale);
  const [slide, setSlide] = useState(0);

  if (onboardingDone) return null;

  const current = slides[slide];
  const isLast = slide === slides.length - 1;
  const Icon = current.icon;

  function handleNext() {
    if (isLast) {
      setOnboardingDone(true);
    } else {
      setSlide((s) => s + 1);
    }
  }

  function handleSkip() {
    setOnboardingDone(true);
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 px-4">
      <div className="w-full max-w-sm rounded-xl border border-border bg-panel p-8 text-center shadow-2xl">
        <div className="mx-auto flex size-20 items-center justify-center rounded-full bg-accent/20 text-accent">
          <Icon size={40} aria-hidden="true" />
        </div>
        <h2 className="mt-5 text-xl font-semibold">{t(locale, current.titleKey)}</h2>
        <p className="mt-3 text-sm leading-6 text-muted">{t(locale, current.descKey)}</p>

        <div className="mt-6 flex justify-center gap-2">
          {slides.map((_, i) => (
            <span
              key={i}
              className={`block h-2 w-2 rounded-full transition-colors ${
                i === slide ? "bg-accent" : "bg-border"
              }`}
            />
          ))}
        </div>

        <div className="mt-6 flex items-center justify-between">
          <button
            type="button"
            onClick={handleSkip}
            className="text-sm text-muted hover:text-foreground"
          >
            {t(locale, "onboarding.skip")}
          </button>
          <button
            type="button"
            onClick={handleNext}
            className="rounded-md bg-accent px-6 py-2 text-sm font-medium text-white hover:opacity-90"
          >
            {t(locale, isLast ? "onboarding.done" : "onboarding.next")}
          </button>
        </div>
      </div>
    </div>
  );
}
