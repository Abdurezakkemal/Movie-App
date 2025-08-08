import 'package:get/get.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';
import 'package:movie_app/app/modules/movie_detail/controllers/movie_detail_controller.dart';

class MovieDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MovieDetailController>(
      () => MovieDetailController(
        movieRepository: Get.find<MovieRepository>(),
      ),
    );
  }
}
