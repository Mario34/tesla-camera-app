import 'package:tesla_camera/src/entity/video_entity.dart';
import 'package:tesla_camera/src/util/video_type.dart';

/// createTime: 2023/8/9 on 15:58
/// desc:
///
/// @author azhon
class StructureEntity {
  final VideoType type;
  final String date;
  final List<VideoEntity> list = [];

  StructureEntity({
    required this.type,
    required this.date,
  });

  bool get event => list.where((element) => element.event).isNotEmpty;
}
