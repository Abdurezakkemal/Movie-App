import 'package:get/get.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';
import 'package:movie_app/app/modules/watchlist/controllers/watchlist_controller.dart';

class WatchlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WatchlistController>(
      () => WatchlistController(movieRepository: Get.find<MovieRepository>()),
    );
  }
}
