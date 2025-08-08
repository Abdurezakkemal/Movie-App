import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:movie_app/app/navigation/app_pages.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.WELCOME);
  }
}
