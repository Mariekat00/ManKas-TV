class M3uParser {
  static final _attrPattern = RegExp(r'([a-zA-Z0-9_-]+)="([^"]*)"');

  static List<M3uChannel> parse(String content) {
    final lines = content.split(RegExp(r'\r?\n')).map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    final channels = <M3uChannel>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (!line.startsWith('#EXTINF')) continue;

      final nextLine = (i + 1 < lines.length) ? lines[i + 1] : null;
      if (nextLine == null || nextLine.startsWith('#')) continue;

      final attrs = <String, String>{};
      for (final match in _attrPattern.allMatches(line)) {
        attrs[match.group(1)!.toLowerCase()] = match.group(2)!;
      }

      final commaIndex = line.indexOf(',');
      final rawName = commaIndex != -1
          ? line.substring(commaIndex + 1).trim()
          : attrs['tvg-name'] ?? 'Sans nom';

      channels.add(M3uChannel(
        name: rawName,
        logo: attrs['tvg-logo'],
        streamUrl: nextLine,
        category: attrs['group-title'] ?? 'Général',
        country: attrs['tvg-country'],
        language: attrs['tvg-language'],
      ));
    }

    return channels;
  }
}

class M3uChannel {
  final String name;
  final String? logo;
  final String streamUrl;
  final String category;
  final String? country;
  final String? language;

  const M3uChannel({
    required this.name,
    this.logo,
    required this.streamUrl,
    required this.category,
    this.country,
    this.language,
  });
}
