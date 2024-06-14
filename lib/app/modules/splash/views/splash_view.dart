import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sandapp/common/common_text.dart';
import 'package:sandapp/constants/constant.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(children: [
            Image.asset('assets/Rectangle.png'),
            Center(
              child: Image.asset('assets/Framelogosmall.png').marginOnly(
                top: 450,
              ),
            ),
          ]).marginOnly(bottom: 30),
          const CustomText(
            text: 'SAND CADDIE',
            fontSize: 32,
            color: AppColors.blue,
            fontWeight: FontWeight.bold,
          ),
          const CustomText(
            text: 'Parking Lot to Sandy Spot',
            fontSize: 14,
            color: AppColors.darkGrey,
          ),
        ],
      ),
    );
  }
}
