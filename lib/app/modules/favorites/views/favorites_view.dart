import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:movie_app/app/navigation/app_pages.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favoriteMovies.isEmpty) {
          return const Center(
            child: Text(
              'You have no favorite movies yet.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.favoriteMovies.length,
          itemBuilder: (context, index) {
            final movie = controller.favoriteMovies[index];
            return InkWell(
              onTap: () => Get.toNamed(Routes.MOVIE_DETAIL, arguments: movie),
              child: ListTile(
                leading: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath ?? ''}',
                  width: 100,
                  fit: BoxFit.cover,
                ),
                title: Text(movie.title),
                subtitle: Text(
                  movie.overview ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
