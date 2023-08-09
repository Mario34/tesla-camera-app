/// createTime: 2023/8/9 on 17:45
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:tesla_camera/generated/assets/tesla_camera_assets.dart';
import 'package:tesla_camera/src/bloc/tab/tab_bloc.dart';
import 'package:tesla_camera/src/entity/structure_entity.dart';
import 'package:tesla_camera/src/entity/video_entity.dart';
import 'package:todo_flutter/todo_flutter.dart';

class TabViewWidget extends StatefulWidget {
  final TabBloc tabBloc;
  final List<StructureEntity>? list;
  final ValueChanged<VideoEntity>? itemCallback;

  const TabViewWidget({
    required this.tabBloc,
    Key? key,
    this.list,
    this.itemCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabViewWidgetState();
}

class _TabViewWidgetState extends State<TabViewWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (ObjectUtil.isEmpty(widget.list)) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            '暂无数据',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: widget.list!.length,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (_, index) {
          return _buildItem(widget.list!, index);
        },
      );
    }
  }

  Widget _buildItem(List<StructureEntity> list, int index) {
    final item = list[index];
    return ExpansionTile(
      leading: Image.asset(TeslaCameraAssets.finder, width: 24),
      title: Text(item.date),
      textColor: Colors.blue,
      collapsedTextColor: const Color(0xFF333333),
      collapsedBackgroundColor: Colors.white,
      collapsedShape: const Border(
        bottom: BorderSide(color: Color(0x4D666666)),
      ),
      children: item.list.map((e) {
        return ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -4),
          minVerticalPadding: 0,
          title: Container(
            margin: const EdgeInsets.only(left: 60),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              TimeUtil.formatTime(e.time.millisecondsSinceEpoch),
              style: TextStyle(
                fontSize: 16,
                color: e.selected ? Colors.blue : const Color(0xFF333333),
              ),
            ),
          ),
          onTap: () {
            for (var e1 in list) {
              for (var e2 in e1.list) {
                e2.selected = false;
              }
            }
            e.selected = !e.selected;
            widget.tabBloc.listBloc.changeData([...list]);
            widget.itemCallback?.call(e);
          },
        );
      }).toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
