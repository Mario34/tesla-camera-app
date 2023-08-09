/// createTime: 2023/7/4 on 14:05
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:tesla_camera/generated/assets/tesla_camera_assets.dart';
import 'package:tesla_camera/src/bloc/tab/tab_bloc.dart';
import 'package:tesla_camera/src/entity/structure_entity.dart';
import 'package:tesla_camera/src/entity/video_entity.dart';
import 'package:tesla_camera/src/main/tab_view_widget.dart';
import 'package:tesla_camera/src/util/video_type.dart';
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
  @override
  void initState() {
    super.initState();
    widget.tabBloc.tabController =
        TabController(length: widget.tabBloc.tabs.length, vsync: this);
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
              controller: widget.tabBloc.tabController,
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
              tabs: widget.tabBloc.tabs
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList(),
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
                return TabBarView(
                  key: widget.tabBloc.key,
                  controller: widget.tabBloc.tabController,
                  children: VideoType.values.map((e) {
                    return TabViewWidget(
                      list: widget.tabBloc.getListByType(e),
                      tabBloc: widget.tabBloc,
                      itemCallback: widget.itemCallback,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
