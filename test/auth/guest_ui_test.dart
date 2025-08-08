import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/data/models/movie.dart';
import 'package:movie_app/app/data/models/review.dart';
import 'package:movie_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:movie_app/app/modules/home/views/home_view.dart';
import 'package:movie_app/app/modules/movie_detail/views/movie_detail_view.dart';
import 'package:movie_app/app/modules/home/controllers/home_controller.dart';
import 'package:movie_app/app/modules/movie_detail/controllers/movie_detail_controller.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';

// Mock MovieRepository for testing purposes
class MockMovieRepository extends GetxService implements MovieRepository {
  @override
  Future<List<Movie>> getPopularMovies() async => [];

  @override
  Future<Movie> getMovieDetail(int movieId) async => Movie(id: movieId, title: 'Test Movie');

  @override
  Future<List<Movie>> searchMovies(String query) async => [];

  @override
  Future<void> addFavorite(Movie movie) async {}

  @override
  Stream<List<Movie>> getFavorites() => Stream.value([]);

  @override
  Future<bool> isFavorite(int movieId) async => false;

  @override
  Future<void> removeFavorite(int movieId) async {}

  @override
  Stream<List<Review>> getMovieReviews(int movieId) => Stream.value([]);

  @override
  Future<void> addReview(int movieId, String reviewText, double rating) async {}

  @override
  Future<List<Movie>> getNowPlayingMovies() async => [];

  @override
  Future<List<Movie>> getTopRatedMovies() async => [];

  @override
  Future<List<Movie>> getUpcomingMovies() async => [];
}

void main() {
  late AuthController authController;

  setUp(() {
    Get.put<MovieRepository>(MockMovieRepository());
    authController = AuthController();
    Get.put(authController);
    Get.put(HomeController(movieRepository: Get.find()));
    Get.put(MovieDetailController(movieRepository: Get.find()));
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('UI elements are hidden for guest users', (WidgetTester tester) async {
    // Set user as guest
    authController.continueAsGuest();

    // Test HomeView
    await tester.pumpWidget(const GetMaterialApp(home: HomeView()));
    expect(find.byIcon(Icons.person), findsNothing);

    // Test MovieDetailView
    // First, navigate to the detail view
    Get.find<MovieDetailController>().movie.value = Movie(id: 1, title: 'Test Movie');
    await tester.pumpWidget(const GetMaterialApp(home: MovieDetailView()));
    expect(find.byIcon(Icons.favorite), findsNothing);
    expect(find.byIcon(Icons.favorite_border), findsNothing);
  });
}
