import 'package:get/get.dart';

import '../controllers/clipediting_controller.dart';

class ClipeditingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClipeditingController>(
      () => ClipeditingController(),
    );
  }
}
