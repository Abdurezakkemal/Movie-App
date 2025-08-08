import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_review_controller.dart';

class AddReviewView extends GetView<AddReviewController> {
  const AddReviewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.reviewTextController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => _buildStarRating(controller.rating.value)),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.submitReview(),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Review'),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double currentRating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < currentRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            controller.rating.value = index + 1.0;
          },
        );
      }),
    );
  }
}
