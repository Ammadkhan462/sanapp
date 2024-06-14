import 'dart:io';

import 'package:get/get.dart';

import '../modules/clipediting/bindings/clipediting_binding.dart';
import '../modules/clipediting/views/clipediting_view.dart';
import '../modules/crop/bindings/crop_binding.dart';
import '../modules/crop/views/crop_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/controllers/signup_controller.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/signup/views/signupdetails_view.dart';
import '../modules/signup/views/varification_view.dart';
import '../modules/splash/controllers/splash_controller.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: BindingsBuilder.put(() => SplashController()),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP_DETAILS,
      page: () => const SignupdetailsView(),
      binding: BindingsBuilder(() {
        Get.put(SignupController());
      }),
    ),
    GetPage(
      name: _Paths.VarificationView,
      page: () => VerificationView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.CROP,
      page: () => TrimmerView(),
      binding: CropBinding(),
    ),
    GetPage(
      name: '/preview',
      page: () => Preview(
        outputVideoPath: Get.arguments as String,
      ),
    ),
  ];
}
