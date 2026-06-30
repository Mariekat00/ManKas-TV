import 'package:flutter/material.dart';

class AppStrings {
  AppStrings._();

  static AppStrings of(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'en' ? _en : _fr;
  }

  static final _en = AppStrings._();
  static final _fr = AppStrings._()
    ..appName = 'ManKas TV'
    // ── Search & Filters ──
    ..searchHint = 'Rechercher une chaîne...'
    // ── Onboarding ──
    ..onboardingTitle1 = 'Bienvenue sur ManKas TV'
    ..onboardingDesc1 = 'Regardez des centaines de chaînes IPTV publiques gratuites du monde entier.'
    ..onboardingTitle2 = 'Sports & Matchs en Direct'
    ..onboardingDesc2 = 'Suivez la Coupe du Monde 2026, les scores en direct, les classements et les temps forts.'
    ..onboardingTitle3 = 'Favoris & Recherche'
    ..onboardingDesc3 = 'Sauvegardez vos chaînes favorites, recherchez par nom ou pays, et reprenez où vous en étiez.'
    ..next = 'Suivant'
    ..getStarted = 'Commencer'
    ..skip = 'Passer'
    // ── Casting ──
    ..cast = 'Cast'
    ..castDevices = 'Devices Cast'
    ..castSearching = 'Recherche de dispositifs...'
    ..castConnected = 'Connecté au Chromecast'
    ..castDisconnected = 'Déconnecté du Chromecast'
    ..castingTo = 'Diffusion vers %s'
    ..noDevicesFound = 'Aucun dispositif trouvé'
    ..cancel = 'Annuler'
    // ── Offline ──
    ..noInternet = 'Aucune connexion Internet. Les chaînes peuvent ne pas fonctionner.'
    // ── Group ──
    ..group = 'Groupe'
    ..team = 'Équipe'
    ..played = 'MJ'
    ..drawn = 'N'
    ..lost = 'P'
    ..goalsFor = 'BP'
    ..goalsAgainst = 'BC'
    ..points = 'Pts'
    ..favorites = 'Favoris'
    ..categories = 'Catégories'
    ..countries = 'Pays'
    ..all = 'Tout'
    ..general = 'Général'
    ..noChannels = 'Aucune chaîne disponible.'
    ..noResults = 'Aucune chaîne ne correspond à votre recherche.'
    ..noFavorites = 'Ajoutez des chaînes en favoris pour les retrouver ici.'
    ..noChannelsForFilter = 'Aucune chaîne pour ce filtre. Essayez une autre catégorie ou région.'
    ..resetFilters = 'Réinitialiser les filtres'
    ..removeFromFavorites = 'Retirer des favoris'
    ..addToFavorites = 'Ajouter aux favoris'
    // ── Player ──
    ..loading = 'Chargement...'
    ..retry = 'Réessayer'
    ..nextChannel = 'Chaîne suivante'
    ..loadingStream = 'Chargement du flux...'
    ..streamError = 'Impossible de lire cette chaîne'
    ..streamErrorDesc = 'Cette chaîne est temporairement indisponible.'
    ..noChannelSelected = 'Aucune chaîne sélectionnée.'
    ..playbackError = 'Erreur de lecture :'
    ..youtubeStreamMsg = 'Les flux YouTube s\'ouvrent dans le navigateur.'
    ..twitchStreamMsg = 'Les flux Twitch s\'ouvrent dans le navigateur.'
    ..connectionFailed = 'Connexion échouée :'
    ..adminAccessRestricted = 'Seul %s peut accéder.'
    ..connectedAs = 'Connecté en tant que %s'
    // ── Auth ──
    ..email = 'Email'
    ..password = 'Mot de passe'
    ..login = 'Se connecter'
    ..loginWithEmail = 'Se connecter avec email'
    ..noAccount = 'Pas encore de compte ?'
    ..createAccount = 'Créer un compte'
    ..or = 'ou'
    // ── Admin ──
    ..channels = 'Chaînes'
    ..addChannel = 'Ajouter une chaîne'
    ..manageChannels = 'Gérer les chaînes'
    ..statistics = 'Statistiques'
    // ── Network ──
    ..noConnection = 'Aucune connexion Internet. Les chaînes peuvent ne pas fonctionner.'
    ..networkGood = 'Réseau bon'
    ..networkFair = 'Réseau moyen'
    ..networkPoor = 'Réseau faible'
    ..offline = 'Hors-ligne'
    // ── Navigation ──
    ..settings = 'Paramètres'
    ..about = 'À propos'
    ..liveTV = 'Chaînes IPTV'
    ..sports = 'Sports'
    ..football = 'Football'
    ..liveMatches = 'Matchs en Direct'
    ..worldCup = 'Coupe du Monde'
    // ── Search history ──
    ..searchRecent = 'Recherches récentes'
    ..clearHistory = 'Effacer'
    // ── Home ──
    ..todaysMatches = 'Matchs du Jour'
    ..popularChannels = 'Chaînes Populaires'
    ..discoverChannels = 'Découvrir les chaînes'
    ..welcomeTitle = 'Bienvenue sur ManKas TV'
    ..welcomeDesc = 'Regardez les meilleures chaînes IPTV publiques gratuites du monde entier.'
    // ── Live Matches ──
    ..loadingLiveMatches = 'Chargement des matchs live...'
    ..noLiveMatches = 'Aucun match en direct'
    ..noLiveMatchesDesc = 'Les matchs apparaissent ici quand ils sont live'
    // ── Football ──
    ..todayMatches = 'Matchs du jour'
    ..standings = 'Classements'
    ..schedule = 'Calendrier'
    ..live = 'EN DIRECT'
    ..noMatchesToday = 'Aucun match en cours aujourd\'hui'
    ..upcomingMatches = 'Prochains matchs'
    // ── Auth / Admin ──
    ..loginWithGoogle = 'Se connecter avec Google'
    ..logout = 'Déconnexion'
    ..adminPanel = 'Panneau Admin'
    ..adminMode = 'Mode Admin actif'
    ..loginRequired = 'Connectez-vous avec votre compte Google autorisé.'
    ..accountUnauthorized = 'Compte non autorisé'
    // ── About ──
    ..overview = 'Aperçu'
    ..features = 'Fonctionnalités'
    ..developer = 'Développeur'
    ..contact = 'Contact'
    ..socialNetworks = 'Réseaux Sociaux'
    ..version = 'Version'
    // ── Privacy ──
    ..privacyPolicy = 'Politique de confidentialité'
    ..privacyLastUpdated = 'Dernière mise à jour : 29 juin 2026'
    ..privacyIntro = 'ManKas TV respecte votre vie privée. Cette politique explique quelles données nous collectons et comment nous les utilisons.'
    ..privacyDataCollected = 'Données collectées'
    ..privacyDataCollectedDesc = 'Nous collectons uniquement les données nécessaires au fonctionnement de l\'application :'
    ..privacyItem1 = 'Adresse email (connexion via Google ou email/mot de passe)'
    ..privacyItem2 = 'Chaînes favoris (stockés localement sur votre appareil)'
    ..privacyItem3 = 'Préférences de l\'application (langue, thème)'
    ..privacyItem4 = 'Rapports d\'erreurs (via Sentry, anonymisés)'
    ..privacyNoData = 'Nous ne collectons AUCUNE donnée personnelle identifiable au-delà de ce qui est listé ci-dessus.'
    ..privacyUsage = 'Utilisation des données'
    ..privacyUsageDesc = 'Vos données sont utilisées uniquement pour :'
    ..privacyUsage1 = 'Fournir et améliorer le service de streaming'
    ..privacyUsage2 = 'Sauvegarder vos favoris et préférences'
    ..privacyUsage3 = 'Détecter et corriger les erreurs techniques'
    ..privacyThirdParties = 'Services tiers'
    ..privacyThirdPartiesDesc = 'Nous utilisons les services suivants qui peuvent collecter certaines données :'
    ..privacyThirdItem1 = 'Supabase (authentification et base de données)'
    ..privacyThirdItem2 = 'Sentry (monitoring des erreurs)'
    ..privacyThirdItem3 = 'Google Sign-In (connexion optionnelle)'
    ..privacySecurity = 'Sécurité'
    ..privacySecurityDesc = 'Nous prenons des mesures raisonnables pour protéger vos données, mais aucun système n\'est 100% sécurisé.'
    ..privacyContact = 'Contact'
    ..privacyContactDesc = 'Pour toute question concernant cette politique, contactez-nous à :'
    // ── Service ──
    ..serviceUnavailable = 'Service temporairement indisponible'
    ..serviceUnavailableDesc = 'Cette fonctionnalité est en cours de mise à jour. Veuillez réessayer plus tard.';

