import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/data/models/movie.dart';
import 'package:movie_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:movie_app/app/modules/home/controllers/home_controller.dart';
import 'package:movie_app/app/components/movie_poster.dart';
import 'package:movie_app/app/navigation/app_pages.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.find<HomeController>();
  final TextEditingController _searchController = TextEditingController();

  final _popularScrollController = ScrollController();
  final _topRatedScrollController = ScrollController();
  final _upcomingScrollController = ScrollController();
  final _searchScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addScrollListener(_popularScrollController, () => controller.fetchPopularMovies());
    _addScrollListener(_topRatedScrollController, () => controller.fetchTopRatedMovies());
    _addScrollListener(_upcomingScrollController, () => controller.fetchUpcomingMovies());
    _addScrollListener(_searchScrollController, () => controller.searchMovies(controller.searchQuery.value));
  }

  void _addScrollListener(ScrollController scrollController, VoidCallback callback) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        callback();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _popularScrollController.dispose();
    _topRatedScrollController.dispose();
    _upcomingScrollController.dispose();
    _searchScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => controller.isSearching.value
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  controller.searchQuery.value = value;
                },
                onSubmitted: (value) {
                  if (controller.searchType.value == 'Movies') {
                    controller.searchMovies(value, isNewSearch: true);
                  } else {
                    controller.searchPeople(value, isNewSearch: true);
                  }
                },
              )
            : const Text('Movie App')),
        actions: [
          Obx(() {
            final authController = Get.find<AuthController>();
            if (authController.isGuest) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Get.toNamed(Routes.PROFILE),
            );
          }),
          Obx(() => controller.isSearching.value
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    controller.clearSearch();
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => controller.isSearching.value = true,
                )),
        ],
      ),
      body: Obx(() {
        if (controller.errorMessage.value.isNotEmpty && !controller.isSearching.value) {
          return _buildErrorWidget(context);
        }

        return controller.isSearching.value
            ? Column(
                children: [
                  _buildSearchTypeSelector(),
                  Expanded(
                    child: Obx(() {
                      if (controller.personMovieCredits.isNotEmpty) {
                        return _buildPersonMovieCredits();
                      }
                      if (controller.searchType.value == 'Movies') {
                        if (controller.searchQuery.value.isEmpty) {
                          return _buildRecentSearches();
                        }
                        if (controller.suggestions.isNotEmpty) {
                          return _buildSearchSuggestions();
                        }
                        return _buildSearchResults();
                      } else {
                        return _buildPeopleResults();
                      }
                    }),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeaturedCarousel(),
                    _buildMovieCategoryRow(
                      title: 'Popular Movies',
                      movies: controller.popularMovies,
                      isLoading: controller.isLoading,
                      isLoadingMore: controller.isPopularLoadingMore,
                      scrollController: _popularScrollController,
                    ),
                    _buildMovieCategoryRow(
                      title: 'Top Rated',
                      movies: controller.topRatedMovies,
                      isLoading: controller.isTopRatedLoading,
                      isLoadingMore: controller.isTopRatedLoadingMore,
                      scrollController: _topRatedScrollController,
                    ),
                    _buildMovieCategoryRow(
                      title: 'Upcoming',
                      movies: controller.upcomingMovies,
                      isLoading: controller.isUpcomingLoading,
                      isLoadingMore: controller.isUpcomingLoadingMore,
                      scrollController: _upcomingScrollController,
                    ),
                  ],
                ),
              );
      }),
    );
  }

  Widget _buildFeaturedCarousel() {
    return Obx(() {
      if (controller.isFeaturedLoading.value) {
        return SizedBox(
          height: Get.width * 9 / 16,
          child: const Center(child: CircularProgressIndicator()),
        );
      }
      return CarouselSlider.builder(
        itemCount: controller.featuredMovies.length,
        itemBuilder: (context, index, realIndex) {
          final movie = controller.featuredMovies[index];
          return InkWell(
            onTap: () => Get.toNamed(Routes.MOVIE_DETAIL, arguments: movie),
            child: Stack(
              children: [
                if (movie.backdropPath != null)
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                    fit: BoxFit.cover,
                    width: Get.width,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    color: Colors.black.withOpacity(0.5),
                    child: Text(
                      movie.title,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          aspectRatio: 16 / 9,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
        ),
      );
    });
  }

  Widget _buildMovieCategoryRow({
    required String title,
    required RxList<Movie> movies,
    required RxBool isLoading,
    required RxBool isLoadingMore,
    required ScrollController scrollController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Obx(() {
          if (isLoading.value && movies.isEmpty) {
            return const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return SizedBox(
            height: 180,
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: movies.length + (isLoadingMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == movies.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final movie = movies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: MoviePoster(movie: movie),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecentSearches() {
    return Obx(() {
      if (controller.recentSearches.isEmpty) {
        return const Center(
          child: Text('No recent searches.'),
        );
      }
      return ListView.builder(
        itemCount: controller.recentSearches.length,
        itemBuilder: (context, index) {
          final query = controller.recentSearches[index];
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(query),
            onTap: () {
              _searchController.text = query;
              controller.searchQuery.value = query;
              controller.searchMovies(query, isNewSearch: true);
            },
          );
        },
      );
    });
  }

  Widget _buildSearchSuggestions() {
    return Obx(() {
      if (controller.isSuggestionsLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: controller.suggestions.length,
        itemBuilder: (context, index) {
          final movie = controller.suggestions[index];
          return ListTile(
            title: Text(movie.title),
            onTap: () {
              _searchController.text = movie.title;
              controller.searchMovies(movie.title, isNewSearch: true);
            },
          );
        },
      );
    });
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.searchResults.isEmpty) {
        return const Center(
          child: Text('No results found.'),
        );
      }
      return ListView.builder(
        controller: _searchScrollController,
        itemCount: controller.searchResults.length + (controller.isSearchLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.searchResults.length) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ));
          }
          final movie = controller.searchResults[index];
          return ListTile(
            leading: movie.posterPath != null
                ? Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
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
    });
  }

  Widget _buildSearchTypeSelector() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ToggleButtons(
            isSelected: [
              controller.searchType.value == 'Movies',
              controller.searchType.value == 'People',
            ],
            onPressed: (index) {
              controller.searchType.value = index == 0 ? 'Movies' : 'People';
              // Clear results when switching types
              controller.searchResults.clear();
              controller.peopleResults.clear();
              controller.personMovieCredits.clear();
            },
            borderRadius: BorderRadius.circular(8),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Movies'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('People'),
              ),
            ],
          ),
        ));
  }

  Widget _buildPeopleResults() {
    return Obx(() {
      if (controller.isPeopleLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.peopleResults.isEmpty) {
        return const Center(child: Text('Search for an actor or director.'));
      }
      return ListView.builder(
        itemCount: controller.peopleResults.length,
        itemBuilder: (context, index) {
          final person = controller.peopleResults[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: person.profilePath != null
                  ? NetworkImage('https://image.tmdb.org/t/p/w200${person.profilePath}')
                  : null,
              child: person.profilePath == null ? const Icon(Icons.person) : null,
            ),
            title: Text(person.name),
            subtitle: Text(person.knownForDepartment ?? 'Unknown'),
            onTap: () => controller.getPersonMovieCredits(person.id),
          );
        },
      );
    });
  }

  Widget _buildPersonMovieCredits() {
    return Obx(() {
      if (controller.isCreditsLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Search'),
              onPressed: () => controller.personMovieCredits.clear(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.personMovieCredits.length,
              itemBuilder: (context, index) {
                final movie = controller.personMovieCredits[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    child: MoviePoster(movie: movie),
                  ),
                  title: Text(movie.title),
                  subtitle: Text(movie.releaseDate != null && movie.releaseDate!.length >= 4
                      ? movie.releaseDate!.substring(0, 4)
                      : 'N/A'),
                  onTap: () => Get.toNamed(Routes.MOVIE_DETAIL, arguments: movie),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(controller.errorMessage.value, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => controller.fetchInitialData(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
