import 'package:flutter/material.dart';

/// ═══════════════════════════════════════════════════════════
/// AppStateType — enum centralisé de tous les états applicatifs
/// ═══════════════════════════════════════════════════════════
enum AppStateType {
  loading,
  noInternet,
  noChannels,
  serverError,
  timeout,
  streamError,
  geoBlock,
  maintenance,
  emptySearch,
  emptyFavorites,
  historyEmpty,
  downloadsEmpty,
  unexpectedError,
  forceUpdate,
  loginRequired,
}

/// ═══════════════════════════════════════════════════════════
/// AppStateAction — modèle d'un bouton d'action
/// ═══════════════════════════════════════════════════════════
class AppStateAction {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const AppStateAction({
    required this.label,
    this.onPressed,
    this.isPrimary = false,
  });
}

/// ═══════════════════════════════════════════════════════════
/// AppStatePage — widget réutilisable pour toutes les pages
/// d'état (loading, empty, error, etc.)
///
/// Design inspiré Netflix / Google TV / YouTube :
/// - Illustration ou icône animée (Fade + Scale)
/// - Titre + description
/// - Boutons d'action
/// - Responsive mobile / tablette
/// ═══════════════════════════════════════════════════════════
class AppStatePage extends StatefulWidget {
  /// Icône Material affichée en haut de la page
  final IconData? icon;

  /// Widget d'illustration custom (remplace l'icône si fourni)
  final Widget? illustration;

  /// Titre principal
  final String title;

  /// Description sous le titre
  final String description;

  /// Liste des boutons d'action
  final List<AppStateAction> actions;

  /// Couleur de l'icône (défaut : accent du thème)
  final Color? iconColor;

  /// Taille de l'icône (défaut : 80)
  final double iconSize;

  /// Padding horizontal (défaut : 32)
  final double horizontalPadding;

  const AppStatePage({
    super.key,
    this.icon,
    this.illustration,
    required this.title,
    required this.description,
    this.actions = const [],
    this.iconColor,
    this.iconSize = 80,
    this.horizontalPadding = 32,
  }) : assert(
          icon != null || illustration != null,
          'Fournir icon ou illustration',
        );

  @override
  State<AppStatePage> createState() => _AppStatePageState();
}

class _AppStatePageState extends State<AppStatePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width > 600;
    final maxContentWidth = isTablet ? 480.0 : double.infinity;
    final iconColor = widget.iconColor ?? theme.colorScheme.primary;

    return Center(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding,
                vertical: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Illustration ou Icône ──
                  if (widget.illustration != null)
                    widget.illustration!
                  else
                    _buildIconContainer(theme, iconColor),

                  const SizedBox(height: 32),

                  // ── Titre ──
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Description ──
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),

                  // ── Boutons d'action ──
                  if (widget.actions.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    _buildActions(theme, isTablet),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(ThemeData theme, Color color) {
    return Container(
      width: widget.iconSize + 40,
      height: widget.iconSize + 40,
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.icon,
        size: widget.iconSize,
        color: color,
      ),
    );
  }

  Widget _buildActions(ThemeData theme, bool isTablet) {
    if (widget.actions.length == 1) {
      return SizedBox(
        width: isTablet ? 240 : double.infinity,
        child: _buildActionButton(theme, widget.actions.first),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: widget.actions.map((action) {
        if (isTablet) {
          return SizedBox(
            width: 180,
            child: _buildActionButton(theme, action),
          );
        }
        return _buildActionButton(theme, action);
      }).toList(),
    );
  }

  Widget _buildActionButton(ThemeData theme, AppStateAction action) {
    if (action.isPrimary) {
      return FilledButton(
        onPressed: action.onPressed,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(action.label),
      );
    }

    return OutlinedButton(
      onPressed: action.onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(action.label),
    );
  }
}
