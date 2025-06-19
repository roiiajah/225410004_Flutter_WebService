class Article {
  final String title;
  final String? description;
  final String? imageUrl;
  final String link;
  final String pubDate;

  Article({
    required this.title,
    this.description,
    this.imageUrl,
    required this.link,
    required this.pubDate,
  });

  // Factory constructor untuk membuat instance Article dari map JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      // Memberi nilai default jika data dari API null
      title: json['title'] ?? 'Tanpa Judul',
      description: json['description'],
      imageUrl: json['image_url'],
      link: json['link'] ?? '',
      pubDate: json['pubDate'] ?? '',
    );
  }
}