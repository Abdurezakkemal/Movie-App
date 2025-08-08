import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/data/repositories/movie_repository.dart';

class AddReviewController extends GetxController {
  final MovieRepository movieRepository;
  AddReviewController({required this.movieRepository});

  late final int movieId;
  final reviewTextController = TextEditingController();
  final rating = 0.0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    movieId = Get.arguments as int;
  }

  void submitReview() async {
    if (reviewTextController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your review.');
      return;
    }

    isLoading(true);
    try {
      await movieRepository.addReview(
        movieId,
        reviewTextController.text,
        rating.value,
      );
      Get.back(); // Go back to the movie detail screen
      Get.snackbar('Success', 'Your review has been submitted!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit your review. Please try again.');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    reviewTextController.dispose();
    super.onClose();
  }
}
