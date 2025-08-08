import 'package:get/get.dart';
import 'package:movie_app/app/data/models/movie.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';

class FavoritesController extends GetxController {
  final MovieRepository movieRepository;

  FavoritesController({required this.movieRepository});

  final favoriteMovies = <Movie>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchFavorites();
  }

  void _fetchFavorites() {
    isLoading(true);
    movieRepository.getFavorites().listen((movies) {
      favoriteMovies.assignAll(movies);
      isLoading(false);
    }, onError: (error) {
      isLoading(false);
      Get.snackbar('Error', 'Failed to load favorites.');
    });
  }
}
