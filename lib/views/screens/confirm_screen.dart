import 'package:flutter/material.dart';
import 'package:flutter_tiktok/controller/upload_video_controller.dart';
import 'package:flutter_tiktok/views/widgets/text_input_field.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmScreen(
      {super.key, required this.videoFile, required this.videoPath});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();

  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize(); //firstly try to preview a video file
    controller.play(); // as we know from its name it helps for playing a video
    controller.setVolume(1); //it is voice volume
    controller.setLooping(
        true); //as we know from its name it helps for looping:playing a video again
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(controller),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                        controller: _songController,
                        labelText: 'Song Name',
                        icon: Icons.music_note),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                        controller: _captionController,
                        labelText: 'Caption',
                        icon: Icons.closed_caption),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () => uploadVideoController.uploadVideo(
                          _songController.text,
                          _captionController.text,
                          widget.videoPath),
                      child: const Text(
                        'Share',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
