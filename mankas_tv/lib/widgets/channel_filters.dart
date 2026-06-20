import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tv_provider.dart';

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
              // Search bar - full width
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher une chaîne...',
                  prefixIcon: const Icon(Icons.search, size: 22),
                  suffixIcon: provider.query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () => provider.setQuery(''),
                        )
                      : null,
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                style: const TextStyle(fontSize: 15),
                onChanged: provider.setQuery,
              ),
              const SizedBox(height: 10),
              // Favorites toggle + Category + Country
              Row(
                children: [
                  // Favorites button
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
                          const Text('Favoris', style: TextStyle(fontSize: 13, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Category dropdown
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
                  // Country dropdown
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
