import 'package:get/get.dart';

class AuthController extends GetxController {
  final RxBool _isLoggedIn = false.obs;
  final RxBool _isGuest = false.obs;

  bool get isLoggedIn => _isLoggedIn.value;
  bool get isGuest => _isGuest.value;

  void login(String email, String password) {
    // In a real app, you'd have your login logic here.
    // For now, we'll just simulate a successful login.
    _isLoggedIn.value = true;
    _isGuest.value = false;
    update();
  }

  void signUp(String email, String password) {
    // In a real app, you'd have your sign-up logic here.
    // For now, we'll just simulate a successful sign-up.
    _isLoggedIn.value = true;
    _isGuest.value = false;
    update();
  }

  void continueAsGuest() {
    _isGuest.value = true;
    _isLoggedIn.value = false;
    update();
  }

  void logout() {
    _isLoggedIn.value = false;
    _isGuest.value = false;
    update();
  }
}
