import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tesla_camera/src/ffmpeg/macos_ffmpeg.dart';
import 'package:tesla_camera/src/ffmpeg/windows_ffmpeg.dart';

/// createTime: 2023/7/7 on 10:54
/// desc:
///
/// @author azhon
abstract class BaseFfmpeg {
  final String ttfName = 'time.ttf';

  BaseFfmpeg() {
    createFfmpeg();
    createTtf();
  }

  ///创建ffmpeg
  Future<void> createFfmpeg();

  String ffmpeg();

  ///返回字体路径
  Future<String> ttf() async {
    return File('${await path()}${Platform.pathSeparator}$ttfName').path;
  }

  ///拷贝字体文件
  Future<void> createTtf() async {
    final dir = await path();
    final file = File('$dir${Platform.pathSeparator}$ttfName');

    await writeFile(file, 'assets/$ttfName');
    debugPrint('copy $ttfName success: $dir');
  }

  Future<String> path() async {
    final dir = await getApplicationSupportDirectory();
    return dir.path;
  }

  Future<void> writeFile(File file, String assets) async {
    final byteData = await rootBundle.load(assets);
    await file.writeAsBytes(
      byteData.buffer.asUint8List(),
      mode: FileMode.append,
    );
  }
}

class Ffmpeg {
  factory Ffmpeg() => _getInstance();

  static Ffmpeg get instance => _getInstance();
  static Ffmpeg? _instance;
  late BaseFfmpeg ffmpeg;

  static Ffmpeg _getInstance() {
    _instance ??= Ffmpeg._internal();
    return _instance!;
  }

  Ffmpeg._internal() {
    if (Platform.isMacOS) {
      ffmpeg = MacosFfmpeg();
    } else if (Platform.isWindows) {
      ffmpeg = WindowsFfmpeg();
    }
  }
}
