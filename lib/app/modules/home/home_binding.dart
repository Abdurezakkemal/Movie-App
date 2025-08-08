import 'package:get/get.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';

import 'controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MovieRepository>(() => MovieRepository());
    Get.lazyPut<HomeController>(
      () => HomeController(movieRepository: Get.find<MovieRepository>()),
    );
  }
}
