# ManKas TV — Flutter

Application IPTV multiplateforme construite avec **Flutter** et **Dart**. Lecteur de chaînes TV publiques en direct via HLS, YouTube, Twitch.

## Fonctionnalités

- **Player HLS** — Lecture de flux `.m3u8` via `media_kit` (basé sur mpv/libmpv)
- **Grille responsive** — 3 à 6 colonnes selon la taille d'écran
- **Recherche** — Par nom, pays ou langue
- **Filtres** — Par catégorie et par pays
- **Favoris** — Sauvegardés localement via SharedPreferences
- **Cache** — Les chaînes sont mises en cache pour un chargement rapide
- **Thème dark** — Interface sombre

## Architecture

```
mankas_tv/lib/
├── main.dart                     # Point d'entrée + initialisation MediaKit
├── models/
│   └── channel.dart              # Modèle Channel + sérialisation JSON
├── services/
│   ├── m3u_parser.dart           # Parseur de playlists M3U/M3U8
│   └── channel_service.dart      # Service chaînes, favoris, cache
├── providers/
│   └── tv_provider.dart          # State management avec Provider
├── screens/
│   ├── home_screen.dart          # Page principale (grille + métriques)
│   └── player_screen.dart        # Écran player HLS
├── widgets/
│   ├── channel_card.dart         # Carte de chaîne
│   ├── channel_grid.dart         # Grille responsive de chaînes
│   └── channel_filters.dart      # Barre de recherche + filtres
└── theme/
    └── app_theme.dart            # Thème dark de l'application
```

## Installation

### Prérequis

- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.10
- [Dart SDK](https://dart.dev/get-dart) (inclut avec Flutter)
- Windows / macOS / Linux

### Setup

```bash
# Aller dans le dossier Flutter
cd mankas_tv

# Installer les dépendances
flutter pub get

# Lancer en développement
flutter run

# Ou build de production
flutter build windows   # Windows
flutter build macos     # macOS
flutter build linux     # Linux
```

## Chaînes par défaut

| Chaîne | Source | Type |
|--------|--------|------|
| La 1 (RTVE) | rtvelivestream.rtve.es | HLS |
| Real Madrid TV | rmtv.akamaized.net | HLS |
| DW News | dwamdstream102.akamaized.net | HLS |
| NASA TV | ntv1.akamaized.net | HLS |
| Telequivir | twitch.tv | Twitch (iframe) |
| France 24 Français | youtube.com | YouTube (iframe) |

## Dépendances

| Package | Version | Usage |
|---------|---------|-------|
| media_kit | ^1.1.11 | Lecteur vidéo basé sur mpv |
| media_kit_video | ^1.2.5 | Widget vidéo Flutter |
| media_kit_libs_windows_video | ^1.0.9 | Binaires mpv Windows |
| media_kit_libs_macos_video | ^1.0.5 | Binaires mpv macOS |
| media_kit_libs_linux | ^1.1.3 | Binaires mpv Linux |
| cached_network_image | ^3.4.1 | Cache d'images réseau |
| http | ^1.2.2 | Requêtes HTTP |
| shared_preferences | ^2.3.4 | Stockage local |
| provider | ^6.1.2 | State management |

## Modèle de données

```dart
class Channel {
  final String id;
  final String name;
  final String? logo;
  final String streamUrl;
  final String? category;
  final String? country;
  final String? language;
}
```

## Service M3U Parser

Le parseur M3U lit les playlists au format :

```
#EXTINF:-1 tvg-name="..." tvg-logo="..." tvg-country="..." group-title="...",Nom de la chaîne
https://url-du-flux.m3u8
```

Les attributs extraits : `tvg-name`, `tvg-logo`, `tvg-id`, `tvg-country`, `group-title`, `tvg-language`.

## Service Channel Service

- `getChannels()` — Charge les chaînes garanties + tente de charger depuis iptv-org
- `getFavorites()` — Récupère les favoris depuis SharedPreferences
- `toggleFavorite(id)` — Ajoute/enlève un favori
- Cache local des chaînes pour le chargement hors ligne

## Player HLS

Utilise `media_kit` qui est basé sur `mpv`/`libmpv` :
- Supporte nativement les flux HLS (.m3u8)
- Supporte les flux DASH
- Contrôles vidéo intégrés (play/pause, volume, plein écran, Seek)
- Gestion automatique des variantes de qualité

Pour les sources YouTube et Twitch, l'application affiche l'URL à ouvrir dans un navigateur.

## Build

```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

Les builds sont générés dans `build/`.

## License

Projet privé — Usage personnel uniquement.
