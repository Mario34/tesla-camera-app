/// createTime: 2023/7/4 on 14:05
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:tesla_camera/generated/assets/tesla_camera_assets.dart';
import 'package:tesla_camera/src/bloc/tab/tab_bloc.dart';
import 'package:tesla_camera/src/entity/structure_entity.dart';
import 'package:tesla_camera/src/entity/video_entity.dart';
import 'package:todo_flutter/todo_flutter.dart';

class MainTabWidget extends StatefulWidget {
  final TabBloc tabBloc;
  final ValueChanged<VideoEntity>? itemCallback;

  const MainTabWidget({
    Key? key,
    required this.tabBloc,
    this.itemCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainTabWidgetState();
}

class _MainTabWidgetState extends State<MainTabWidget>
    with TickerProviderStateMixin {
  final List<String> _tabs = ['所有', '事件', '哨兵', '记录仪'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFf0f0f0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.black,
              unselectedLabelColor: const Color(0xFF666666),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              indicator: UnderlineTabIndicator(
                borderSide: const BorderSide(
                  width: 3,
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              tabs: _tabs
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList(),
              onTap: (index) {
                widget.tabBloc.updateByTab(index);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Divider(
              height: 0.5,
              color: Color(0x4D666666),
            ),
          ),
          Expanded(
            child: DataChangeWidget<List<StructureEntity>?>(
              bloc: widget.tabBloc.listBloc,
              child: (_, state) {
                if (ObjectUtil.isEmpty(state)) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(
                      '暂无数据',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: state?.length ?? 0,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (_, index) {
                      return _buildItem(state!, index);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
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
}
