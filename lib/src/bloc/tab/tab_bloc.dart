import 'package:flutter/material.dart';
import 'package:tesla_camera/src/entity/structure_entity.dart';
import 'package:tesla_camera/src/util/video_type.dart';
import 'package:todo_flutter/todo_flutter.dart';

part 'tab_event.dart';

part 'tab_state.dart';

class TabBloc extends BaseBloc<TabEvent, TabState> {
  final List<String> tabs = ['所有', '事件', '哨兵', '记录仪'];
  late TabController tabController;
  GlobalKey key = GlobalKey();
  final DataChangeBloc<List<StructureEntity>?> listBloc = DataChangeBloc(null);

  TabBloc() : super(TabInitialState(null));

  void updateList(List<StructureEntity> list) {
    add(UpdateListEvent(list));

    ///重置
    key = GlobalKey();
    tabController.index = 0;
    listBloc.changeData(list);
  }

  List<StructureEntity>? getListByType(VideoType type) {
    if (type == VideoType.all) {
      return listBloc.state;
    }
    return listBloc.state?.where((element) => element.type == type).toList();
  }
}
