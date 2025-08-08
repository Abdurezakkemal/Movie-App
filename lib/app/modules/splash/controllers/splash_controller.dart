import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // Simulate a delay for the splash screen
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the next screen (e.g., Welcome or Home)
      // We'll define the route later
      Get.offAllNamed('/welcome'); 
    });
  }
}
