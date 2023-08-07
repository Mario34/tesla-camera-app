import 'package:tesla_camera/src/util/video_type.dart';

/// createTime: 2023/7/4 on 15:26
/// desc:
///
/// @author azhon
class VideoEntity {
  ///类型[Constants]
  final VideoType type;

  ///时间
  DateTime time;

  ///前视
  String? front;

  ///后视
  String? back;

  ///左视
  String? left;

  ///右视
  String? right;

  bool selected;

  VideoEntity({
    required this.type,
    required this.time,
    this.front,
    this.back,
    this.left,
    this.right,
    this.selected = false,
  });
}
