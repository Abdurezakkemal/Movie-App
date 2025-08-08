import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/modules/auth/controllers/auth_controller.dart';

void main() {
  group('AuthController', () {
    late AuthController authController;

    setUp(() {
      authController = AuthController();
      Get.put(authController);
    });

    tearDown(() {
      Get.reset();
    });

    test('Initial state is logged out and not a guest', () {
      expect(authController.isLoggedIn, isFalse);
      expect(authController.isGuest, isFalse);
    });

    test('continueAsGuest sets guest status correctly', () {
      authController.continueAsGuest();
      expect(authController.isGuest, isTrue);
      expect(authController.isLoggedIn, isFalse);
    });

    test('login sets loggedIn status correctly', () {
      authController.login('test@test.com', 'password');
      expect(authController.isLoggedIn, isTrue);
      expect(authController.isGuest, isFalse);
    });

    test('signUp sets loggedIn status correctly', () {
      authController.signUp('test@test.com', 'password');
      expect(authController.isLoggedIn, isTrue);
      expect(authController.isGuest, isFalse);
    });

    test('logout resets auth state', () {
      authController.login('test@test.com', 'password');
      authController.logout();
      expect(authController.isLoggedIn, isFalse);
      expect(authController.isGuest, isFalse);
    });
  });
}
