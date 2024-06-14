import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandapp/app/routes/app_pages.dart';
import 'package:video_player/video_player.dart';
import 'package:sandapp/constants/constant.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController controller = Get.find<HomeController>();
  int _selectedIndex = 0;

  void _showBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: const SizedBox.shrink(),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                    onPressed: () {
                      if (controller.videoFiles.isNotEmpty) {
                        File videoFile = File(controller.videoFiles[0].path);
                        Get.toNamed(Routes.CROP, arguments: videoFile);
                      } else {
                        Get.snackbar("Error", "No video selected");
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: Obx(() {
                  if (controller.videoThumbnails.isEmpty) {
                    return const Center(child: Text('No video thumbnails'));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.videoThumbnails.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                controller.videoThumbnails[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.blue),
                              onPressed: () => controller.removeVideo(index),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickVideoAndShowSheet() async {
    await controller.pickVideo();
    _showBottomSheet();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation to different pages based on the index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.videoUrls.isEmpty) {
                return const Center(child: Text('No videos selected'));
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: controller.videoUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      String videoUrl = controller.videoUrls[index];
                      Get.toNamed(Routes.CROP, arguments: videoUrl);
                    },
                    child: VideoPlayerWidget(
                      videoUrl: controller.videoUrls[index],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                color: AppColors.blue,
                icon: const Icon(Icons.video_library),
                onPressed: () => _onItemTapped(1),
              ),
              const SizedBox(width: 40.0), // The dummy child for spacing
              IconButton(
                icon: const Icon(Icons.brush),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue,
        onPressed: _pickVideoAndShowSheet,
        tooltip: 'Pick Video',
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
