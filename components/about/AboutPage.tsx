"use client";

import {
  Code2,
  Eye,
  GraduationCap,
  Info,
  Mail,
  MapPin,
  MessageCircle,
  Phone,
  Palette,
  Rocket,
  Smartphone,
  Sparkles,
  Globe,
  QrCode,
  BookOpen,
  Linkedin,
  Instagram,
  Github,
} from "lucide-react";

export function AboutPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-8 sm:px-6 lg:px-8">
      {/* Header */}
      <div className="mb-10 text-center">
        <div className="mx-auto mb-4 flex size-16 items-center justify-center rounded-2xl bg-accent/15 text-accent">
          <Info size={32} />
        </div>
        <h1 className="text-3xl font-bold tracking-tight text-foreground">
          À propos de l&apos;application
        </h1>
      </div>

      {/* Présentation */}
      <Section title="Présentation">
        <p className="leading-relaxed text-muted">
          <strong>ManKas TV</strong> est une application conçue pour offrir une expérience
          streaming simple, rapide et efficace. Elle permet aux utilisateurs de regarder
          leurs chaînes IPTV favorites, de découvrir des matchs en direct et de profiter
          d&apos;une interface moderne adaptée aux appareils mobiles et web.
        </p>
      </Section>

      {/* Fonctionnalités */}
      <Section title="Fonctionnalités principales">
        <ul className="grid gap-3 sm:grid-cols-2">
          <Feature icon="📺" text="Plus de 4500 chaînes IPTV publiques" />
          <Feature icon="⚽" text="Matchs en direct via StreamFree" />
          <Feature icon="🏆" text="Suivi FIFA World Cup 2026" />
          <Feature icon="❤️" text="Système de favoris" />
          <Feature icon="🔍" text="Recherche par nom, pays, langue" />
          <Feature icon="🎨" text="Thème sombre / clair" />
          <Feature icon="📱" text="Application mobile Flutter" />
          <Feature icon="🌐" text="Version web Next.js" />
        </ul>
      </Section>

      {/* Développeur */}
      <Section title="Développeur">
        <div className="rounded-xl border border-border bg-panel p-6">
          <h3 className="text-lg font-semibold text-foreground">Moïse Manda</h3>
          <p className="mt-1 text-sm text-accent">ManKas Corporation</p>
          <p className="mt-3 text-sm leading-relaxed text-muted">
            Graphiste designer, développeur web et mobile, fondateur de ManKas Corporation.
          </p>
          <div className="mt-4 flex flex-wrap gap-2">
            <SkillTag icon={<Smartphone size={14} />} text="Développement Flutter" />
            <SkillTag icon={<Code2 size={14} />} text="Développement Web" />
            <SkillTag icon={<Palette size={14} />} text="Design graphique" />
            <SkillTag icon={<Sparkles size={14} />} text="Intelligence artificielle" />
            <SkillTag icon={<GraduationCap size={14} />} text="Formation informatique" />
            <SkillTag icon={<Rocket size={14} />} text="Solutions numériques" />
          </div>
        </div>
      </Section>

      {/* ManKas Corporation */}
      <Section title="ManKas Corporation">
        <div className="rounded-xl border border-accent/30 bg-accent/5 p-6">
          <p className="text-center text-lg font-bold italic text-accent">
            &ldquo;L&apos;innovation créatif, rapide et efficace&rdquo;
          </p>
          <div className="mt-6 grid gap-3 sm:grid-cols-2">
            <ServiceItem icon={<Smartphone size={18} />} text="Développement d'applications mobiles" />
            <ServiceItem icon={<Globe size={18} />} text="Création de sites web" />
            <ServiceItem icon={<QrCode size={18} />} text="Solutions QR Code" />
            <ServiceItem icon={<Palette size={18} />} text="Design graphique" />
            <ServiceItem icon={<BookOpen size={18} />} text="Formation informatique" />
            <ServiceItem icon={<Eye size={18} />} text="Conseil numérique" />
          </div>
        </div>
      </Section>

      {/* Contact */}
      <Section title="Contact">
        <div className="grid gap-3 sm:grid-cols-2">
          <ContactItem icon={<Phone size={18} />} label="Téléphone" value="+243 974 037 169" href="tel:+243974037169" />
          <ContactItem icon={<Mail size={18} />} label="Email" value="moisemanda2000@gmail.com" href="mailto:moisemanda2000@gmail.com" />
          <ContactItem icon={<MapPin size={18} />} label="Localisation" value="RDC" />
        </div>
      </Section>

      {/* Réseaux sociaux */}
      <Section title="Réseaux sociaux">
        <div className="grid gap-3 sm:grid-cols-2">
          <SocialLink icon={<MessageCircle size={18} />} label="WhatsApp" href="https://wa.me/message/J7SLDL3BFZFGI1" color="text-green-500" />
          <SocialLink icon={<Send size={18} />} label="Telegram" href="https://t.me/MANKAS1" color="text-blue-400" />
          <SocialLink icon={<Linkedin size={18} />} label="LinkedIn" href="https://www.linkedin.com/in/mo%C3%AFse-manda-499982218" color="text-blue-600" />
          <SocialLink icon={<Instagram size={18} />} label="Instagram" href="https://www.instagram.com/mankascorporation" color="text-pink-500" />
          <SocialLink icon={<Github size={18} />} label="GitHub" href="https://github.com/Mariekat00" color="text-foreground" />
        </div>
      </Section>

      {/* Footer */}
      <div className="mt-12 border-t border-border pt-6 text-center text-sm text-muted">
        <p>Version 1.0.0</p>
        <p className="mt-1">&copy; 2026 ManKas Corporation. Tous droits réservés.</p>
      </div>
    </div>
  );
}

