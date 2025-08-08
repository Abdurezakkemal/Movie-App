import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/data/models/genre.dart';
import 'package:movie_app/app/data/models/movie.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';

class GenreMoviesController extends GetxController {
  final MovieRepository movieRepository;
  final Genre genre = Get.arguments;

  GenreMoviesController({required this.movieRepository});

  final movies = <Movie>[].obs;
  final isLoading = true.obs;
  final _currentPage = 1.obs;
  final _hasMore = true.obs;

  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_scrollListener);
    _fetchMovies();
  }

  void _fetchMovies() async {
    if (!_hasMore.value) return;
    isLoading(true);
    try {
      final newMovies = await movieRepository.getMoviesByGenre(
        genre.id,
        page: _currentPage.value,
      );
      if (newMovies.isEmpty) {
        _hasMore(false);
      } else {
        movies.addAll(newMovies);
        _currentPage.value++;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load movies.');
    } finally {
      isLoading(false);
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 &&
        !isLoading.value) {
      _fetchMovies();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
