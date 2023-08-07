/// createTime: 2023/7/4 on 14:05
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:tesla_camera/src/bloc/tab/tab_bloc.dart';
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
            child: DataChangeWidget<List<VideoEntity>?>(
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
                      final item = state![index];
                      return _buildItem(state, item);
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

  Widget _buildItem(List<VideoEntity> list, VideoEntity item) {
    return GestureDetector(
      onTap: () {
        for (var element in list) {
          element.selected = false;
        }
        item.selected = !item.selected;
        widget.tabBloc.listBloc.changeData([...list]);
        widget.itemCallback?.call(item);
      },
      child: Container(
        margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            item.selected
                ? const Icon(
                    Icons.radio_button_checked,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey,
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                TimeUtil.formatTime(item.time.millisecondsSinceEpoch,
                    format: 'yyyy年MM月dd日 HH:mm:ss'),
                style: TextStyle(
                  fontSize: 16,
                  color: item.selected ? Colors.blue : const Color(0xFF333333),
                ),
              ),
            ),
            const Spacer(),
            Visibility(
              visible: item.event,
              child: Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
