import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/data/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_app/app/data/models/person.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';

class HomeController extends GetxController {
  final MovieRepository movieRepository;
  HomeController({required this.movieRepository});

  // Movie Lists
  final popularMovies = <Movie>[].obs;
  final featuredMovies = <Movie>[].obs;
  final topRatedMovies = <Movie>[].obs;
  final upcomingMovies = <Movie>[].obs;
  final searchResults = <Movie>[].obs;

  // Loading States
  final isLoading = true.obs;
  final isFeaturedLoading = true.obs;
  final isTopRatedLoading = true.obs;
  final isUpcomingLoading = true.obs;
  final isSearching = false.obs;
  final isSuggestionsLoading = false.obs;

  // Pagination Loading States
  final isPopularLoadingMore = false.obs;
  final isTopRatedLoadingMore = false.obs;
  final isUpcomingLoadingMore = false.obs;
  final isSearchLoadingMore = false.obs;

  // Pagination Page Counters
  var _popularPage = 1;
  var _topRatedPage = 1;
  var _upcomingPage = 1;
  var _searchPage = 1;
  String _lastSearchQuery = '';

  // Search and Suggestions
  final recentSearches = <String>[].obs;
  final searchType = 'Movies'.obs; // 'Movies' or 'People'
  final peopleResults = <Person>[].obs;
  final isPeopleLoading = false.obs;
  final personMovieCredits = <Movie>[].obs;
  final isCreditsLoading = false.obs;
  final suggestions = <Movie>[].obs;
  final searchQuery = ''.obs;
  final errorMessage = ''.obs;

  static const _recentSearchesKey = 'recent_searches';

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
    _loadRecentSearches();

