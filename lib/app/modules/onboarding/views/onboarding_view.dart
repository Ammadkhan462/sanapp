  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:sandapp/app/modules/onboarding/controllers/onboarding_controller.dart';
  import 'package:sandapp/app/routes/app_pages.dart';
  import 'package:sandapp/common/auth_common.dart';
  import 'package:sandapp/common/common_button.dart';
  import 'package:sandapp/constants/constant.dart';

  class OnboardingView extends GetView<OnboardingController> {
    const OnboardingView({Key? key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: Stack(children: [
        Image.asset('assets/App_2_OnboardingPage.png',
            fit: BoxFit.cover, width: double.infinity, height: double.infinity),
        GetBuilder<OnboardingController>(
            init: OnboardingController(),
            builder: (_) {
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/onboardinglogo.png')
                          .marginOnly(top: 50),
                      Center(
                          child: CommonButton(
                        text: 'Create Account',
                        Width: 330,
                        height: 50,
                        borderradius: 25,
                        action: () {
                          Get.toNamed(Routes.SIGNUP);
                        },
                        fontsizee: 14,
                        primary: AppColors.blue,
                        textColor: Colors.white,
                        shadowColor: Colors.black,
                      ).marginOnly(
                        top: 400,
                      )),
                      AuthOptionsWidget(
                          colors: Colors.white,
                          colors2: Colors.yellow,
                          continueText: 'Or continue with',
                          accountQuestionText: 'Already have an account?',
                          loginText: 'Login',
                          onApplePressed: () {},
                          onGooglePressed: () {
                            _.pressed();
                          },
                          onLoginPressed: () {})
                    ]),
              );
            })
      ]));
    }
  }
