import 'package:get/get.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MovieRepository>(() => MovieRepository(), fenix: true);
  }
}
