import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:movie_app/app/modules/movie_detail/controllers/movie_detail_controller.dart';
import 'package:movie_app/app/data/models/review.dart';
import 'package:movie_app/app/navigation/app_pages.dart';

class MovieDetailView extends GetView<MovieDetailController> {
  const MovieDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.movie.value?.title ?? 'Movie Detail')),
        centerTitle: true,
        actions: [
          Obx(() {
            final authController = Get.find<AuthController>();
            if (authController.isGuest) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () => controller.toggleFavoriteStatus(),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorWidget(context);
        }

        if (controller.isLoading.value && controller.movie.value?.cast == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final movie = controller.movie.value;
        if (movie == null) {
          return const Center(child: Text('Movie not found.'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (movie.posterPath != null)
                Center(
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${movie.voteAverage?.toStringAsFixed(1) ?? 'N/A'} / 10',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${movie.releaseDate ?? 'N/A'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (movie.videos?.isNotEmpty ?? false)
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Watch Trailer'),
                    onPressed: () => controller.launchTrailer(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                movie.overview ?? 'No overview available.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              if (movie.cast?.isNotEmpty ?? false)
                _buildCastSection(context, movie.cast!),
              const SizedBox(height: 24),
              _buildReviewsSection(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Obx(() {
              if (authController.isLoggedIn) {
                return TextButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Write a Review'),
                  onPressed: () => Get.toNamed(
                    Routes.ADD_REVIEW,
                    arguments: controller.movie.value?.id,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isReviewsLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.reviews.isEmpty) {
            return const Text('No reviews yet.');
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.reviews.length,
            itemBuilder: (context, index) {
              final review = controller.reviews[index];
              return _buildReviewItem(review);
            },
          );
        }),
      ],
    );
  }

  Widget _buildReviewItem(Review review) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.author,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (review.rating != null)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text('${review.rating}/10'),
                ],
              ),
            const SizedBox(height: 4),
            Text(review.content),
          ],
        ),
      ),
    );
  }

  Widget _buildCastSection(BuildContext context, List<dynamic> cast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cast',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final actor = cast[index];
              return _buildCastItem(actor);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCastItem(dynamic actor) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: actor.profilePath != null
                ? NetworkImage('https://image.tmdb.org/t/p/w200${actor.profilePath}')
                : null,
            child: actor.profilePath == null
                ? const Icon(Icons.person, size: 40)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            actor.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchMovieDetail(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
