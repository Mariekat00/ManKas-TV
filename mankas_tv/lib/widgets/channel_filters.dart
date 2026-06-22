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
        final categories = ['Tout', ...provider.categories.toList()..sort()];
        final countries = ['Tout', ...provider.countries.toList()..sort()];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search bar with recent searches
              _SearchField(provider: provider),
              const SizedBox(height: 10),
              // Favorites toggle + Category + Country
              Row(
                children: [
                  GestureDetector(
                    onTap: () => provider.toggleFavoritesOnly(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: provider.showFavoritesOnly
                            ? Colors.redAccent
                            : const Color(0xFF2A2A3E),
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A3E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: provider.category,
                          isDense: true,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF2A2A3E),
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                          items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (v) => provider.setCategory(v ?? 'Tout'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A3E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: provider.country,
                          isDense: true,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF2A2A3E),
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                          items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (v) => provider.setCountry(v ?? 'Tout'),
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
              color: const Color(0xFF1E1E2E),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
              border: Border.all(color: const Color(0xFF2A2A3E)),
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
