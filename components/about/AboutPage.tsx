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
          <SocialLink icon={<LinkedinIcon size={18} />} label="LinkedIn" href="https://www.linkedin.com/in/mo%C3%AFse-manda-499982218" color="text-blue-600" />
          <SocialLink icon={<InstagramIcon size={18} />} label="Instagram" href="https://www.instagram.com/mankascorporation" color="text-pink-500" />
          <SocialLink icon={<GithubIcon size={18} />} label="GitHub" href="https://github.com/Mariekat00" color="text-foreground" />
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

function LinkedinIcon({ size, className }: { size: number; className?: string }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor" className={className}>
      <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" />
    </svg>
  );
}

function InstagramIcon({ size, className }: { size: number; className?: string }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor" className={className}>
      <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z" />
    </svg>
  );
}

function GithubIcon({ size, className }: { size: number; className?: string }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="currentColor" className={className}>
      <path d="M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 11.385.6.113.82-.258.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.61-4.042-1.61C4.422 18.07 3.633 17.7 3.633 17.7c-1.087-.744.084-.729.084-.729 1.205.084 1.838 1.236 1.838 1.236 1.07 1.835 2.809 1.305 3.495.998.108-.776.417-1.305.76-1.605-2.665-.3-5.466-1.332-5.466-5.93 0-1.31.465-2.38 1.235-3.22-.135-.303-.54-1.523.105-3.176 0 0 1.005-.322 3.3 1.23.96-.267 1.98-.399 3-.405 1.02.006 2.04.138 3 .405 2.28-1.552 3.285-1.23 3.285-1.23.645 1.653.24 2.873.12 3.176.765.84 1.23 1.91 1.23 3.22 0 4.61-2.805 5.625-5.475 5.92.42.36.81 1.096.81 2.22 0 1.606-.015 2.896-.015 3.286 0 .315.21.69.825.57C20.565 22.092 24 17.592 24 12.297c0-6.627-5.373-12-12-12" />
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
