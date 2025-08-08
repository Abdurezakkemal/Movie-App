import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/components/movie_poster.dart';
import 'package:movie_app/app/modules/genre_movies/controllers/genre_movies_controller.dart';

class GenreMoviesView extends GetView<GenreMoviesController> {
  const GenreMoviesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.genre.name),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.movies.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: controller.movies.length + (controller.isLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.movies.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final movie = controller.movies[index];
            return MoviePoster(movie: movie);
          },
        );
      }),
    );
  }
}
