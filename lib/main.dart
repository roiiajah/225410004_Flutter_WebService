import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_service.dart';
import 'news_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berita MotoGP',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Article>> _futureNews;
  final NewsService _newsService = NewsService();

  @override
  void initState() {
    super.initState();
    // Memanggil fetchNews() saat widget pertama kali dibuat
    _futureNews = _newsService.fetchNews();
  }

  // Fungsi untuk membuka URL
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      // Menampilkan pesan error jika gagal membuka URL
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka link $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita MotoGP Indonesia'),
      ),
      body: Center(
        child: FutureBuilder<List<Article>>(
          future: _futureNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Tampilkan loading indicator saat data sedang diambil
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Tampilkan pesan error jika terjadi kesalahan
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Tampilkan pesan jika tidak ada data
              return const Text('Tidak ada berita ditemukan.');
            } else {
              // Tampilkan daftar berita jika data berhasil didapat
              List<Article> articles = snapshot.data!;
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        // Buka link berita saat card di-tap
                        if (article.link.isNotEmpty) {
                          _launchURL(article.link);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Menampilkan gambar berita
                            if (article.imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  article.imageUrl!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  // Widget yang ditampilkan saat loading gambar
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null
                                        ? child
                                        : const SizedBox(
                                            height: 200,
                                            child: Center(child: CircularProgressIndicator()),
                                          );
                                  },
                                  // Widget yang ditampilkan jika gambar gagal dimuat
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(
                                      height: 200,
                                      child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                            const SizedBox(height: 12),
                            // Judul Berita
                            Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Deskripsi Berita
                            if (article.description != null)
                              Text(
                                article.description!,
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}