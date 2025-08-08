import 'package:get/get.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';
import 'package:movie_app/app/modules/discover/controllers/discover_controller.dart';
import 'package:movie_app/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:movie_app/app/modules/home/controllers/home_controller.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(
      () => HomeController(movieRepository: Get.find<MovieRepository>()),
    );
    Get.lazyPut<DiscoverController>(() => DiscoverController());
    Get.lazyPut<FavoritesController>(
      () => FavoritesController(movieRepository: Get.find<MovieRepository>()),
    );
  }
}
