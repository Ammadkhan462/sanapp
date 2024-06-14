import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ClipeditingController extends GetxController {
  late VideoPlayerController videoPlayerController;
  var isInitialized = false.obs;
  late String videoPath;
  var isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    videoPath = Get.arguments as String;
    if (Uri.parse(videoPath).isAbsolute) {
      videoPlayerController = VideoPlayerController.network(videoPath);
    } else {
      videoPlayerController = VideoPlayerController.file(File(videoPath));
    }
    videoPlayerController.initialize().then((_) {
      isInitialized.value = true;
      videoPlayerController.play();
    });
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }

  void exportAndNavigate() {
    Get.toNamed('/preview', arguments: videoPath);
  }

  Future<void> uploadVideoToFirebase() async {
    isUploading.value = true;
    try {
      File videoFile = File(videoPath);
      String fileName = 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(videoFile);

      await uploadTask;

      isUploading.value = false;
      Get.snackbar("Success", "Video uploaded successfully.");
    } catch (e) {
      isUploading.value = false;
      Get.snackbar("Error", "Failed to upload video: $e");
    }
  }
}
