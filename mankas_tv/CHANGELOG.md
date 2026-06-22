# Changelog

## [1.0.0] — 2026-06-22

### Added
- **App icon**: custom gradient icon (blue→purple, white TV symbol, white background)
- **Android shortcuts**: long-press app icon → IPTV / Live Matches / Favorites
- **Onboarding**: 3-screen welcome on first launch
- **Picture-in-Picture**: PiP mode for video player (Android 8+)
- **Share channel**: share button in player header and channel grid
- **Network quality indicator**: 4-color dot (green/yellow/orange/red)
- **Offline banner**: red banner when no internet connection
- **Pull-to-refresh**: refresh channel list by swiping down
- **Search history**: last 5 searches persisted via SharedPreferences
- **Landscape fullscreen toggle**: immersive sticky mode in player
- **CI/CD**: GitHub Actions workflow (analyze + test + build APK)
- **Sentry crash reporting**: error tracking with real DSN
- **i18n**: English + French via AppStrings
- **Empty state messages**: contextual messages with reset button
- **Next channel button**: skip to next channel on playback error
- **109 Flutter tests** (provider, services, widgets, models)
- **`public/data/channels.json`**: 51 channels for Next.js

### Changed
- Player buffer: 32 MB → 150 MB for smoother playback
- Network fetch timeout: none → 10s (with AbortController)
- All UI strings: French → English (with French locale fallback)
- `catch {}` blocks: silent → `console.warn` in Next.js services
- `ConnectivityService`: `_disposed` guard, no constructor `_check()` to avoid timer leaks
- `TvProvider`: accepts optional `ChannelService` for testability

### Fixed
- Category null mismatch: `(ch.category ?? 'Général') == _category`
- HomeScreen favorites toggle: visual feedback + navigation to IptvScreen
- App icon: regenerated from source (was corrupted by git encoding)

## [0.9.0] — 2026-06-15

### Added
- Player screen with HLS playback (media_kit)
- Channel grid with infinite scroll (50 items per page)
- Category and country filters with dropdowns
- Favorites system with toggle
- Search by name, country, language
- Football matches: FIFA World Cup 2026 tracking
- Live matches screen via StreamFree
- About screen with developer info
- Admin screen
- Notification service for media playback
- Match notification service for reminders
- Football group standings, match cards, schedule
- Category-theme colors and icons
- Error boundary widget

## [0.1.0] — 2026-05-28

### Added
- Initial Flutter project setup
- Basic channel listing from M3U parser
- Guaranteed channels (29 sources: Real Madrid TV, BBC, Alkass, Arryadia, etc.)
- Supabase integration
- Google Sign-In
- Dark theme
- M3U playlist parser
