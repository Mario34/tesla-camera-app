import 'package:tesla_camera/src/entity/structure_entity.dart';
import 'package:tesla_camera/src/util/video_type.dart';
import 'package:todo_flutter/todo_flutter.dart';

part 'tab_event.dart';

part 'tab_state.dart';

class TabBloc extends BaseBloc<TabEvent, TabState> {
  final DataChangeBloc<List<StructureEntity>?> listBloc = DataChangeBloc(null);

  TabBloc() : super(TabInitialState(null));

  void updateList(List<StructureEntity> list) {
    add(UpdateListEvent(list));
    listBloc.changeData(list);
  }

  void updateByTab(int index) {
    VideoType? type = VideoTypeEx.byIndex(index);
    listBloc.changeData(state.listByType(type));
  }
}
