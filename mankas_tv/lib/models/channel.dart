class Channel {
  final String id;
  final String name;
  final String? logo;
  final String streamUrl;
  final String? category;
  final String? country;
  final String? language;

  const Channel({
    required this.id,
    required this.name,
    this.logo,
    required this.streamUrl,
    this.category,
    this.country,
    this.language,
  });

  factory Channel.fromM3u(Map<String, String> attrs, String name, String url) {
    return Channel(
      id: attrs['tvg-id'] ?? name.hashCode.toString(),
      name: name,
      logo: attrs['tvg-logo'],
      streamUrl: url,
      category: attrs['group-title'] ?? 'General',
      country: attrs['tvg-country'],
      language: attrs['tvg-language'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'logo': logo,
    'streamUrl': streamUrl,
    'category': category,
    'country': country,
    'language': language,
  };

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
    id: json['id'] as String,
    name: json['name'] as String,
    logo: json['logo'] as String?,
    streamUrl: json['streamUrl'] as String,
    category: json['category'] as String?,
    country: json['country'] as String?,
    language: json['language'] as String?,
  );
}
