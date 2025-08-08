import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/modules/watchlist/controllers/watchlist_controller.dart';
import 'package:movie_app/app/navigation/app_pages.dart';

class WatchlistView extends GetView<WatchlistController> {
  const WatchlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.watchlist.isEmpty) {
          return const Center(
            child: Text('Your watchlist is empty.'),
          );
        }
        return ListView.builder(
          itemCount: controller.watchlist.length,
          itemBuilder: (context, index) {
            final movie = controller.watchlist[index];
            return ListTile(
              leading: movie.posterPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      width: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.movie),
              title: Text(movie.title),
              subtitle: Text(
                movie.overview ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Get.toNamed(Routes.MOVIE_DETAIL, arguments: movie),
            );
          },
        );
      }),
    );
  }
}
