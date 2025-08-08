import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/genre.dart';
import '../models/movie.dart';
import '../models/person.dart';
import '../models/review.dart';
import '../models/video.dart';

// Top-level function for background parsing, as required by compute
List<Movie> _parseMoviesFromFirestore(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
  final movies = <Movie>[];
  for (var doc in docs) {
    try {
      movies.add(Movie.fromFirestore(doc.data()));
    } catch (e) {
      debugPrint('Failed to parse favorite movie: ${doc.id}, error: $e');
    }
  }
  return movies;
}

class MovieRepository {
  final String _apiKey = dotenv.env['TMDB_API_KEY']!;
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/movie/now_playing?api_key=$_apiKey&page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/movie/top_rated?api_key=$_apiKey&page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/movie/upcoming?api_key=$_apiKey&page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/trending/movie/day?api_key=$_apiKey&page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey'));
    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&query=$query&page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<List<Genre>> getGenres() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/genre/movie/list?api_key=$_apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['genres'];
      return results.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/discover/movie?api_key=$_apiKey&with_genres=$genreId&page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies by genre');
    }
  }

  // --- Reviews (Aligned with CONTEXT.md) ---
  Stream<List<Review>> getMovieReviews(int movieId) {
    return _firestore
        .collection('reviews')
        .where('movieId', isEqualTo: movieId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Review.fromFirestore(doc.data()))
            .toList());
  }

  Future<void> addReview(int movieId, String reviewText, double rating) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('reviews').add({
        'userId': user.uid,
        'movieId': movieId,
        'rating': rating,
        'reviewText': reviewText,
        'createdAt': FieldValue.serverTimestamp(),
        'author': user.displayName ?? 'Anonymous',
      });
    }
  }

  // --- Favorites (Aligned with CONTEXT.md) ---
  // NOTE: This implementation fetches full movie details for each favorite ID.
  // This can be slow if the favorites list is very large.
  Stream<List<Movie>> getFavorites() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    return _firestore
        .collection('favorites')
        .doc(user.uid)
        .snapshots()
        .asyncMap((doc) async {
      if (!doc.exists || doc.data()?['movies'] == null) {
        return <Movie>[];
      }
      final movieIds = List<int>.from(doc.data()!['movies']);
      final movieFutures = movieIds.map((id) => getMovieDetails(id));
      return await Future.wait(movieFutures);
    });
  }

  Future<void> addFavorite(Movie movie) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('favorites').doc(user.uid).set({
        'movies': FieldValue.arrayUnion([movie.id]),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> removeFavorite(Movie movie) async {
    final movieId = movie.id;
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('favorites').doc(user.uid).update({
        'movies': FieldValue.arrayRemove([movieId]),
      });
    }
  }

  Stream<bool> isFavorite(int movieId) {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(false);
    }
    return _firestore
        .collection('favorites')
        .doc(user.uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists || doc.data()?['movies'] == null) {
        return false;
      }
      final movieIds = List<int>.from(doc.data()!['movies']);
      return movieIds.contains(movieId);
    });
  }

  // --- People / Credits ---
  Future<List<Person>> searchPeople(String query, {int page = 1}) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/search/person?api_key=$_apiKey&query=$query&page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Person.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search people');
    }
  }

  Future<List<Movie>> getPersonMovieCredits(int personId) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/person/$personId/movie_credits?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['cast'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load person movie credits');
    }
  }

  Future<List<Video>> getMovieVideos(int movieId) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Video.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movie videos');
    }
  }
}
