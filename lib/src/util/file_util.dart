import 'dart:convert';
import 'dart:io';

import 'package:tesla_camera/src/entity/structure_entity.dart';
import 'package:tesla_camera/src/entity/video_entity.dart';
import 'package:tesla_camera/src/util/constants.dart';
import 'package:tesla_camera/src/util/video_direction.dart';
import 'package:tesla_camera/src/util/video_type.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/todo_flutter.dart';

/// createTime: 2023/7/4 on 15:41
/// desc:
///
/// @author azhon
class FileUtil {
  ///获取所有文件
  static Future<List<StructureEntity>> getAllFiles(String root) async {
    List<VideoEntity> all = [];
    all.addAll(await _getFiles(root, VideoType.events));
    all.addAll(await _getFiles(root, VideoType.sentinel));
    all.addAll(await _getFiles(root, VideoType.record));

    ///按天合并
    Map<String, StructureEntity> daysMap = {};
    for (var v in all) {
      String key = TimeUtil.formatTime(
        v.time.millisecondsSinceEpoch,
        format: 'yyyy年MM月dd日',
      );
      daysMap[key] = daysMap[key] ?? StructureEntity(type: v.type, date: key);
      daysMap[key]!.list.add(v);
    }
    final list = daysMap.values.toList();

    ///排序
    list.sort((a, b) => b.date.compareTo(a.date));
    for (var value in list) {
      value.list.sort((a, b) => b.time.millisecondsSinceEpoch
          .compareTo(a.time.millisecondsSinceEpoch));
    }
    return list;
  }

  ///获取目录下不同类型的文件
  ///[type]类型 查看[Constants]
  static Future<List<VideoEntity>> _getFiles(
      String path, VideoType type) async {
    List<VideoEntity> results = [];
    final root = Directory('$path${Platform.pathSeparator}${type.name}');
    if (!await root.exists()) {
      return results;
    }
    Map<String, VideoEntity> videos = {};
    getAllVideos(type, videos, root);
    return videos.values.toList();
  }

  ///递归遍历所有视频
  static void getAllVideos(
    VideoType type,
    Map<String, VideoEntity> videos,
    Directory root,
  ) {
    List<FileSystemEntity> files = root.listSync();
    DateTime? eventTime;
    for (var f in files) {
      if (f is Directory) {
        getAllVideos(type, videos, f);
      } else {
        String fileName = getNameByPath(f.path);

        ///过滤隐藏文件
        if (fileName.startsWith('.')) {
          continue;
        }
        if (fileName.contains(Constants.thumb)) {
          continue;
        }
        if (fileName.contains(Constants.eventJson)) {
          ///事件发生的时间
          final json = File(f.path).readAsStringSync();
          eventTime = DateTime.parse(jsonDecode(json)['timestamp']);
          continue;
        }

        String date = fileName.substring(0, fileName.lastIndexOf('-'));
        String direction = fileName.substring(fileName.lastIndexOf('-'));

        DateTime time = DateFormat('yyyy-MM-dd_HH-mm-ss').parse(date);
        videos[date] = videos[date] ?? VideoEntity(type: type, time: time);

        VideoEntity curr = videos[date]!;

        if (direction.contains(VideoDirection.front.direction)) {
          curr.front = f.path;
        } else if (direction.contains(VideoDirection.back.direction)) {
          curr.back = f.path;
        } else if (direction.contains(VideoDirection.left.direction)) {
          curr.left = f.path;
        } else if (direction.contains(VideoDirection.right.direction)) {
          curr.right = f.path;
        }

        ///判断是不是发生事件了
        // if (eventTime != null) {
        //   if (eventTime.isAtSameMomentAs(curr.time) ||
        //       eventTime.isAfter(curr.time)) {
        //     curr.event = true;
        //   }
        // }
      }
    }
  }

  static String getNameByPath(String path) {
    return path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);
  }
}
