import 'package:get/get.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';
import 'package:movie_app/app/modules/add_review/controllers/add_review_controller.dart';

class AddReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddReviewController>(
      () => AddReviewController(movieRepository: Get.find<MovieRepository>()),
    );
  }
}
