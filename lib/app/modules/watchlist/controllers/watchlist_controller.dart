import 'package:get/get.dart';
import 'package:movie_app/app/data/models/movie.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';

class WatchlistController extends GetxController {
  final MovieRepository movieRepository;
  WatchlistController({required this.movieRepository});

  final watchlist = <Movie>[].obs;

  @override
  void onInit() {
    super.onInit();
    watchlist.bindStream(movieRepository.getFavorites());
  }
}