function Send({ size, className }: { size: number; className?: string }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}>
      <path d="M22 2L11 13" /><path d="M22 2L15 22L11 13L2 9L22 2Z" />
    </svg>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="mb-8">
      <h2 className="mb-4 text-xl font-semibold text-foreground">{title}</h2>
      {children}
    </section>
  );
}

function Feature({ icon, text }: { icon: string; text: string }) {
  return (
    <li className="flex items-center gap-3 rounded-lg border border-border bg-panel p-3 text-sm text-muted">
      <span className="text-lg">{icon}</span>
      {text}
    </li>
  );
}

function SkillTag({ icon, text }: { icon: React.ReactNode; text: string }) {
  return (
    <span className="inline-flex items-center gap-1.5 rounded-full border border-border bg-background px-3 py-1 text-xs text-muted">
      {icon}
      {text}
    </span>
  );
}

function ServiceItem({ icon, text }: { icon: React.ReactNode; text: string }) {
  return (
    <div className="flex items-center gap-3 rounded-lg bg-background/50 p-3 text-sm text-muted">
      <span className="text-accent">{icon}</span>
      {text}
    </div>
  );
}

function ContactItem({ icon, label, value, href }: { icon: React.ReactNode; label: string; value: string; href?: string }) {
  const content = (
    <div className="flex items-center gap-3 rounded-lg border border-border bg-panel p-4 text-sm">
      <span className="text-accent">{icon}</span>
      <div>
        <div className="text-xs text-muted">{label}</div>
        <div className="font-medium text-foreground">{value}</div>
      </div>
    </div>
  );

  if (href) {
    return (
      <a href={href} target="_blank" rel="noopener noreferrer" className="transition hover:opacity-80">
        {content}
      </a>
    );
  }
  return content;
}

function SocialLink({ icon, label, href, color }: { icon: React.ReactNode; label: string; href: string; color: string }) {
  return (
    <a
      href={href}
      target="_blank"
      rel="noopener noreferrer"
      className="flex items-center gap-3 rounded-lg border border-border bg-panel p-4 text-sm transition hover:bg-panel-strong"
    >
      <span className={color}>{icon}</span>
      <span className="font-medium text-foreground">{label}</span>
    </a>
  );
}
