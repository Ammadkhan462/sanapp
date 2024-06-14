import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandapp/app/routes/app_pages.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final codeControllers = List.generate(4, (_) => TextEditingController());

  RxBool isChecked = false.obs;
  RxBool isFieldsFilled = false.obs;
  RxBool isLoading = false.obs;
  RxBool isButtonActive = false.obs;

  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationCode = "";

  @override
  void onInit() {
    super.onInit();
    _addListeners();
  }

  void _addListeners() {
    firstNameController.addListener(_updateButtonState);
    lastNameController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    mobileNumberController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    dateOfBirthController.addListener(_updateButtonState);

    for (var controller in codeControllers) {
      controller.addListener(_updateVerificationButtonState);
    }
  }

  void _updateButtonState() {
    isFieldsFilled.value = _areFieldsFilled();
  }

  bool _areFieldsFilled() {
    return formKey.currentState?.validate() ?? false;
  }

  void _updateVerificationButtonState() {
    isButtonActive.value = _areCodeFieldsFilled();
  }

  bool _areCodeFieldsFilled() {
    return codeControllers.every((controller) => controller.text.isNotEmpty);
  }

  void toggleCheckbox() {
    isChecked.value = !isChecked.value;
  }

  Future<void> createAccount(String email, String password) async {
    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email");
      return;
    }
    isLoading(true);
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await sendVerificationCode(email);
        Get.snackbar("Success", "Verification email has been sent");
        Get.toNamed(Routes.VarificationView);
      } else {
        Get.snackbar("Error", "User creation failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendVerificationCode(String email) async {
    verificationCode = generateVerificationCode();
    // Here you would send the code via email using your preferred email service
    print("Verification code sent to $email: $verificationCode");
  }

  String generateVerificationCode() {
    var rng = Random();
    return rng
        .nextInt(9000)
        .toString()
        .padLeft(4, '0'); // Generates a 4-digit code
  }

  void verifyCode(String inputCode) {
    if (inputCode == verificationCode) {
      Get.snackbar("Success", "Verification successful");
      Get.toNamed(Routes.HOME); // Navigate to the home screen or desired route
    } else {
      Get.snackbar("Error", "Invalid verification code");
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    dateOfBirthController.dispose();
    codeControllers.forEach((controller) => controller.dispose());
    super.onClose();
  }
}
