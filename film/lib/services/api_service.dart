import 'package:http/http.dart' as http; 
import 'dart:convert'; 

class ApiService {
  static const String apiKey = '9356b2438d694ffe7881d9d4c974772b';
  static const String baseUrl = 'https://api.themoviedb.org/3'; 
  static const String bearerToken = ""; 

  Future<List<Map<String, dynamic>>> getAllMovies() async {
    final response = await http.get(
      Uri.parse("$baseUrl/movie/now_playing?api_key=$apiKey"), 
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body); 
      return List<Map<String, dynamic>>.from(data['results']); 
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Map<String, dynamic>>> getTrendingMovie() async {
    final response = await http.get(
      Uri.parse("$baseUrl/trending/movie/week?api_key=$apiKey"), 
    );
    final data =json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<List<Map<String, dynamic>>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse("$baseUrl/movie/popular?api_key=$apiKey"), 
    );

    final data =json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }
}