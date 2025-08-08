import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:movie_app/app/modules/main/controllers/main_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${controller.user?.displayName ?? 'Guest'}!',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              controller.user?.email ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Get.find<MainController>().changeTabIndex(2);
                Get.back();
              },
              child: const Text('My Favorites'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.logout(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
