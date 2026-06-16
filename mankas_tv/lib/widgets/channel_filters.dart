import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tv_provider.dart';

class ChannelFilters extends StatelessWidget {
  const ChannelFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TvProvider>(
      builder: (context, provider, _) {
        final categories = ['All', ...provider.categories.toList()..sort()];
        final countries = ['All', ...provider.countries.toList()..sort()];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search channels...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  style: const TextStyle(fontSize: 13),
                  onChanged: provider.setQuery,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A3E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: provider.category,
                    isDense: true,
                    dropdownColor: const Color(0xFF2A2A3E),
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                    items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => provider.setCategory(v ?? 'All'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A3E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: provider.country,
                    isDense: true,
                    dropdownColor: const Color(0xFF2A2A3E),
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                    items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => provider.setCountry(v ?? 'All'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
