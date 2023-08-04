import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:tesla_camera/src/ffmpeg/base_ffmpeg.dart';
import 'package:tesla_camera/src/main/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(
    const MaterialApp(
      title: 'Tesla Camera',
      home: MainPage(),
    ),
  );
  Ffmpeg.instance;
}
