import 'package:flutter/material.dart';
import 'package:flutter_meedu_videoplayer/init_meedu_player.dart';
import 'package:tesla_camera/src/ffmpeg/base_ffmpeg.dart';
import 'package:tesla_camera/src/main/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initMeeduPlayer();
  runApp(
    const MaterialApp(
      title: 'Tesla Camera',
      home: MainPage(),
    ),
  );
  Ffmpeg.instance;
}
