import 'dart:io';
import 'package:get/get.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class TrimmerController extends GetxController {
  final Trimmer trimmer = Trimmer();
  final Rx<File?> videoFile = Rx<File?>(null);
  final Rx<String?> videoUrl = Rx<String?>(null);
  final RxDouble startValue = 0.0.obs;
  final RxDouble endValue = 0.0.obs;
  final RxBool isPlaying = false.obs;
  final RxBool progressVisibility = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is String) {
      videoUrl.value = Get.arguments;
      _downloadVideo(videoUrl.value!).then((file) {
        videoFile.value = file;
        _loadVideo();
      });
    } else if (Get.arguments is File) {
      videoFile.value = Get.arguments;
      _loadVideo();
    }
  }

  Future<void> _loadVideo() async {
    if (videoFile.value != null) {
      await trimmer.loadVideo(videoFile: videoFile.value!);
      update();
    }
  }

  Future<File> _downloadVideo(String url) async {
    final response = await http.get(Uri.parse(url));
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/video.mp4');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  void saveVideo() async {
    progressVisibility.value = true;
    await trimmer.saveTrimmedVideo(
      startValue: startValue.value,
      endValue: endValue.value,
      onSave: (outputPath) {
        progressVisibility.value = false;
        Get.toNamed('/preview', arguments: outputPath);
      },
    );
  }

  void videoPlaybackControl() async {
    final playbackState = await trimmer.videoPlaybackControl(
      startValue: startValue.value,
      endValue: endValue.value,
    );
    isPlaying.value = playbackState;
  }
}
