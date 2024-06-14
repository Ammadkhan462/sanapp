  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:sandapp/app/modules/crop/controllers/crop_controller.dart';
  import 'package:sandapp/common/common_button.dart';
  import 'package:sandapp/constants/constant.dart';
  import 'package:video_trimmer/video_trimmer.dart';

  class TrimmerView extends StatelessWidget {
    const TrimmerView({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.blue,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: GetBuilder<TrimmerController>(
          init: TrimmerController(),
          builder: (controller) {
            if (controller.videoFile.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: VideoViewer(trimmer: controller.trimmer),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/Rectangle.png')
                            .marginOnly(right: 10), // Sample image
                        Image.asset('assets/Rectangle.png'), // Sample image
                        const SizedBox(width: 5.0),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  IconButton(
                    icon: Icon(
                      controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                      size: 50.0,
                      color: AppColors.blue,
                    ),
                    onPressed: () async {
                      controller.videoPlaybackControl();
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    flex: 1,
                    child: TrimViewer(
                      trimmer: controller.trimmer,
                      viewerHeight: 50.0,
                      viewerWidth: MediaQuery.of(context).size.width,
                      durationStyle: DurationStyle.FORMAT_MM_SS,
                      maxVideoLength: Duration(
                        seconds: controller.trimmer.videoPlayerController?.value
                                .duration.inSeconds ??
                            0,
                      ),
                      editorProperties: const TrimEditorProperties(
                        borderPaintColor: AppColors.blue,
                        borderWidth: 4,
                        borderRadius: 5,
                        circlePaintColor: AppColors.blue,
                      ),
                      areaProperties:
                          TrimAreaProperties.edgeBlur(thumbnailQuality: 10),
                      onChangeStart: (value) =>
                          controller.startValue.value = value,
                      onChangeEnd: (value) => controller.endValue.value = value,
                      onChangePlaybackState: (value) =>
                          controller.isPlaying.value = value,
                    ),
                  ),
                  CommonButton(
                    text: 'Next',
                    action: controller.saveVideo,
                    textColor: AppColors.blue,
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
