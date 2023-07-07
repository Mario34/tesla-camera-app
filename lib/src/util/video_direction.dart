/// createTime: 2023/7/5 on 09:42
/// desc:
///
/// @author azhon
enum VideoDirection {
  ///四个视角
  front('front', '前'),
  back('back', '后'),
  left('left', '左'),
  right('right', '右'),
  ;

  final String direction;
  final String name;

  const VideoDirection(this.direction, this.name);
}
