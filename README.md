# ManKas TV

Application IPTV de streaming de chaînes TV publiques en direct. Construite avec **Next.js 15**, **React 19**, **Tailwind CSS 4** et **hls.js**.

## Fonctionnalités

- **Player HLS** — Lecture de flux `.m3u8` via hls.js avec proxy CORS intégré
- **Support multi-source** — YouTube (iframe), Twitch (iframe), Dailymotion (iframe), HLS (.m3u8)
- **Grille responsive** — Affichage adaptatif de 2 à 6 colonnes selon la taille d'écran
- **Recherche** — Par nom de chaîne, pays ou langue
- **Filtres** — Par catégorie et par pays
- **Favoris** — Sauvegarde locale des chaînes préférées
- **Historique** — Suivi des dernières chaînes regardées
- **Thème dark** — Interface sombre par défaut
- **Admin** — Panel d'administration pour ajouter/supprimer des chaînes
- **Import IPTV** — Import de playlists M3U/M3U8

## Architecture

```
ManKas-TV/
├── app/
│   ├── page.tsx                          # Page principale
│   ├── channels/[id]/page.tsx            # Page détail chaîne
│   ├── admin/page.tsx                    # Panel admin
│   ├── api/
│   │   ├── channels/route.ts             # API chaînes (liste)
│   │   ├── stream/[...slug]/route.ts     # Proxy HLS (contourne CORS)
│   │   └── admin/
│   │       ├── channels/route.ts         # CRUD chaînes
│   │       └── import-iptv/route.ts      # Import M3U
├── components/
│   ├── player/VideoPlayer.tsx            # Player HLS/iframe
│   ├── channels/
│   │   ├── ChannelGrid.tsx               # Grille de chaînes
│   │   ├── ChannelFilters.tsx            # Filtres
│   │   ├── ChannelDetail.tsx             # Détail chaîne
│   │   └── RecentlyWatched.tsx           # Récemment regardées
│   ├── home/
│   │   ├── HomeExperience.tsx            # Composition page principale
│   │   └── FavoritesSection.tsx          # Section favoris
│   └── admin/AdminPanel.tsx              # Panel admin
├── services/channels.ts                  # Service données chaînes
├── store/useTvStore.ts                   # State management (Zustand)
├── hooks/useChannels.ts                  # Hook React chaînes
├── lib/
│   ├── m3u.ts                            # Parseur M3U
│   ├── proxy.ts                          # Helper proxy HLS
│   ├── mockData.ts                       # Données mock
│   ├── supabaseClient.ts                 # Client Supabase
│   └── supabaseAdmin.ts                  # Admin Supabase
├── types/index.ts                        # Types TypeScript
├── IPTV/                                 # Playlists IPTV (Free-TV/IPTV)
│   ├── playlist.m3u8                     # Playlist principale
│   └── playlists/                        # Playlists par pays (91 fichiers)
└── mankas_tv/                            # Projet Flutter (voir ci-dessous)
```

## Installation

```bash
# Cloner le projet
git clone <repo-url>
cd ManKas-TV

# Installer les dépendances
npm install

# Configurer l'environnement
cp .env.example .env.local
# Modifier .env.local avec vos clés Supabase (optionnel)

# Lancer en développement
npm run dev

# Ouvrir http://localhost:3000
```

## Configuration

### Variables d'environnement (`.env.local`)

```env
# Supabase (optionnel — sans clés, utilise les données M3U)
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
```

### Sans Supabase

L'application fonctionne sans Supabase :
- Les chaînes sont chargées depuis `IPTV/playlist.m3u8` via `/api/channels`
- Les chaînes garanties (DW, NASA TV, France 24, etc.) sont toujours disponibles
- Les favoris et l'historique sont en mémoire

### Avec Supabase

1. Créer un projet Supabase
2. Créer les tables : `channels`, `categories`, `favorites`, `watch_history`
3. Configurer les variables d'environnement
4. Importer les chaînes via l'admin : `POST /api/admin/import-iptv`

## API Routes

| Route | Méthode | Description |
|-------|---------|-------------|
| `/api/channels` | GET | Liste des chaînes (M3U + garanties) |
| `/api/stream/{host}/{path}` | GET | Proxy HLS (contourne CORS) |
| `/api/admin/channels` | POST/DELETE | CRUD chaînes |
| `/api/admin/import-iptv` | POST | Import playlist M3U |

## Dépendances principales

| Package | Version | Usage |
|---------|---------|-------|
| next | ^15.5.19 | Framework React |
| react | 19.2.4 | UI |
| hls.js | ^1.6.16 | Lecteur HLS |
| zustand | ^5.0.14 | State management |
| @supabase/supabase-js | ^2.108.1 | Base de données |
| tailwindcss | ^4 | CSS |
| lucide-react | ^1.18.0 | Icônes |

## Scripts

```bash
npm run dev      # Serveur de développement
npm run build    # Build de production
npm run start    # Lancer le build
npm run lint     # Linter ESLint
```

## Architecture technique

### Proxy HLS

Le proxy `/api/stream/{host_base64}/{path}` résout les erreurs CORS et le problème des URLs relatives dans les playlists HLS. Le host d'origine est encodé en base64 dans le chemin, permettant à hls.js de résoudre correctement les URLs relatives des sous-playlists et segments `.ts`.

### Player multi-source

Le `VideoPlayer` détecte automatiquement le type d'URL :
- **YouTube** → iframe YouTube embed
- **Twitch** → iframe Twitch embed
- **Dailymotion** → iframe Dailymotion embed
- **HLS (.m3u8)** → hls.js via proxy

### Chargement des chaînes

1. Les chaînes garanties sont en dur dans `/api/channels`
2. Le fichier `IPTV/playlist.m3u8` est parsé et filtré (URLs `.m3u8` uniquement)
3. Les résultats sont mis en cache côté serveur
4. Si Supabase est configuré, les chaînes de la base sont utilisées à la place

## License

Projet privé — Usage personnel uniquement.
