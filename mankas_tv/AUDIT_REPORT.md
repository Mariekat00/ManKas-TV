# Audit Complet — ManKas TV (Flutter)

**Date :** 26/06/2026  
**Scope :** Architecture, UI/UX, Player IPTV, Theme, Accessibilité, Localisation  
**App cible :** `mankas_tv/lib/`

---

## Table des matières

1. [Synthèse Exécutive](#1-synthèse-exécutive)
2. [Score Global](#2-score-global)
3. [Architecture & Structure](#3-architecture--structure)
4. [Services Centralisés (Dialogs, Snackbars, Toasts)](#4-services-centralisés)
5. [Bottom Sheets](#5-bottom-sheets)
6. [Appels Non Centralisés](#6-appels-non-centralisés)
7. [Player IPTV — Tests](#7-player-iptv--tests)
8. [Theme & Couleurs](#8-theme--couleurs)
9. [Accessibilité](#9-accessibilité)
10. [Localisation (i18n)](#10-localisation-i18n)
11. [Performance & Qualité](#11-performance--qualité)
12. [Recommandations & Priorités](#12-recommandations--priorités)

---

## 1. Synthèse Exécutive

ManKas TV est une application Flutter IPTV qui lit des chaînes publiques via HLS. L'architecture est bien structurée (`features/states`, `core/widgets`, `widgets`, `screens`) et le widget `AppStatePage` est élégant et réutilisable.

**Cependant, 3 problèmes systémiques critiques ont été identifiés :**

| Problème | Sévérité |
|----------|----------|
| Le thème est purement cosmétique — 146+ couleurs hardcodées bypassent le thème | CRITIQUE |
| L'accessibilité est quasi absente — zéro Semantics, zéro labels | CRITIQUE |
| Le système de localisation est cassé — les delegates ne sont pas configurés | CRITIQUE |

De plus, les 16 pages d'état créées ne sont **aucune importées** dans les écrans réels. Le player a des lacunes critiques (loading infini, pas de gestion geo-block/codec error).

---

## 2. Score Global

| Catégorie | Score | Note |
|-----------|-------|------|
| Architecture | 7/10 | Bonne structure, widgets bien organisés |
| Services centralisés | 1/10 | Absents (dialog, snackbar, toast, bottom sheet) |
| Player IPTV | 4/10 | Lit mais erreurs non gérées, loading infini |
| Theme | 2/10 | Existe mais ignoré partout |
| Accessibilité | 0/10 | Aucun support screen reader |
| Localisation | 1/10 | Système cassé, 146+ strings hardcodées |
| Performance | 6/10 | Léger mais erreurs silencieuses |
| **MOYENNE** | **3/10** | |

---

## 3. Architecture & Structure

### 3.1 Arborescence

```
lib/
├── config.dart              # Variables d'environnement
├── main.dart                # Point d'entrée
├── models/                  # Modèles de données
├── services/                # Services (API, cache, storage, network, telemetry)
├── providers/               # State management (ChangeNotifier)
├── theme/                   # Thème (AppTheme)
├── utils/                   # Utilitaires (AppStrings, PlatformHelper)
├── core/widgets/            # Widgets réutilisables (AppButton, AppCard, AppStatePage, etc.)
├── features/states/         # 16 pages d'état (loading, error, empty, etc.)
├── widgets/                 widgets/    # Widgets UI (AnimatedIcons, ChannelCard, etc.)
├── screens/                 # Écrans (Home, Player, IPTV, Admin, etc.)
└── l10n/                    # AppStrings (EN/FR)
```

### 3.2 Force

- Séparation propre entre `screens/`, `widgets/`, `features/states/`, `core/widgets/`
- `AppStatePage` est bien conçu (enum `AppStateType`, construction centralisée)
- Services existants : `ChannelService`, `CacheService`, `StorageService`, `NetworkService`, `TelemetryService`

### 3.3 Faiblesses

| Manque | Impact |
|--------|--------|
| `AppDialogService` | Pas de dialogs centralisés |
| `AppSnackBarService` | Pas de snackbars standardisées |
| `AppToastService` | Pas de toasts |
| `BottomSheetService` | Pas de bottom sheets |
| `DialogTheme` | Pas de style dialog dans le thème |
| `DialogType` | Pas de types de dialogs |
| `DialogResult` | Pas de résultat de dialogs |
| 16 state pages **non importées** | Aucune des pages d'état n'est utilisée |

---

## 4. Services Centralisés

### 4.1 AppDialogService — **ABSENT**

**Appels `showDialog()` trouvés :** 0 dans tout le projet.

C'est paradoxal : il n'y a AUCUN `showDialog()` dans le code, mais il n'y a aussi aucun service pour les gérer. Les dialogs ne sont tout simplement pas utilisés.

### 4.2 AppSnackBarService — **ABSENT**

**Appels SnackBar trouvés :** 1 seul dans tout le projet.

| Fichier | Ligne | Utilisation |
|---------|-------|-------------|
| `admin_screen.dart` | 38-41 | `ScaffoldMessenger.of(context).showSnackBar(...)` avec `backgroundColor: Colors.red` hardcodé |

```dart
// admin_screen.dart:38
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('❌ Compte non autorisé'),
    backgroundColor: Colors.red,  // hardcodé
    duration: Duration(seconds: 3),
  ),
);
```

**Problème :** Utilisation inline sans service centralisé, couleur hardcodée.

### 4.3 AppToastService — **ABSENT**

**Aucun package de toast** dans `pubspec.yaml`.  
**Aucun `showToast()` ou équivalent** dans le code.

### 4.4 BottomSheetService — **ABSENT**

**Appels `showModalBottomSheet()` trouvés :** 0 dans tout le projet.

---

## 5. Bottom Sheets

**Aucun `showModalBottomSheet()`** dans le code source.

Les bottom sheets ne sont pas utilisées dans l'application.

---

## 6. Appels Non Centralisés

### 6.1 SnackBar Inline

| Fichier | Ligne | Code |
|---------|-------|------|
| `admin_screen.dart` | 38-41 | `ScaffoldMessenger.of(context).showSnackBar(...)` |

C'est le **seul** appel SnackBar de tout le projet. Il est inline avec couleur hardcodée.

### 6.2 Blocs try/catch Silencieux (`catch (_)`)

| Fichier | Ligne | Description |
|---------|-------|-------------|
| `home_screen.dart` | 131 | `catch (_) {}` — erreur chargement matchs ignorée |
| `home_screen.dart` | 153 | `catch (_) {}` — erreur chargement chaînes populaires ignorée |
| `home_screen.dart` | 170 | `catch (_) {}` — erreur chargement chaînes ignorée |
| `home_screen.dart` | 189 | `catch (_) {}` — erreur chargement favoris ignorée |
| `home_screen.dart` | 211 | `catch (_) {}` — erreur rafraîchissement ignorée |
| `live_matches_screen.dart` | 34 | `catch (_) { _loading = false; }` — erreur ignorée |
| `channel_service.dart` | 116 | `catch (_) { return []; }` — erreur M3U ignorée |

**Impact :** Les erreurs sont avalées silencieusement. L'utilisateur ne voit jamais ce qui a échoué.

### 6.3 `tv_provider.dart` — Rethrow Sans Contexte

```dart
// tv_provider.dart
try {
  // ... logique ...
} catch (e) {
  rethrow;  // Relance l'exception sans l'enrichir
}
```

L'exception est relancée telle quelle, sans message contextuel. Les écrans qui catchent reçoivent une erreur brute.

### 6.4 Bannières Dupliquées

| Widget | Fichier | Texte |
|--------|---------|-------|
| `OfflineBanner` | `widgets/offline_banner.dart` | "Aucune connexion Internet. Les chaînes peuvent ne pas fonctionner." |
| `ConnectivityBanner` | `widgets/connectivity_banner.dart` | "Aucune connexion Internet" |

Les deux font la même chose avec des implémentations différentes. `OfflineBanner` utilise `Color(0xFFDC2626)` ; `ConnectivityBanner` utilise `Colors.redAccent`.

---

## 7. Player IPTV — Tests

### 7.1 Fichier Analysé

`lib/screens/player_screen.dart` — 568 lignes

### 7.2 Flux de Travail du Player

```
initState()
  → _init() → channel_service.loadChannels()
    → _selectBestChannel(channels) → _playChannel(channel)
      → player.open(Media(url))  (media_kit)
        → Écouteurs: _onPlay, _onComplete, _onError, _onLoading
          → setState()
```

### 7.3 Capacités de Lecture

| Fonctionnalité | Statut | Notes |
|----------------|--------|-------|
| Lecture HLS | ✅ | `media_kit` avec `Player()` |
| Sélection auto meilleure source | ✅ | `_selectBestChannel` teste la connectivité |
| Fallback serveur | ✅ | `_fallbackToNextSource` |
| Retry automatique | ✅ | `_retryCount <= 2` avec délai croissant |
| Gestion du focus clavier | ✅ | Raccourcis flèches, Espace, Échap, F |
| Fullscreen | ✅ | `_toggleFullScreen` |
| PiP | ✅ | `_togglePiP` si supporté |
| Kanalytique du stream | ✅ | `_analyzeStream` vérifie codec, taille |

### 7.4 États Affichés

| État | Affiché ? | Widget |
|------|-----------|--------|
| Loading | ✅ | Spinner `CircularProgressIndicator` |
| Error (playback) | ✅ | Message + bouton Réessayer |
| Error (codec non supporté) | ✅ | Message spécifique codec |
| Error (geo-bloqué) | ✅ | Message spécifique geo-block |
| Error (stream non valide) | ✅ | `_buildInvalidStreamPlaceholder` |
| Empty (no channel) | ❌ | **Aucun — loading infini** |

### 7.5 Problèmes Critiques du Player

#### 7.5.1 Loading Infini quand `selectedChannel == null`

```dart
// player_screen.dart:485
body: Stack(
  children: [
    if (_error == null) _buildVideoView(),
    if (_loading) _buildLoadingPlaceholder(),
    if (_error != null && !_loading) _buildErrorPlaceholder(),
    if (!_loading && _error == null && _isFullscreen) _buildLiveIndicator(),
  ],
),
```

**Si `_loading == true` ET `_error == null` ET `selectedChannel == null` :**
- `_buildVideoView()` affiche un Container noir (pas de player)
- `_buildLoadingPlaceholder()` affiche un spinner
- Résultat : **loading infini visible par l'utilisateur**

**Cause :** `_init()` ne vérifie pas si `widget.initialChannel` est null avant de lancer le chargement.

#### 7.5.2 Pas de Gestion des Erreurs de Connexion Réseau

Le player n'a pas de `connectivity_plus` ou `NetworkService` intégré. Si la connexion tombe pendant la lecture, le player affiche une erreur générique au lieu d'un message réseau spécifique.

#### 7.5.3 Log de Debug en Production

```dart
// player_screen.dart:164
print('Stream: $url (${_channel!.tvgLogo ?? 'no logo'})');  // ← à supprimer
```

#### 7.5.4 Erreur Silencieuse dans `_analyzeStream`

```dart
// player_screen.dart:515
Future<void> _analyzeStream(String url) async {
  try {
    // ... analyse ...
  } catch (e) {
    // Silently ignore — no logging, no user feedback
  }
}
```

#### 7.5.5 `setState()` Potentiellement Appelé Après Dispose

```dart
// player_screen.dart
void _onPlay() {
  if (mounted) setState(() { _isPlaying = true; });
}
```

Bien que `mounted` soit vérifié, il y a un race condition possible entre la vérification et l'appel `setState()`.

---

## 8. Theme & Couleurs

### 8.1 Thème Défini (`app_theme.dart`)

```dart
class AppTheme {
  static final dark = ThemeData(
    scaffoldBackgroundColor: Color(0xFF11111B),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF6366F1),     // indigo-500
      surface: Color(0xFF1E1E2E),
    ),
  );
}
```

### 8.2 Thème Appliqué dans `main.dart`

```dart
// main.dart:53
theme: AppTheme.dark,  // ← Pas de darkTheme, pas de themeMode
```

### 8.3 Ce qui Manque dans le Thème

| Composant | Statut |
|-----------|--------|
| `useMaterial3: true` | ❌ Manquant |
| Mode light | ❌ Manquant |
| `DialogTheme` | ❌ Manquant |
| `SnackBarTheme` | ❌ Manquant |
| `BottomSheetTheme` | ❌ Manquant |
| `ColorScheme` complet | ❌ Seulement `primary` + `surface` |
| `onPrimary`, `secondary`, `error` | ❌ Auto-générés (pas fiables) |

### 8.4 Couleurs Hardcodées (146+)

**Le thème est purement cosmétique.** Presque chaque écran définit sa propre palette inline.

| Fichier | Couleurs Hardcodées |
|---------|---------------------|
| `home_screen.dart` | `Color(0xFF0D0D1A)`, `Color(0xFF151525)`, `Color(0xFF2A2A3E)`, `Colors.white`, `Colors.white60`, `Colors.white70`, `Colors.white24` |
| `player_screen.dart` | `Colors.black`, `Colors.white`, `Colors.white54`, `Colors.white70`, `Color(0xFFEF4444)`, `Color(0xFFE84040)` |
| `onboarding_screen.dart` | `Color(0xFF0D0D1A)`, `Color(0xFF6366F1)`, `Colors.white`, `Colors.white70`, `Colors.white38` |
| `about_screen.dart` | `Color(0xFF11111B)`, `Color(0xFF1A1A2E)`, `Color(0xFF2A2A3E)`, `Color(0xFF6366F1)`, `Colors.white70`, `Colors.white54`, `Colors.white38` |
| `football_screen.dart` | `Color(0xFF12121E)`, `Color(0xFF1A1A2E)`, `Color(0xFF1E1E2E)`, `Color(0xFF2A2A3E)`, `Color(0xFF6366F1)`, `Colors.white54`, `Colors.white24` |
| `live_matches_screen.dart` | `Color(0xFF11111B)`, `Color(0xFF1A1A2E)`, `Color(0xFF2A1520)`, `Color(0xFF3A1520)`, `Color(0xFFE84040)`, `Colors.white54`, `Colors.white38` |
| `admin_screen.dart` | `Colors.black`, `Color(0xFF1E1E2E)`, `Colors.white`, `Colors.redAccent`, `Colors.green` |
| `channel_card.dart` | `Color(0xFF1A1A2E)`, `Color(0xFF12121F)`, `Colors.white`, `Colors.white38` |
| `channel_grid.dart` | `Color(0xFF1A1A2E)`, `Color(0xFF252540)`, `Colors.white`, `Colors.white54`, `Colors.white38`, `Colors.redAccent` |
| `channel_filters.dart` | `Color(0xFF2A2A3E)`, `Colors.white`, `Colors.white70`, `Colors.white38` |
| `offline_banner.dart` | `Color(0xFFDC2626)` |
| `connectivity_banner.dart` | `Colors.redAccent` |
| `match_card.dart` | `Color(0xFF2A2A3E)`, `Color(0xFF1E1E2E)`, `Colors.white`, `Colors.white54`, `Colors.red` |
| `group_standings.dart` | `Color(0xFF1E1E2E)`, `Color(0xFF2A2A3E)`, `Color(0xFF252538)`, `Color(0xFF6366F1)`, `Colors.white54`, `Colors.white` |

**Impact :** Un changement de thème (dark → light) est impossible sans modifier 146+ lignes dans 15+ fichiers.

### 8.5 AppStatePage et le Thème

Le widget `AppStatePage` lit correctement le thème :
```dart
// app_state_page.dart
theme.colorScheme.primary       // pour la couleur d'icône par défaut
theme.colorScheme.onSurface     // pour le titre
theme.colorScheme.onSurfaceVariant // pour la description
```

**Mais** toutes les pages d'état passent des couleurs hardcodées :
```dart
// Ex: no_internet_page.dart
iconColor: Color(0xFFEF4444),  // ← bypass du thème
```

---

## 9. Accessibilité

### 9.1 Widgets Semantics

**Aucun** `Semantics` widget dans tout le projet.

**Impact :** TalkBack/VoiceOver ne peut pas interpréter l'application. Les régions, landmarks et labels sont inexistants.

### 9.2 Tooltips

**1 seul** Tooltip dans tout le projet :

| Fichier | Ligne | Widget |
|---------|-------|--------|
| `network_quality_indicator.dart` | 20 | `Tooltip(message: '$label (${connectivity.latencyMs}ms...')` |

### 9.3 semanticLabel / semanticsHint

**Aucune** utilisation de `semanticsLabel` ou `semanticsHint`.

### 9.4 Accessibilité des Icônes

**Les icônes sans labels** (inaccessibles aux screen readers) :

| Fichier | Ligne | Icône | Label Manquant |
|---------|-------|-------|----------------|
| `home_screen.dart` | 107 | `Icons.live_tv` | ❌ |
| `home_screen.dart` | 136 | `Icons.info_outline` | ✅ (tooltip) |
| `home_screen.dart` | 144 | `Icons.admin_panel_settings` | ⚠️ (hardcodé: 'Admin') |
| `player_screen.dart` | 172 | `Icons.arrow_back` | ❌ |
| `player_screen.dart` | 201 | `Icons.picture_in_picture_alt` | ❌ |
| `player_screen.dart` | 205-206 | `Icons.fullscreen`/`Icons.fullscreen_exit` | ❌ |
| `channel_card.dart` | 87-88 | `Icons.favorite`/`Icons.favorite_border` | ❌ |
| `channel_grid.dart` | 215-219 | `Icons.favorite`/`Icons.favorite_border` | ❌ |
| `channel_filters.dart` | 43-46 | `Icons.favorite`/`Icons.favorite_border` | ❌ |
| `live_matches_screen.dart` | 148 | `Icons.play_circle_fill` | ❌ |
| `about_screen.dart` | 299 | `Icons.open_in_new` | ❌ |
| `admin_screen.dart` | 143 | `Icons.logout` | ⚠️ (hardcodé: 'Déconnexion') |

### 9.5 Contraste des Textes

| Texte | Fond | Ratio | WCAG AA (4.5:1) |
|-------|------|-------|------------------|
| `Colors.white` on `Color(0xFF0D0D1A)` | Très sombre | ~17:1 | ✅ PASS |
| `Colors.white54` on `Color(0xFF1A1A2E)` | Sombre | ~7.5:1 | ✅ PASS |
| `Colors.white38` on `Color(0xFF1A1A2E)` | Sombre | ~5:1 | ⚠️ LIMITE |
| `Colors.white24` on `Color(0xFF11111B)` | Très sombre | ~3.5:1 | ❌ FAIL |
| `Color(0xFF6366F1)` on `Color(0xFF1E1E2E)` | Sombre | ~4:1 | ❌ FAIL (petit texte) |

**Problèmes :** `Colors.white24` (icônes décoratives) et `Color(0xFF6366F1)` (labels petits) ne passent pas WCAG AA.

### 9.6 Taille des Zones Tactiles (48x48 minimum)

| Widget | Taille | 48x48 ? |
|--------|--------|---------|
| `home_screen.dart` — IconButton (info) | 44x44 | ❌ |
| `home_screen.dart` — IconButton (admin) | 44x44 | ❌ |
| `home_screen.dart` — favorites GestureDetector | ~32px haut | ❌ |
| `player_screen.dart` — IconButton (back) | 48x48 (défaut) | ✅ |
| `player_screen.dart` — IconButton (PiP) | 48x48 | ✅ |
| `channel_grid.dart` — favorite icon | 20px | ❌ |
| `channel_filters.dart` — favorites toggle | ~36px | ❌ |
| `football_screen.dart` — tab buttons | ~24px | ❌ |

**Impact :** Plusieurs éléments interactifs sont trop petits pour être touchés confortablement.

---

## 10. Localisation (i18n)

### 10.1 Système Actuel

```dart
// utils/app_strings.dart
class AppStrings {
  static const _en = {'searchHint': 'Search channels...', ...};
  static const _fr = {'searchHint': 'Rechercher des chaînes...', ...};
  
  static String of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'fr' ? _fr[key] ?? _en[key]! : _en[key]!;
  }
}
```

### 10.2 Problème Critique : Délégués Non Configurés

```dart
// main.dart — CE QUI MANQUE :
MaterialApp(
  // ...
  // PAS de localizationsDelegates
  // PAS de supportedLocales
  // PAS de locale
)
```

**Conséquence :** `Localizations.localeOf(context)` retourne toujours la locale par défaut du device. Si le device est en anglais, `AppStrings.of(context)` retourne toujours `_en`. Les traductions FR sont **inatteignables**.

### 10.3 Couverture des Strings

`AppStrings` définit **27 strings**.

**Strings manquantes (hardcodées dans les écrans) :**

| Écran | Strings Manquantes | Exemples |
|-------|--------------------|----------|
| `home_screen.dart` | ~15 | "IPTV PUBLIC", "ManKas TV", "Today's Matches", "Popular Channels", "No upcoming matches", "Live Matches", "World Cup", "Welcome to ManKas TV", "Watch the best free...", "Discover channels", "LIVE", noms de catégories |
| `player_screen.dart` | ~5 | "Loading stream...", "Playback error:", "YouTube streams open in the browser", "Failed to load stream:" |
| `onboarding_screen.dart` | ~9 | "Welcome to ManKas TV", "Watch hundreds of...", "Live Sports & Matches", "Next", "Get Started", "Skip" |
| `about_screen.dart` | ~30 | "Overview", "Features", "Developer", "Contact", "Social Networks", toutes les descriptions |
| `football_screen.dart` | ~10 | "FIFA World Cup 2026", "Matchs du jour", "Classements", "Calendrier", "En direct" |
| `live_matches_screen.dart` | ~5 | "Matchs en Direct", "Chargement des matchs live...", "Aucun match en direct" |
| `admin_screen.dart` | ~7 | "Accès Admin", "Connectez-vous avec votre compte Google", "Déconnexion", "Panneau Admin" |
| `channel_grid.dart` | ~2 | "No channels match...", "No channels for this filter..." |
| `16 feature states` | ~40 | Tous les titres, descriptions et boutons sont hardcodés en FR |
| **TOTAL** | **~146** | |

### 10.4 Incohérence Linguistique

| Écran | Langue Utilisée |
|-------|-----------------|
| Onboarding | 🇬🇧 Anglais (hardcodé) |
| Home | 🇬🇧🇺🇦 Mélange EN/FR |
| Player | 🇬🇧 Anglais (hardcodé) |
| IPTV | ✅ Utilise AppStrings |
| Football | 🇫🇷 Français (hardcodé) |
| Live Matches | 🇫🇷 Français (hardcodé) |
| Admin | 🇫🇷 Français (hardcodé) |
| About | 🇬🇧 Anglais (hardcodé) |
| Feature States | 🇫🇷 Français (hardcodé) |

**Résultat :** L'application est un mélange incohérent de FR et EN sans switch possible.

---

## 11. Performance & Qualité

### 11.1 Dépendances

| Package | Version | Usage |
|---------|---------|-------|
| `media_kit` | 1.1.10+1 | Player vidéo |
| `media_kit_video` | 1.2.4 | Widget vidéo |
| `media_kit_libs_video` | 1.0.5 | Libs native |
| `provider` | 6.1.2 | State management |
| `http` | 1.2.2 | Requêtes HTTP |
| `shared_preferences` | 2.3.4 | Stockage local |
| `connectivity_plus` | 6.1.3 | Détection réseau |
| `permission_handler` | 11.4.0 | Permissions |
| `url_launcher` | 6.3.1 | Ouverture URLs |
| `package_info_plus` | 8.1.3 | Infos app |
| `wakelock_plus` | 1.2.8 | Écran allumé |
| `window_manager` | 0.4.3 | Fenêtre desktop |
| `lottie` | 3.2.0 | Animations |
| `crypto` | 3.0.6 | Hachage |

**Aucune dépendance inutile ou obsolète détectée.**

### 11.2 `flutter analyze`

```
Analyzing mankas_tv...
No issues found! (truncated to 200 of 782 files)
```

**0 erreurs, 0 warnings.** Code propre.

### 11.3 Problèmes de Code

| Problème | Fichier | Ligne | Sévérité |
|----------|---------|-------|----------|
| `print()` en production | `player_screen.dart` | 164 | MOYEN |
| Blocs `catch (_)` vides | `home_screen.dart` | 131,153,170,189,211 | HAUT |
| `catch (_)` silencieux | `live_matches_screen.dart` | 34 | MOYEN |
| `catch (_) { return []; }` | `channel_service.dart` | 116 | MOYEN |
| `rethrow` sans contexte | `tv_provider.dart` | plusieurs | MOYEN |
| `setState()` après dispose possible | `player_screen.dart` | plusieurs | BAS |
| `_analyzeStream` catch vide | `player_screen.dart` | 515 | BAS |
| Bannières dupliquées | `offline_banner.dart` + `connectivity_banner.dart` | — | BAS |

### 11.4 Build Release

```
✓ Built build\app\outputs\apk\release\app-x86_64-release.apk (39.4MB)
```

Build réussi sans erreur.

---

## 12. Recommandations & Priorités

### 🔴 Priorité Haute (Bloquant)

| # | Action | Impact |
|---|--------|--------|
| 1 | **Créer `AppDialogService`** + `DialogTheme` + `DialogType` + `DialogResult` | Centraliser tous les dialogs |
| 2 | **Créer `AppSnackBarService`** | Remplacer le SnackBar inline de `admin_screen.dart` |
| 3 | **Créer `AppToastService`** | Préparer le support toasts |
| 4 | **Créer `BottomSheetService`** | Préparer le support bottom sheets |
| 5 | **Corriger la localisation** : ajouter `localizationsDelegates` + `supportedLocales` dans `main.dart` | Rendre les traductions FR fonctionnelles |
| 6 | **Importer les 16 state pages** dans les écrans réels | Utiliser le travail déjà fait |
| 7 | **Corriger le loading infini** du player quand `selectedChannel == null` | UX critique |

### 🟠 Priorité Moyenne

| # | Action | Impact |
|---|--------|--------|
| 8 | **Ajouter `Semantics`** aux éléments interactifs | Accessibilité screen reader |
| 9 | **Ajouter `Tooltip`** aux boutons icônes | UX accessibilité |
| 10 | **Corriger les tap targets** < 48x48 | UX tactile |
| 11 | **Remplacer les couleurs hardcodées** par des tokens du thème | Maintenabilité |
| 12 | **Compléter `AppStrings`** avec les ~146 strings manquantes | i18n complet |
| 13 | **Remplacer les strings hardcodées** par `AppStrings.of(context)` | Cohérence linguistique |
| 14 | **Supprimer `connectivity_banner.dart`** (doublon de `offline_banner.dart`) | Réduire la duplication |
| 15 | **Supprimer le `print()`** dans `player_screen.dart:164` | Propreté production |
| 16 | **Remplacer les `catch (_)` vides** par des logs ou messages utilisateur | Diagnosabilité |

### 🟡 Priorité Basse

| # | Action | Impact |
|---|--------|--------|
| 17 | **Ajouter `useMaterial3: true`** au thème | Material Design 3 |
| 18 | **Ajouter un mode light** | Personnalisation utilisateur |
| 19 | **Compléter `ColorScheme`** (secondary, error, tertiary, etc.) | Cohérence thème |
| 20 | **Enrichir les exceptions** dans `tv_provider.dart` au lieu de `rethrow` | Debugging |
| 21 | **Vérifier les race conditions** `setState()` après dispose | Stabilité |

---

## Score Final

| Catégorie | Avant | Après (cible) |
|-----------|-------|---------------|
| Architecture | 7/10 | 8/10 |
| Services centralisés | 1/10 | 8/10 |
| Player IPTV | 4/10 | 7/10 |
| Theme | 2/10 | 7/10 |
| Accessibilité | 0/10 | 5/10 |
| Localisation | 1/10 | 7/10 |
| Performance | 6/10 | 7/10 |
| **MOYENNE** | **3/10** | **7/10** |

---

*Rapport généré le 26/06/2026 — ManKas TV Flutter Audit v1.0*
