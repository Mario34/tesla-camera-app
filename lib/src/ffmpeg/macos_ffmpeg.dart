import 'dart:io';

import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';
import 'package:tesla_camera/src/ffmpeg/base_ffmpeg.dart';

/// createTime: 2023/7/7 on 10:59
/// desc:
///
/// @author azhon
class MacosFfmpeg extends BaseFfmpeg {
  final String ffmpegName = 'ffmpegMac';

  @override
  String ffmpeg() {
    return './$ffmpegName';
  }

  @override
  Future<String> ttf() async {
    return File('${await path()}/$ttfName').path;
  }

  @override
  Future<void> createFfmpeg() async {
    final dir = await path();
    final file = File('$dir/$ffmpegName');
    if (file.existsSync()) {
      debugPrint('$ffmpegName is already exists.');
      return;
    }
    await writeFile(file, 'assets/$ffmpegName');

    debugPrint('copy $ffmpegName success: $dir');
    final shell = Shell(workingDirectory: dir);

    ///设置权限
    await shell.run('chmod 777 $ffmpegName');

    ///清除权限结尾的'@'
    await shell.run('xattr -c $ffmpegName');
  }

  @override
  Future<void> createTtf() async {
    final dir = await path();
    final file = File('$dir/$ttfName');
    if (file.existsSync()) {
      debugPrint('$ttfName is already exists.');
      return;
    }
    await writeFile(file, 'assets/$ttfName');
    debugPrint('copy $ttfName success: $dir');
  }
}
