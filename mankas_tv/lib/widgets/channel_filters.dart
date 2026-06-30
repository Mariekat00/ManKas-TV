import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tv_provider.dart';
import '../utils/app_strings.dart';

class ChannelFilters extends StatelessWidget {
  const ChannelFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TvProvider>(
      builder: (context, provider, _) {
        final theme = Theme.of(context);
        final surface = theme.colorScheme.surface;
        final allLabel = AppStrings.of(context).all;
        final categories = [allLabel, ...provider.categories.toList()..sort()];
        final countries = [allLabel, ...provider.countries.toList()..sort()];

        final safeCategory = categories.contains(provider.category) ? provider.category : allLabel;
        final safeCountry = countries.contains(provider.country) ? provider.country : allLabel;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SearchField(provider: provider),
              const SizedBox(height: 10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => provider.toggleFavoritesOnly(),
                    child: Semantics(
                      label: AppStrings.of(context).favorites,
                      button: true,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: provider.showFavoritesOnly
                              ? Colors.redAccent
                              : surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              provider.showFavoritesOnly
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(AppStrings.of(context).favorites, style: const TextStyle(fontSize: 13, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: safeCategory,
                          isDense: true,
                          isExpanded: true,
                          dropdownColor: surface,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                          items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (v) => provider.setCategory(v ?? allLabel),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: safeCountry,
                          isDense: true,
                          isExpanded: true,
                          dropdownColor: surface,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                          items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (v) => provider.setCountry(v ?? allLabel),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchField extends StatefulWidget {
  final TvProvider provider;
  const _SearchField({required this.provider});

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller;
  final _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.provider.query);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _showSuggestions = false);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.provider.query != widget.provider.query) {
      _controller.text = widget.provider.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final recent = widget.provider.recentSearches;
    final filtered = recent.where((s) => s.contains(_controller.text)).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: AppStrings.of(context).searchHint,
            prefixIcon: const Icon(Icons.search, size: 22),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _controller.clear();
                      widget.provider.setQuery('');
                    },
                  )
                : null,
            hintStyle: TextStyle(color: Colors.white.withAlpha(102)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: const TextStyle(fontSize: 15),
          onChanged: (v) {
            widget.provider.setQuery(v);
            setState(() => _showSuggestions = v.isNotEmpty);
          },
          onSubmitted: (v) {
            widget.provider.submitQuery(v);
            _focusNode.unfocus();
          },
        ),
        if (_showSuggestions && filtered.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
              border: Border.all(color: theme.colorScheme.surface.withAlpha(178)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...filtered.take(5).map((s) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.history, size: 16, color: Colors.white38),
                  title: Text(s, style: const TextStyle(fontSize: 13, color: Colors.white70)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 14, color: Colors.white24),
                    onPressed: () {
                      widget.provider.clearRecentSearches();
                      setState(() => _showSuggestions = false);
                    },
                  ),
                  onTap: () {
                    _controller.text = s;
                    widget.provider.submitQuery(s);
                    _focusNode.unfocus();
                    setState(() => _showSuggestions = false);
                  },
                )),
              ],
            ),
          ),
      ],
    );
  }
}
