import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';

class HomeController extends GetxController {
  var videoThumbnails = <Uint8List>[].obs;
  var videoFiles = <XFile>[].obs;

  Future<void> pickVideo() async {
    var permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
      try {
        final XFile? selectedVideo =
            await ImagePicker().pickVideo(source: ImageSource.gallery);

        if (selectedVideo != null) {
          videoFiles.add(selectedVideo);

          final Uint8List? thumbnail = await VideoThumbnail.thumbnailData(
            video: selectedVideo.path,
            imageFormat: ImageFormat.JPEG,
            maxHeight: 100,
            quality: 75,
          );

          if (thumbnail != null) {
            videoThumbnails.add(thumbnail);
          }
        } else {
          Get.snackbar("Error", "No video selected");
        }
      } catch (e) {
        print(e);
        Get.snackbar("Error", "Failed to pick video: $e");
      }
    } else {
      Get.snackbar("Permission Error",
          "You need to grant storage access to pick videos.");
    }
  }

  void removeVideo(int index) {
    videoFiles.removeAt(index);
    videoThumbnails.removeAt(index);
  }

  @override
  void onInit() {
    super.onInit();
    videoFiles.clear();
    videoThumbnails.clear();
    fetchVideoUrls();
  }

  RxList<String> videoUrls = <String>[].obs;

  Future<void> fetchVideoUrls() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    ListResult result = await storage.ref('videos').listAll();

    for (Reference ref in result.items) {
      String downloadUrl = await ref.getDownloadURL();
      videoUrls.add(downloadUrl);
    }
  }
}
