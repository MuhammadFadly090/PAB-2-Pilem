import 'package:film/models/movie.dart';
import 'package:film/services/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Movie> _allMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];

  bool _isLoading = true;
  String _errorMessage = '';

  Future<void> _loadMovies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await Future.wait([
        _apiService.getAllMovies(),
        _apiService.getTrendingMovie(),
        _apiService.getPopularMovies(),
      ]);

      setState(() {
        _allMovies = results[0].map((e) => Movie.fromJson(e)).toList();
        _trendingMovies = results[1].map((e) => Movie.fromJson(e)).toList();
        _popularMovies = results[2].map((e) => Movie.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load movies: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _refreshMovies() async {
    await _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilem'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : RefreshIndicator(
                  onRefresh: _refreshMovies,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildMovieList("All Movies", _allMovies),
                        _buildMovieList("Trending Movies", _trendingMovies),
                        _buildMovieList("Popular Movies", _popularMovies),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildMovieList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (BuildContext context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                    const SizedBox(
                      height: 5
                      ),
                    Text(
                      movie.title.length > 14
                          ? '${movie.title.substring(0, 10)}....'
                          : movie.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}