  // ── Search & Filters ──
  String searchHint = 'Search channels...';
  String favorites = 'Favorites';
  String categories = 'Categories';
  String countries = 'Countries';
  String all = 'All';
  String general = 'General';
  String noChannels = 'No channels available.';
  String noResults = 'No channels match your search.';
  String noFavorites = 'Add channels to favorites to find them here.';
  String noChannelsForFilter = 'No channels for this filter. Try another category or region.';
  String resetFilters = 'Reset filters';
  String removeFromFavorites = 'Remove from favorites';
  String addToFavorites = 'Add to favorites';
  // ── Player ──
  String loading = 'Loading...';
  String retry = 'Retry';
  String nextChannel = 'Next channel';
  String loadingStream = 'Loading stream...';
  String streamError = 'Unable to play this channel';
  String streamErrorDesc = 'This channel is temporarily unavailable.';
  String noChannelSelected = 'No channel selected.';
  String playbackError = 'Playback error:';
  String youtubeStreamMsg = 'YouTube streams open in the browser.';
  String twitchStreamMsg = 'Twitch streams open in the browser.';
  String connectionFailed = 'Connection failed:';
  String adminAccessRestricted = 'Only %s can access.';
  String connectedAs = 'Connected as %s';
  // ── Auth ──
  String email = 'Email';
  String password = 'Password';
  String login = 'Log in';
  String loginWithEmail = 'Log in with email';
  String noAccount = 'No account yet?';
  String createAccount = 'Create account';
  String or = 'or';
  // ── Admin ──
  String channels = 'Channels';
  String addChannel = 'Add channel';
  String manageChannels = 'Manage channels';
  String statistics = 'Statistics';
  // ── Network ──
  String noConnection = 'No internet connection. Channels may not work.';
  String networkGood = 'Network good';
  String networkFair = 'Network fair';
  String networkPoor = 'Network poor';
  String offline = 'Offline';
  // ── Navigation ──
  String settings = 'Settings';
  String about = 'About';
  String liveTV = 'Live TV';
  String sports = 'Sports';
  String football = 'Football';
  String liveMatches = 'Live Matches';
  String worldCup = 'World Cup';
  // ── Search history ──
  String searchRecent = 'Recent searches';
  String clearHistory = 'Clear';
  // ── Home ──
  String todaysMatches = "Today's Matches";
  String popularChannels = 'Popular Channels';
  String discoverChannels = 'Discover channels';
  String welcomeTitle = 'Welcome to ManKas TV';
  String welcomeDesc = 'Watch the best free public IPTV channels from around the world.';
  // ── Live Matches ──
  String loadingLiveMatches = 'Loading live matches...';
  String noLiveMatches = 'No live matches';
  String noLiveMatchesDesc = 'Matches appear here when they are live';
  // ── Football ──
  String todayMatches = 'Today\'s Matches';
  String standings = 'Standings';
  String schedule = 'Schedule';
  String live = 'LIVE';
  String noMatchesToday = 'No matches today';
  String upcomingMatches = 'Upcoming matches';
  // ── Auth / Admin ──
  String loginWithGoogle = 'Sign in with Google';
  String logout = 'Logout';
  String adminPanel = 'Admin Panel';
  String adminMode = 'Admin mode active';
  String loginRequired = 'Sign in with your authorized Google account.';
  String accountUnauthorized = 'Unauthorized account';
  // ── About ──
  String overview = 'Overview';
  String features = 'Features';
  String developer = 'Developer';
  String contact = 'Contact';
  String socialNetworks = 'Social Networks';
  String version = 'Version';
  String appName = 'ManKas TV';
  // ── Onboarding ──
  String onboardingTitle1 = 'Welcome to ManKas TV';
  String onboardingDesc1 = 'Watch hundreds of free public IPTV channels from around the world.';
  String onboardingTitle2 = 'Live Sports & Matches';
  String onboardingDesc2 = 'Follow FIFA World Cup 2026, live scores, group standings, and match highlights.';
  String onboardingTitle3 = 'Favorites & Search';
  String onboardingDesc3 = 'Save your favorite channels, search by name or country, and pick up where you left off.';
  String next = 'Next';
  String getStarted = 'Get Started';
  String skip = 'Skip';
  // ── Casting ──
  String cast = 'Cast';
  String castDevices = 'Devices Cast';
  String castSearching = 'Recherche de dispositifs...';
  String castConnected = 'Connecté au Chromecast';
  String castDisconnected = 'Déconnecté du Chromecast';
  String castingTo = 'Diffusion vers %s';
  String noDevicesFound = 'Aucun dispositif trouvé';
  String cancel = 'Annuler';
  // ── Offline ──
  String noInternet = 'Aucune connexion Internet. Les chaînes peuvent ne pas fonctionner.';
  // ── Group ──
  String group = 'Groupe';
  String team = 'Équipe';
  String played = 'MJ';
  String drawn = 'N';
  String lost = 'P';
  String goalsFor = 'BP';
  String goalsAgainst = 'BC';
  String points = 'Pts';
  // ── Privacy ──
  String privacyPolicy = 'Privacy Policy';
  String privacyLastUpdated = 'Last updated: June 29, 2026';
  String privacyIntro = 'ManKas TV respects your privacy. This policy explains what data we collect and how we use it.';
  String privacyDataCollected = 'Data Collected';
  String privacyDataCollectedDesc = 'We only collect data necessary for the app to function:';
  String privacyItem1 = 'Email address (via Google or email/password login)';
  String privacyItem2 = 'Favorite channels (stored locally on your device)';
  String privacyItem3 = 'App preferences (language, theme)';
  String privacyItem4 = 'Error reports (via Sentry, anonymized)';
  String privacyNoData = 'We do NOT collect any personally identifiable information beyond what is listed above.';
  String privacyUsage = 'Data Usage';
  String privacyUsageDesc = 'Your data is used only to:';
  String privacyUsage1 = 'Provide and improve the streaming service';
  String privacyUsage2 = 'Save your favorites and preferences';
  String privacyUsage3 = 'Detect and fix technical errors';
  String privacyThirdParties = 'Third-Party Services';
  String privacyThirdPartiesDesc = 'We use the following services that may collect some data:';
  String privacyThirdItem1 = 'Supabase (authentication and database)';
  String privacyThirdItem2 = 'Sentry (error monitoring)';
  String privacyThirdItem3 = 'Google Sign-In (optional login)';
  String privacySecurity = 'Security';
  String privacySecurityDesc = 'We take reasonable measures to protect your data, but no system is 100% secure.';
  String privacyContact = 'Contact';
  String privacyContactDesc = 'For any questions about this policy, contact us at:';
  // ── Service ──
  String serviceUnavailable = 'Service temporarily unavailable';
  String serviceUnavailableDesc = 'This feature is currently being updated. Please try again later.';
}
