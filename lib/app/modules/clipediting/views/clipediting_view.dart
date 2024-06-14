import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandapp/constants/constant.dart';
import 'package:video_player/video_player.dart';
import '../controllers/clipediting_controller.dart';


class Preview extends StatefulWidget {
  final String outputVideoPath;

  const Preview({Key? key, required this.outputVideoPath}) : super(key: key);

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  late VideoPlayerController _controller;
  double _currentSliderValue = 0.0;
  bool _isUploading = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    final String videoPath = Get.arguments as String;

    if (Uri.parse(videoPath).isAbsolute) {
      _controller = VideoPlayerController.network(videoPath);
    } else {
      _controller = VideoPlayerController.file(File(videoPath));
    }

    _controller.initialize().then((_) {
      setState(() {
        _isError = false;
      });
      _controller.play();
    }).catchError((error) {
      setState(() {
        _isError = true;
      });
    });

    _controller.addListener(() {
      if (_controller.value.isInitialized) {
        setState(() {
          _currentSliderValue = _controller.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _uploadVideoToFirebase() async {
    setState(() {
      _isUploading = true;
    });

    try {
      File videoFile = File(Get.arguments as String);
      String fileName = 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(videoFile);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video uploaded successfully: $downloadUrl')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload video: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clipeditingController = Get.put(ClipeditingController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.blue,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Obx(() {
            if (Get.find<ClipeditingController>().isUploading.value) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
                ),
              );
            } else {
              return IconButton(
                icon: const Icon(
                  Icons.check,
                  color: AppColors.blue,
                ),
                onPressed:
                    Get.find<ClipeditingController>().uploadVideoToFirebase,
              );
            }
          }),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_isError)
            const Center(
                child: Text('Error loading video',
                    style: TextStyle(color: Colors.red)))
          else if (_controller.value.isInitialized)
            Container(
              width: double.infinity,
              height: 400,
              child: VideoPlayer(_controller),
            )
          else
            const CircularProgressIndicator(),
          const SizedBox(height: 16.0),
          if (_controller.value.isInitialized)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                    Expanded(
                      child: Slider(
                        activeColor: AppColors.blue,
                        value: _currentSliderValue,
                        min: 0.0,
                        max: _controller.value.duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            _currentSliderValue = value;
                            _controller
                                .seekTo(Duration(seconds: value.toInt()));
                          });
                        },
                      ),
                    ),
                    Text(
                      _formatDuration(_controller.value.duration),
                      style: const TextStyle(color: AppColors.grey),
                    ),
                    const Icon(
                      Icons.fullscreen,
                      color: AppColors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
              ],
            )
          else
            Container(),
          const Expanded(child: HomeViews()),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class Listofdemo {
  String naem;
  List<String>? listofname;
  List<String>? videoPaths;
  List<VideoPlayerController> videoControllers = [];

  Listofdemo({
    required this.naem,
    this.listofname,
    this.videoPaths,
  });

  factory Listofdemo.fromMap(Map<String, dynamic> map) {
    return Listofdemo(
      naem: map['naem'] ?? 'Default Name',
      listofname: List<String>.from(map['listofname'] ?? []),
      videoPaths: List<String>.from(map['videoPaths'] ?? []),
    );
  }
}

class Demo {
  String name;
  List<Listofdemo> listofdemo;

  Demo({required this.name, required this.listofdemo});

  factory Demo.fromMap(Map<String, dynamic> map) {
    return Demo(
      name: map['name'],
      listofdemo: List<Listofdemo>.from(
          map['listofdemo'].map((x) => Listofdemo.fromMap(x))),
    );
  }
}

class HomeControllers extends GetxController {
  var expandedIndex = Rxn<int>();
  var selectedIndex = Rxn<int>();
  var selectedIndextwo = Rxn<int>();
  RxList<Demo> data = RxList<Demo>();

  @override
  void onInit() {
    super.onInit();
    loadLocalData();
  }

