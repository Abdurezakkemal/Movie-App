import 'package:get/get.dart';
import 'package:movie_app/app/data/models/movie.dart';
import 'package:movie_app/app/data/models/review.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailController extends GetxController {
  final MovieRepository movieRepository;
  MovieDetailController({required this.movieRepository});

  final movie = Rx<Movie?>(null);
  final reviews = <Review>[].obs;
  final isLoading = true.obs;
  final isReviewsLoading = false.obs; // Will be handled by the stream's state
  final errorMessage = ''.obs;
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Movie) {
      movie.value = Get.arguments as Movie;
      fetchMovieDetail();
      _listenToFavoriteStatus();
      _listenToMovieReviews(movie.value!.id);
    } else {
      Get.snackbar('Error', 'Failed to load movie details.');
    }
  }

  void fetchMovieDetail() async {
    if (movie.value == null) return;
    final movieId = movie.value!.id;
    try {
      isLoading(true);
      errorMessage.value = '';
      if (movie.value != null) {
        final fullMovieDetail = await movieRepository.getMovieDetails(movieId);
        movie.value = fullMovieDetail;
        _listenToFavoriteStatus(); // Changed from _checkIfFavorite
        if (movie.value != null) {
          _listenToMovieReviews(movie.value!.id);
        }
      }
    } catch (e) {
      errorMessage.value = 'Failed to load movie details. Please try again.';
    } finally {
      isLoading(false);
    }
  }

  void _listenToMovieReviews(int movieId) {
    reviews.bindStream(movieRepository.getMovieReviews(movieId));
  }

  // Binds the favorite status to a stream for real-time updates
  void _listenToFavoriteStatus() {
    if (movie.value != null) {
      isFavorite.bindStream(movieRepository.isFavorite(movie.value!.id));
    }
  }

  void toggleFavoriteStatus() async {
    if (movie.value == null) return;

    final currentStatus = isFavorite.value;
    isFavorite.value = !currentStatus;

    try {
      if (currentStatus) {
        await movieRepository.removeFavorite(movie.value!);
      } else {
        await movieRepository.addFavorite(movie.value!);
      }
    } catch (e) {
      isFavorite.value = currentStatus; // Revert on error
      Get.snackbar('Error', 'Failed to update favorite status.');
    }
  }

  void launchTrailer() {
    final videos = movie.value?.videos;
    if (videos != null && videos.isNotEmpty) {
      final trailer = videos.firstWhere(
        (video) =>
            video.site == 'YouTube' &&
            (video.name.toLowerCase().contains('official trailer') ||
                video.name.toLowerCase().contains('main trailer')),
        orElse: () => videos.firstWhere((video) => video.site == 'YouTube',
            orElse: () => videos.first),
      );

      final YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: trailer.key,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );

      Get.dialog(
        YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
          ),
          builder: (context, player) {
            return player;
          },
        ),
      );
    } else {
      Get.snackbar('No Trailer Found', 'No trailers available for this movie.');
    }
  }
}
