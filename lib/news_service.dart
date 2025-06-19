import 'package:http/http.dart' as http;
import 'dart:convert';
import 'news_model.dart';

class NewsService {
  // URL API yang Anda berikan
  // PERHATIAN: Sebaiknya simpan API Key di tempat yang aman, bukan di-hardcode seperti ini.
  final String apiUrl =
      "https://newsdata.io/api/1/latest?apikey=pub_2fd7edaca0124d5899b68b6e9aabfd48&q=MotoGP&country=id&language=id&category=sports&timezone=Asia/Jakarta";

  Future<List<Article>> fetchNews() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Jika request berhasil (kode status 200)
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> results = jsonResponse['results'];

      // Mengubah setiap item di list JSON menjadi objek Article
      return results.map((json) => Article.fromJson(json)).toList();
    } else {
      // Jika request gagal, lemparkan error
      throw Exception('Gagal memuat berita dari API');
    }
  }
}