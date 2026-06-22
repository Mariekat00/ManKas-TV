import 'package:flutter/material.dart';

class AppStrings {
  AppStrings._();

  static AppStrings of(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return locale == 'en' ? _en : _fr;
  }

  static final _en = AppStrings._();
  static final _fr = AppStrings._()
    ..searchHint = 'Rechercher une chaîne...'
    ..favorites = 'Favoris'
    ..categories = 'Catégories'
    ..countries = 'Pays'
    ..all = 'Tout'
    ..general = 'Général'
    ..noChannels = 'Aucune chaîne disponible.'
    ..noResults = 'Aucune chaîne ne correspond à votre recherche.'
    ..noFavorites = 'Ajoutez des chaînes en favoris pour les retrouver ici.'
    ..resetFilters = 'Réinitialiser les filtres'
    ..loading = 'Chargement...'
    ..retry = 'Réessayer'
    ..nextChannel = 'Chaîne suivante'
    ..noConnection = 'Aucune connexion Internet. Les chaînes peuvent ne pas fonctionner.'
    ..networkGood = 'Réseau bon'
    ..networkFair = 'Réseau moyen'
    ..networkPoor = 'Réseau faible'
    ..offline = 'Hors-ligne'
    ..settings = 'Paramètres'
    ..about = 'À propos'
    ..liveTV = 'Chaînes IPTV'
    ..sports = 'Sports'
    ..football = 'Football'
    ..searchRecent = 'Recherches récentes'
    ..clearHistory = 'Effacer';

  String searchHint = 'Search channels...';
  String favorites = 'Favorites';
  String categories = 'Categories';
  String countries = 'Countries';
  String all = 'All';
  String general = 'General';
  String noChannels = 'No channels available.';
  String noResults = 'No channels match your search.';
  String noFavorites = 'Add channels to favorites to find them here.';
  String resetFilters = 'Reset filters';
  String loading = 'Loading...';
  String retry = 'Retry';
  String nextChannel = 'Next channel';
  String noConnection = 'No internet connection. Channels may not work.';
  String networkGood = 'Network good';
  String networkFair = 'Network fair';
  String networkPoor = 'Network poor';
  String offline = 'Offline';
  String settings = 'Settings';
  String about = 'About';
  String liveTV = 'Live TV';
  String sports = 'Sports';
  String football = 'Football';
  String searchRecent = 'Recent searches';
  String clearHistory = 'Clear';
}
