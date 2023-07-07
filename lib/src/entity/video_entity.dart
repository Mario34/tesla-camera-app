import 'package:tesla_camera/src/util/video_type.dart';

/// createTime: 2023/7/4 on 15:26
/// desc:
///
/// @author azhon
class VideoEntity {
  ///类型[Constants]
  final VideoType type;

  ///文件名称
  String? name;

  ///前视
  String? front;

  ///后视
  String? back;

  ///左视
  String? left;

  ///右视
  String? right;

  ///缩略图
  String? thumb;

  ///数据
  Event? event;

  bool selected;

  VideoEntity({
    required this.type,
    this.name,
    this.front,
    this.back,
    this.left,
    this.right,
    this.thumb,
    this.event,
    this.selected = false,
  });
}

class Event {
  DateTime? timestamp;
  String? city;
  String? estLat;
  String? estLon;
  String? reason;
  String? camera;

  Event({
    this.timestamp,
    this.city,
    this.estLat,
    this.estLon,
    this.reason,
    this.camera,
  });

  Event.fromJson(Map<String, dynamic> map) {
    timestamp = DateTime.parse(map['timestamp'] ?? '');
    city = map['city'];
    estLat = map['est_lat'];
    estLon = map['est_lon'];
    reason = map['reason'];
    camera = map['camera'];
  }
}
