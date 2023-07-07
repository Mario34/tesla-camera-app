import 'package:tesla_camera/src/entity/video_entity.dart';
import 'package:tesla_camera/src/util/video_type.dart';
import 'package:todo_flutter/todo_flutter.dart';

part 'tab_event.dart';

part 'tab_state.dart';

class TabBloc extends BaseBloc<TabEvent, TabState> {
  final DataChangeBloc<List<VideoEntity>?> listBloc = DataChangeBloc(null);

  TabBloc() : super(TabInitialState(null));

  void updateList(List<VideoEntity> list) {
    add(UpdateListEvent(list));
    listBloc.changeData(list);
  }

  void updateByTab(int index) {
    VideoType? type = VideoTypeEx.byIndex(index);
    if (type == null) {
      listBloc.changeData(state.list);
      return;
    }

    final list = state.list?.where((element) {
      element.selected = false;
      return element.type == type;
    }).toList();
    listBloc.changeData(list);
  }
}
