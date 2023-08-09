/// createTime: 2023/7/4 on 16:16
/// desc:
///
/// @author azhon
enum VideoType {
  ///所有
  all('all'),

  ///事件
  events('SavedClips'),

  ///哨兵
  sentinel('SentryClips'),

  ///记录仪
  record('RecentClips'),
  ;

  final String name;

  const VideoType(this.name);
}
