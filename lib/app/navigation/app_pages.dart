import 'package:get/get.dart';
import 'package:movie_app/app/middlewares/auth_middleware.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/welcome/views/welcome_view.dart';
import '../modules/welcome/welcome_binding.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/login_binding.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/auth/signup_binding.dart';
import '../modules/movie_detail/views/movie_detail_view.dart';
import '../modules/movie_detail/movie_detail_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/profile_binding.dart';
import '../modules/add_review/views/add_review_view.dart';
import '../modules/add_review/bindings/add_review_binding.dart';
import '../modules/genre_movies/bindings/genre_movies_binding.dart';
import '../modules/genre_movies/views/genre_movies_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.MOVIE_DETAIL,
      page: () => const MovieDetailView(),
      binding: MovieDetailBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: _Paths.ADD_REVIEW,
      page: () => const AddReviewView(),
      binding: AddReviewBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.GENRE_MOVIES,
      page: () => const GenreMoviesView(),
      binding: GenreMoviesBinding(),
    ),
  ];
}
