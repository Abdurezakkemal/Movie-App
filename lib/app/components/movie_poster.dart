import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/data/models/movie.dart';
import 'package:movie_app/app/navigation/app_pages.dart';

class MoviePoster extends StatelessWidget {
  final Movie movie;

  const MoviePoster({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.MOVIE_DETAIL, arguments: movie),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          'https://image.tmdb.org/t/p/w200${movie.posterPath}',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.error));
          },
        ),
      ),
    );
  }
}
