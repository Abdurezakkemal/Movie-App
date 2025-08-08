import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:movie_app/app/navigation/app_pages.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.movie_creation_outlined,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Movie App',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Discover and stream your favorite movies.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () { 
                Get.toNamed(Routes.SIGNUP);
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.LOGIN);
              },
              child: const Text('Log In'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Get.find<AuthController>().continueAsGuest();
                Get.offAllNamed(Routes.MAIN);
              },
              child: const Text('Continue as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}
