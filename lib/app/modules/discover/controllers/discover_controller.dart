import 'package:get/get.dart';
import 'package:movie_app/app/data/models/genre.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';

class DiscoverController extends GetxController {
  final MovieRepository _repository = Get.find<MovieRepository>();

  final genres = <Genre>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGenres();
  }

  void fetchGenres() async {
    try {
      isLoading.value = true;
      final result = await _repository.getGenres();
      genres.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load genres');
    } finally {
      isLoading.value = false;
    }
  }
}
