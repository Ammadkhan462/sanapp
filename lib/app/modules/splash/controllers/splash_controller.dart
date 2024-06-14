import 'package:get/get.dart';
import 'package:sandapp/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToonBoarding();
  }

  void _navigateToonBoarding() async {
    await Future.delayed(Duration(seconds: 3));
    try {
      print("About to navigate to Onboarding.");
      Get.offNamed(Routes.ONBOARDING);
      print("Navigation should have happened.");
    } catch (e) {
      print("Failed to navigate: $e");
    }
  }
}
