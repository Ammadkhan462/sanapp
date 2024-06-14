import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandapp/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:sandapp/app/modules/signup/controllers/signup_controller.dart';
import 'package:sandapp/common/auth_common.dart';
import 'package:sandapp/common/common_button.dart';
import 'package:sandapp/common/common_text.dart';
import 'package:sandapp/common/common_textfield.dart';
import 'package:sandapp/constants/constant.dart';

class SignupdetailsView extends GetView<SignupController> {
  const SignupdetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<SignupController>(
          init: controller,
          builder: (_) {
            return Form(
              key: _.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(children: [
                      Center(
                        child: Container(
                          height: 450,
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: 370,
                          child: Column(
                            children: [],
                          ),
                        ).marginOnly(top: 220, right: 15, left: 15),
                      ),
                      Column(children: [
                        Image.asset(
                          'assets/Framelogosmall.png',
                          scale: 0.80,
                        ).marginOnly(top: 140, left: 10),
                        const CustomText(
                          text: 'Lets get you to the beach!',
                          color: AppColors.darkGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ).marginOnly(top: 20, left: 20),
                        commonTextField(
                          context: context,
                          width: 300,
                          icon: Icons.email_outlined,
                          hintText: 'abc342@gmail.com',
                          controller: _.emailController,
                          validator: validateEmail,
                        ).marginOnly(top: 30),
                        commonTextField(
                          width: 300,
                          icon: Icons.phone_android_rounded,
                          hintText: '+1 (310) 555-1212',
                          context: context,
                          controller: _.mobileNumberController,
                          validator: validateMobileNumber,
                        ).marginOnly(top: 30),
                        commonTextField(
                          width: 300,
                          icon: Icons.lock_outline_rounded,
                          hintText: '**********',
                          isPassword: true,
                          context: context,
                          controller: _.passwordController,
                          validator: validatePassword,
                        ).marginOnly(top: 30),
                        const CustomText(
                          text: 'Send verification code',
                          color: AppColors.grey,
                        ).marginOnly(top: 10, right: 170),
                        Row(children: [
                          Row(
                            children: [
                              CommonButton(
                                textColor: Colors.white,
                                Width: 20,
                                height: 20,
                                primary: Colors.white,
                                action: () {},
                                bordercolors: AppColors.blue,
                                borderradius: 100,
                              ).marginOnly(right: 10),
                              CustomText(text: 'Email').marginOnly(right: 20),
                              CommonButton(
                                textColor: Colors.white,
                                Width: 20,
                                height: 20,
                                primary: Colors.white,
                                action: () {},
                                bordercolors: AppColors.blue,
                                borderradius: 100,
                              ).marginOnly(right: 10),
                              CustomText(text: 'Phone Number')
                            ],
                          ),
                        ]).marginOnly(left: 30, bottom: 20),
                        Obx(() => CommonButton(
                              borderradius: 90,
                              primary: _.isFieldsFilled.value
                                  ? AppColors.blue
                                  : AppColors.grey,
                              Width: 90,
                              borderside: 10,
                              height: 90,
                              bordercolors: Colors.white,
                              textColor: Colors.white,
                              iconData: Icons.arrow_forward,
                              action: () {
                                if (_.formKey.currentState!.validate()) {
                                  controller.createAccount(
                                    controller.emailController.text,
                                    controller.passwordController.text,
                                  );
                                } else {
                                  Get.snackbar("Error", "Please fill all fields correctly");
                                }
                              },
                            ).marginOnly(top: 20, left: 10)),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              AgreeTermsCheckbox(),
                            ],
                          ),
                        ),
                        AuthOptionsWidget(
                          colors: AppColors.darkGrey,
                          colors2: AppColors.blue,
                          continueText: 'Or continue with',
                          accountQuestionText: 'Already have an account? ',
                          loginText: 'Login',
                          onApplePressed: () {},
                          onGooglePressed: () {                              Get.find<OnboardingController>().pressed();
},
                          onLoginPressed: () {},
                        ).marginOnly(bottom: 20)
                      ])
                    ]),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class AgreeTermsCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    return Obx(() => Row(
          children: <Widget>[
            Checkbox(
              value: controller.isChecked.value,
              onChanged: (bool? value) {
                controller.toggleCheckbox();
              },
              activeColor: Colors.blue,
            ),
            const Expanded(
              child: Text(
                'By continuing, I confirm that I am 18+ and agree to Sand Caddie\'s Terms of Service.',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ));
  }
}

String? validateName(String? name) {
  if (name == null || name.isEmpty || name.length < 6 || name.contains(' ')) {
    return 'Name must be at least 6 characters long and without spaces';
  }
  return null;
}

String? validateEmail(String? email) {
  RegExp emailREgex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
  final isEmailValid = emailREgex.hasMatch(email ?? '');
  if (!isEmailValid) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validateMobileNumber(String? number) {
  RegExp mobileRegex = RegExp(r'^\+?1?\d{9,15}$');
  if (number == null || number.isEmpty || !mobileRegex.hasMatch(number)) {
    return 'Please enter a valid mobile number';
  }
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty || password.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}

String? validateConfirmPassword(String? confirmPassword, String? password) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return 'Confirm password is required';
  } else if (confirmPassword != password) {
    return 'Passwords do not match';
  }
  return null; 
}

String? validateDOB(String? dob) {
  if (dob == null || dob.isEmpty) {
    return 'Date of birth is required';
  }

  DateTime? date;
  try {
    date = DateTime.parse(dob);
  } catch (e) {
    return 'Invalid date format. Use YYYY-MM-DD';
  }

  if (date == null) {
    return 'Invalid date';
  }

  DateTime today = DateTime.now();
  DateTime eighteenYearsAgo = DateTime(today.year - 18, today.month, today.day);

  if (date.isAfter(eighteenYearsAgo)) {
    return 'You must be at least 18 years old';
  }

  return null; // If the date is valid and the user is old enough
}
