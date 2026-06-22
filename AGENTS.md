<!-- BEGIN:nextjs-agent-rules -->
# This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` before writing any code. Heed deprecation notices.
<!-- END:nextjs-agent-rules -->

# ManKas TV — Guide du projet

## Deux applications

Ce dépôt contient **deux applications** pour le même projet IPTV :

| App | Technologie | Dossier | Lancement |
|-----|-------------|---------|-----------|
| **Web** | Next.js 15 + React 19 + Tailwind 4 | racine `/` | `npm run dev` |
| **Desktop/Mobile** | Flutter + Dart + media_kit | `mankas_tv/` | `flutter run` |

## Commandes utiles

```bash
# === Next.js (Web) ===
npm run dev          # Serveur dev (port 3000)
npm run build        # Build production
npm run lint         # ESLint

# === Flutter ===
cd mankas_tv
flutter pub get      # Installer les dépendances
flutter run          # Lancer l'app (nécessite Developer Mode)
flutter analyze      # Analyser le code
flutter test         # Lancer les tests unitaires
flutter build windows  # Build Windows

# Build Android (contourne l'absence de symlinks)
$env:JAVA_HOME = 'C:\Program Files\Android\Android Studio\jbr'
cd android
.\gradlew.bat assembleDebug    # APK debug
.\gradlew.bat assembleRelease  # APK release signé
.\gradlew.bat bundleRelease    # AAB pour Play Store
```

## Structure Next.js

- `app/api/channels/route.ts` — Liste des chaînes (M3U + garanties)
- `app/api/stream/[...slug]/route.ts` — Proxy HLS (contourne CORS)
- `components/player/VideoPlayer.tsx` — Player HLS/iframe
- `services/channels.ts` — Service données
- `store/useTvStore.ts` — State (Zustand)
- `lib/m3u.ts` — Parseur M3U
- `lib/proxy.ts` — Helper proxy
- `IPTV/playlist.m3u8` — Playlist IPTV

## Structure Flutter

- `lib/main.dart` — Point d'entrée
- `lib/models/channel.dart` — Modèle Channel
- `lib/services/channel_service.dart` — Service chaînes
- `lib/services/m3u_parser.dart` — Parseur M3U
- `lib/providers/tv_provider.dart` — State management
- `lib/screens/home_screen.dart` — Page principale
- `lib/screens/player_screen.dart` — Player HLS
- `lib/widgets/` — Composants UI

## Chaînes (garanties, testées et fonctionnelles)

| Chaîne | Pays | Langue | Source |
|--------|------|--------|--------|
| Real Madrid TV | Spain | Spanish | akamized.net HLS |
| Gol Classics | Spain | Spanish | cloudfront.net HLS |
| Equidia | France | French | GitHub HLS |
| Trace Sport Stars | France | French | Amagi CDN HLS |
| FTF Sports | France | French | CDN77 HLS |
| Telemundo NY | USA | Spanish | akamized.net HLS |
| Alkass One | Qatar | Arabic | GCP HLS |
| Alkass Two | Qatar | Arabic | GCP HLS |
| Arryadia | Morocco | Arabic | LiveMedia.ma HLS |
| Arryadia HD1 | Morocco | Arabic | LiveMedia.ma HLS |
| beIN Sports XTRA | Qatar | Arabic | Amagi CDN HLS |
| beIN Sports XTRA Español | USA | Spanish | CloudFront HLS |
| CazéTV | Brazil | Portuguese | YouTube iframe |

## Notes techniques

### Proxy HLS (Next.js)
Le proxy `/api/stream/{host_base64}/{path}` encode le host en base64 dans le chemin. Cela permet à hls.js de résoudre correctement les URLs relatives des sous-playlists et segments.

### Player Flutter
Utilise `media_kit` (basé sur mpv/libmpv) pour la lecture HLS native. Les sources YouTube/Twitch sont affichées comme URLs à ouvrir dans un navigateur.

### Build Release Android
Le build nécessite `key.properties` dans `android/` et un keystore (`android/app/upload-keystore.jks`).
Générer le keystore : `keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`

`flutter build apk` échoue sur Windows sans Developer Mode (symlinks). Solution : utiliser Gradle directement via `gradlew.bat assembleRelease`.

### Credentials
Les credentials Supabase sont compilés dans le binaire via `--dart-define` en release. En debug, les fallbacks dans `lib/config.dart` sont utilisés.

### Signature Release
Le keystore et `key.properties` sont exclus du git via `.gitignore`.
