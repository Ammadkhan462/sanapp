import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandapp/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:sandapp/app/routes/app_pages.dart';
import 'package:sandapp/common/auth_common.dart';
import 'package:sandapp/common/common_button.dart';
import 'package:sandapp/common/common_text.dart';
import 'package:sandapp/common/common_textfield.dart';
import 'package:sandapp/common/validation.dart';
import 'package:sandapp/constants/constant.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SignupController>(
        init: SignupController(),
        builder: (_) {
          return SingleChildScrollView(
            child: Form(
              key: _.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: 370,
                          child: const Column(
                            children: [],
                          ),
                        ).marginOnly(top: 220, right: 15, left: 15),
                      ),
                      Column(
                        children: [
                          Image.asset(
                            'assets/Framelogosmall.png',
                            scale: 0.80,
                          ).marginOnly(top: 140, left: 10),
                          const CustomText(
                            text: 'Lets get you to the beach!',
                            color: AppColors.darkGrey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ).marginOnly(top: 20),
                          commonTextField(
                            width: 300,
                            context: context,
                            icon: Icons.person_2_outlined,
                            hintText: 'First Name',
                            validator: validateName,
                            controller: _.firstNameController,
                          ).marginOnly(top: 30),
                          commonTextField(
                            context: context,
                            width: 300,
                            validator: validateName,
                            icon: Icons.person_2_outlined,
                            hintText: 'Last Name',
                            controller: _.lastNameController,
                          ).marginOnly(top: 30),
                          commonTextField(
                            hintText: 'Date of Birth',
                            controller: _.dateOfBirthController,
                            isDate: true,
                            context: context,
                            width: 300,
                            icon: Icons.calendar_today,
                          ).marginOnly(top: 30),
                          const CustomText(
                            text: 'Must be 18+ to rent',
                            color: AppColors.grey,
                          ).marginOnly(top: 10, right: 190),
                          Obx(() => CommonButton(
                                borderradius: 90,
                                primary: _.isFieldsFilled.value
                                    ? const Color.fromRGBO(26, 118, 163, 1)
                                    : AppColors.grey,
                                Width: 90,
                                height: 90,
                                bordercolors: Colors.white,
                                textColor: Colors.white,
                                iconData: Icons.arrow_forward,
                                borderside: 10,
                                action: () {
                                  if (_.formKey.currentState!.validate()) {
                                    Get.toNamed(Routes.SIGNUP_DETAILS);
                                  } else {
                                    Get.snackbar("Error",
                                        "Please fill all fields correctly");
                                  }
                                },
                              ).marginOnly(top: 20, left: 10)),
                          AuthOptionsWidget(
                            colors: AppColors.darkGrey,
                            colors2: AppColors.blue,
                            continueText: 'Or continue with',
                            accountQuestionText: 'Already have an account? ',
                            loginText: 'Login',
                            onApplePressed: () {},
                            onGooglePressed: () {
                              Get.find<OnboardingController>().pressed();
                            },
                            onLoginPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