    // Debounce search queries
    debounce(searchQuery, (_) {
      if (searchQuery.value.isEmpty) {
        suggestions.clear();
      } else {
        fetchMovieSuggestions(searchQuery.value);
      }
    }, time: const Duration(milliseconds: 500));
  }

  Future<void> fetchInitialData() async {
    try {
      isLoading(true);
      errorMessage.value = '';
      await Future.wait([
        fetchPopularMovies(isInitialLoad: true),
        fetchFeaturedMovies(),
        fetchTopRatedMovies(isInitialLoad: true),
        fetchUpcomingMovies(isInitialLoad: true),
      ]);
    } on SocketException catch (e) {
      debugPrint('SocketException in fetchInitialData: $e');
      errorMessage.value = 'No Internet Connection. Please check your network and try again.';
    } catch (e) {
      debugPrint('Error in fetchInitialData: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again later.';
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchPopularMovies({bool isInitialLoad = false}) async {
    if (isPopularLoadingMore.value) return;

    try {
      if (isInitialLoad) {
        isLoading(true);
        _popularPage = 1;
        popularMovies.clear();
      } else {
        isPopularLoadingMore(true);
      }
      errorMessage.value = '';
      var movies = await movieRepository.getTrendingMovies(page: _popularPage);
      if (movies.isNotEmpty) {
        popularMovies.addAll(movies);
        _popularPage++;
      }
    } on SocketException catch (e) {
      debugPrint('SocketException in fetchPopularMovies: $e');
      errorMessage.value = 'No Internet Connection. Please check your network and try again.';
    } catch (e) {
      debugPrint('Error fetching popular movies: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again later.';
    } finally {
      if (isInitialLoad) {
        isLoading(false);
      } else {
        isPopularLoadingMore(false);
      }
    }
  }

  Future<void> fetchFeaturedMovies() async {
    try {
      isFeaturedLoading(true);
      var movies = await movieRepository.getNowPlayingMovies();
      featuredMovies.assignAll(movies);
    } on SocketException catch (e) {
      debugPrint('SocketException in fetchFeaturedMovies: $e');
      errorMessage.value = 'No Internet Connection. Please check your network and try again.';
    } catch (e) {
      debugPrint('Error fetching featured movies: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again later.';
    } finally {
      isFeaturedLoading(false);
    }
  }

  Future<void> fetchTopRatedMovies({bool isInitialLoad = false}) async {
    if (isTopRatedLoadingMore.value) return;

    try {
      if (isInitialLoad) {
        isTopRatedLoading(true);
        _topRatedPage = 1;
        topRatedMovies.clear();
      } else {
        isTopRatedLoadingMore(true);
      }
      var movies = await movieRepository.getTopRatedMovies(page: _topRatedPage);
      if (movies.isNotEmpty) {
        topRatedMovies.addAll(movies);
        _topRatedPage++;
      }
    } on SocketException catch (e) {
      debugPrint('SocketException in fetchTopRatedMovies: $e');
      errorMessage.value = 'No Internet Connection. Please check your network and try again.';
    } catch (e) {
      debugPrint('Error fetching top rated movies: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again later.';
    } finally {
      if (isInitialLoad) {
        isTopRatedLoading(false);
      } else {
        isTopRatedLoadingMore(false);
      }
    }
  }

  Future<void> fetchUpcomingMovies({bool isInitialLoad = false}) async {
    if (isUpcomingLoadingMore.value) return;
    
    try {
      if (isInitialLoad) {
        isUpcomingLoading(true);
        _upcomingPage = 1;
        upcomingMovies.clear();
      } else {
        isUpcomingLoadingMore(true);
      }
      var movies = await movieRepository.getUpcomingMovies(page: _upcomingPage);
      if (movies.isNotEmpty) {
        upcomingMovies.addAll(movies);
        _upcomingPage++;
      }
    } on SocketException catch (e) {
      debugPrint('SocketException in fetchUpcomingMovies: $e');
      errorMessage.value = 'No Internet Connection. Please check your network and try again.';
    } catch (e) {
      debugPrint('Error fetching upcoming movies: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again later.';
    } finally {
      if (isInitialLoad) {
        isUpcomingLoading(false);
      } else {
        isUpcomingLoadingMore(false);
      }
    }
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.isEmpty) return;

    recentSearches.remove(query);
    recentSearches.insert(0, query);
    if (recentSearches.length > 10) {
      recentSearches.removeRange(10, recentSearches.length);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentSearchesKey, recentSearches.toList());
  }

  void fetchMovieSuggestions(String query) async {
    if (query.length < 2) {
      suggestions.clear();
      return;
    }
    try {
      isSuggestionsLoading(true);
      var movies = await movieRepository.searchMovies(query);
      suggestions.assignAll(movies);
    } on SocketException catch (e) {
      debugPrint('SocketException in fetchMovieSuggestions: $e');
      errorMessage.value = 'No Internet Connection. Please check your network and try again.';
    } catch (e) {
      debugPrint('Error fetching movie suggestions: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again later.';
    } finally {
      isSuggestionsLoading(false);
    }
  }

  Future<void> searchMovies(String query, {bool isNewSearch = false}) async {
    if (query.isEmpty) {
      isSearching(false);
      searchResults.clear();
      return;
    }
    if (isSearchLoadingMore.value) return;

    try {
      if (isNewSearch) {
        isSearching(true);
        isLoading(true);
        _searchPage = 1;
        searchResults.clear();
        _lastSearchQuery = query;
        await _saveRecentSearch(query);
      } else {
        isSearchLoadingMore(true);
      }
      errorMessage.value = '';
      var movies = await movieRepository.searchMovies(_lastSearchQuery, page: _searchPage);
      if (movies.isNotEmpty) {
        searchResults.addAll(movies);
        _searchPage++;
      }
    } on SocketException catch (e) {
      debugPrint('SocketException in fetchInitialData: $e');
      errorMessage.value = 'No Internet Connection. Please check your network and try again.';
    } catch (e) {
      debugPrint('Error in fetchInitialData: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again later.';
    } finally {
      if (isNewSearch) {
        isLoading(false);
      } else {
        isSearchLoadingMore(false);
      }
    }
  }

  void _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    recentSearches.assignAll(prefs.getStringList(_recentSearchesKey) ?? []);
  }

  Future<void> searchPeople(String query, {bool isNewSearch = false}) async {
    if (isNewSearch) {
      peopleResults.clear();
    }
    isPeopleLoading(true);
    try {
      final results = await movieRepository.searchPeople(query);
      peopleResults.assignAll(results);
    } catch (e) {
      debugPrint('Error searching people: $e');
      errorMessage.value = 'Failed to search for people.';
    } finally {
      isPeopleLoading(false);
    }
  }

  Future<void> getPersonMovieCredits(int personId) async {
    isCreditsLoading(true);
    try {
      final movies = await movieRepository.getPersonMovieCredits(personId);
      personMovieCredits.assignAll(movies);
    } catch (e) {
      debugPrint('Error getting person credits: $e');
      errorMessage.value = 'Failed to load movie credits.';
    } finally {
      isCreditsLoading(false);
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    isSearching(false);
    searchResults.clear();
    suggestions.clear();
    _lastSearchQuery = '';
    _searchPage = 1;
  }
}