  void loadLocalData() {
    List<Demo> demos = [
      Demo(
        name: 'Category 1',
        listofdemo: [
          Listofdemo(
            naem: 'Item 1-1',
            listofname: ['Subitem 1', 'Subitem 2'],
            videoPaths: ['assets/blue_leopard.mp4', 'assets/flame.mp4'],
          ),
          Listofdemo(
            naem: 'Item 1-2',
            listofname: ['Subitem 3', 'Subitem 4'],
            videoPaths: ['assets/ice_ball_0.mp4', 'assets/ice_ball_0.mp4'],
          ),
        ],
      ),
      Demo(
        name: 'Category 2',
        listofdemo: [
          Listofdemo(
            naem: 'dsdsd',
            videoPaths: [],
          ),
          Listofdemo(
            naem: 'Item 2-1',
            listofname: ['Subitem 5', 'Subitem 6'],
            videoPaths: ['assets/flame_lion_0.mp4', 'assets/flame_lion_0.mp4'],
          ),
          Listofdemo(
            naem: 'Item 2-2',
            listofname: ['Subitem 7', 'Subitem 8'],
            videoPaths: ['assets/ice_ball_0.mp4', 'assets/ice_ball_0.mp4'],
          ),
        ],
      ),
    ];
    data.assignAll(demos);
    print("Data loaded: ${data.length} categories");
    for (var demo in data) {
      print("Category: ${demo.name}");
      for (var item in demo.listofdemo) {
        print("Item: ${item.naem}, Videos: ${item.videoPaths}");
      }
    }
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? null : index;
    update();
  }

  void toggleExpandtwo(int index) {
    selectedIndextwo.value = selectedIndextwo.value == index ? null : index;
    update();
  }
}

class HomeViews extends GetView<HomeControllers> {
  const HomeViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllers>(
      init: HomeControllers(),
      builder: (_) {
        return Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _.data.length,
                itemBuilder: (context, index) {
                  var category = _.data[index];
                  bool isSelected = _.selectedIndex.value == index;
                  return InkWell(
                    onTap: () {
                      _.toggleExpand(index);
                      _.selectedIndex.value = index;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade100 : null,
                        border: isSelected
                            ? const Border(
                                bottom:
                                    BorderSide(color: Colors.blue, width: 3))
                            : null,
                      ),
                      child: Text(
                        category.name,
                        style: TextStyle(
                          color: isSelected ? AppColors.blue : Colors.black,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_.expandedIndex.value != null)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1 / 1.2,
                  ),
                  itemCount: _.data[_.expandedIndex.value!].listofdemo.length,
                  itemBuilder: (context, index2) {
                    var item =
                        _.data[_.expandedIndex.value!].listofdemo[index2];
                    if (item.videoPaths == null || item.videoPaths!.isEmpty) {
                      print('No video available for: ${item.naem}');
                      return const Center(child: Text('No video available'));
                    }
                    return FutureBuilder(
                      future: _initializeVideoPlayer(item.videoPaths),
                      builder: (context,
                          AsyncSnapshot<VideoPlayerController> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          print('Video player initialized for: ${item.naem}');
                          return GestureDetector(
                            onTap: () {
                              snapshot.data!.play();
                            },
                            child: AspectRatio(
                              aspectRatio: snapshot.data!.value.aspectRatio,
                              child: VideoPlayer(snapshot.data!),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          print(
                              'Error loading video for ${item.naem}: ${snapshot.error}');
                          return Center(
                              child: Text(
                                  'Error loading video: ${snapshot.error}'));
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Future<VideoPlayerController> _initializeVideoPlayer(
      List<String>? paths) async {
    if (paths == null || paths.isEmpty) {
      print('Video path is empty or null');
      throw Exception('Video path is empty or null');
    }
    print('Initializing video player with path: ${paths.first}');
    VideoPlayerController controller =
        VideoPlayerController.file(File(paths.first));
    await controller.initialize();
    await controller.setLooping(true);
    return controller;
  }
}
