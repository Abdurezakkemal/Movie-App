import 'package:get/get.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';
import 'package:movie_app/app/modules/favorites/controllers/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesController>(
      () => FavoritesController(movieRepository: Get.find<MovieRepository>()),
    );
  }
}
