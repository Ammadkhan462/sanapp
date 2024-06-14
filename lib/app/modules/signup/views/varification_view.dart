import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandapp/app/modules/signup/controllers/signup_controller.dart';
import 'package:sandapp/common/common_button.dart';
import 'package:sandapp/common/common_text.dart';
import 'package:sandapp/constants/constant.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

    return Scaffold(
      body: GetBuilder<SignupController>(
        init: controller,
        builder: (_) {
          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 450,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CustomText(
                          text: 'Enter verification code',
                          color: AppColors.darkGrey,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ).marginOnly(top: 80),
                        const SizedBox(height: 10),
                        CustomText(
                          text: 'Sent to ${_.emailController.text}',
                          color: AppColors.grey,
                          fontSize: 16,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return CustomDigitTextField(
                              controller: _.codeControllers[index],
                              focusNode: focusNodes[index],
                              nextFocusNode:
                                  index < 3 ? focusNodes[index + 1] : null,
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () =>
                              _.sendVerificationCode(_.emailController.text),
                          child: const Text('Resend code',
                              style: TextStyle(color: AppColors.blue)),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            CommonButton(
                              text: 'Cancel',
                              action: () => Navigator.pop(context),
                              primary: Colors.white,
                              textColor: Colors.grey,
                              borderradius: 30,
                              Width: 120,
                            ).marginOnly(right: 30),
                            Obx(() => CommonButton(
                                  text: 'Continue',
                                  action: _.isButtonActive.value
                                      ? () {
                                          final inputCode = _.codeControllers
                                              .map((c) => c.text)
                                              .join();
                                          _.verifyCode(inputCode);
                                        }
                                      : null,
                                  primary: _.isButtonActive.value
                                      ? AppColors.blue
                                      : Colors.grey,
                                  textColor: _.isButtonActive.value
                                      ? Colors.white
                                      : Colors.grey,
                                  borderradius: 30,
                                  Width: 120,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Image.asset(
                'assets/Framelogosmall.png',
                scale: 0.80,
              ).marginOnly(
                left: 115,
                top: 130,
              ),
            ],
          );
        },
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double width;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final bool isPassword;
  final String? Function(String?)? validator;

  CustomTextField({
    required this.controller,
    required this.hintText,
    this.width = 325,
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        textAlign: textAlign,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          // This is where we update the state when the text changes
          if (controller.hasListeners) {
            controller.notifyListeners();
          }
        },
      ),
    );
  }
}


class CustomDigitTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;

  CustomDigitTextField({
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          if (value.length == 1) {
            nextFocusNode?.requestFocus();
          }
        },
      ),
    );
  }
}
