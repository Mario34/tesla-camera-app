import 'dart:convert';
import 'dart:io';

import 'package:tesla_camera/src/entity/video_entity.dart';
import 'package:tesla_camera/src/util/constants.dart';
import 'package:tesla_camera/src/util/video_direction.dart';
import 'package:tesla_camera/src/util/video_type.dart';

/// createTime: 2023/7/4 on 15:41
/// desc:
///
/// @author azhon
class FileUtil {
  ///获取所有文件
  static Future<List<VideoEntity>> getAllFiles(String root) async {
    List<VideoEntity> all = [];
    all.addAll(await _getFiles(root, VideoType.events));
    all.addAll(await _getFiles(root, VideoType.sentinel));
    all.addAll(await _getFiles(root, VideoType.record));
    return all;
  }

  ///获取目录下不同类型的文件
  ///[type]类型 查看[Constants]
  static Future<List<VideoEntity>> _getFiles(
      String path, VideoType type) async {
    List<VideoEntity> results = [];
    final root = Directory('$path/${type.name}');
    if (!await root.exists()) {
      return results;
    }
    List<FileSystemEntity> files = root.listSync();
    for (var f in files) {
      final entity = VideoEntity(
        type: type,
        name: FileUtil.getNameByPath(f.path),
      );
      results.add(entity);
      List<FileSystemEntity> videos = (f as Directory).listSync();
      for (var v in videos) {
        if (v.path.contains(VideoDirection.front.direction)) {
          entity.front = v.path;
        } else if (v.path.contains(VideoDirection.back.direction)) {
          entity.back = v.path;
        } else if (v.path.contains(VideoDirection.left.direction)) {
          entity.left = v.path;
        } else if (v.path.contains(VideoDirection.right.direction)) {
          entity.right = v.path;
        } else if (v.path.contains(Constants.thumb)) {
          entity.thumb = v.path;
        } else if (v.path.contains(Constants.eventJson)) {
          final json = await File(v.path).readAsString();
          entity.event = Event.fromJson(jsonDecode(json));
        }
      }
    }
    return results;
  }

  static String getNameByPath(String path) {
    return path.substring(path.lastIndexOf('/') + 1);
  }
}
