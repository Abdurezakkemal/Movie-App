import 'package:get/get.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';
import 'package:movie_app/app/modules/genre_movies/controllers/genre_movies_controller.dart';

class GenreMoviesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenreMoviesController>(
      () => GenreMoviesController(movieRepository: Get.find<MovieRepository>()),
    );
  }
}
