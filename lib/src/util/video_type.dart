/// createTime: 2023/7/4 on 16:16
/// desc:
///
/// @author azhon
enum VideoType {
  ///事件
  events('SavedClips'),

  ///哨兵
  sentinel('Sentinel'),

  ///记录仪
  record('Record'),
  ;

  final String name;

  const VideoType(this.name);
}

extension VideoTypeEx on VideoType {
  static VideoType? byIndex(int index) {
    switch (index) {
      case 1:
        return VideoType.events;
      case 2:
        return VideoType.sentinel;
      case 3:
        return VideoType.record;
      default:
        return null;
    }
  }
}
