part of 'tab_bloc.dart';

abstract class TabState {
  final List<VideoEntity>? list;

  TabState(this.list);

  List<VideoEntity>? listByType(VideoType? type) {
    if (type == null) {
      return list;
    }
    return list?.where((element) => element.type == type).toList();
  }
}

class TabInitialState extends TabState {
  TabInitialState(super.list);
}
