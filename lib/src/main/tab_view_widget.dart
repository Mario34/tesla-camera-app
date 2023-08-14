/// createTime: 2023/8/9 on 17:45
/// desc:
///
/// @author azhon
import 'dart:io';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:tesla_camera/generated/assets/tesla_camera_assets.dart';
import 'package:tesla_camera/src/bloc/tab/tab_bloc.dart';
import 'package:tesla_camera/src/entity/structure_entity.dart';
import 'package:tesla_camera/src/entity/video_entity.dart';
import 'package:tesla_camera/src/util/file_util.dart';
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
      title: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(item.date),
          ),
          Expanded(
            child: _dangerWidget(item.event),
          ),
        ],
      ),
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
            child: Row(
              children: [
                ThumbnailWidget(entity: e),
                const SizedBox(width: 10),
                Text(
                  TimeUtil.HHmmss(e.time.millisecondsSinceEpoch),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: e.selected ? Colors.blue : const Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 20),
                _dangerWidget(e.event),
              ],
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

  Widget _dangerWidget(bool danger) {
    return Visibility(
      visible: danger,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ],
      ),
    );
  }
}

class ThumbnailWidget extends StatefulWidget {
  final VideoEntity entity;

  const ThumbnailWidget({
    Key? key,
    required this.entity,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ThumbnailWidgetState();
}

class _ThumbnailWidgetState extends State<ThumbnailWidget> {
  final plugin = FcNativeVideoThumbnail();
  String? thumbnailPath;

  @override
  void initState() {
    super.initState();
    FileUtil.cacheDir().then((path) async {
      thumbnailPath =
          '$path${Platform.pathSeparator}${FileUtil.getNameByPath(widget.entity.front!)}';
      await plugin.getVideoThumbnail(
        srcFile: widget.entity.front!,
        destFile: thumbnailPath!,
        width: 200,
        height: 200,
        keepAspectRatio: true,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (thumbnailPath == null) {
      return Transform.scale(
        scale: 0.7,
        child: const CircularProgressIndicator(),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(thumbnailPath!),
        width: 60,
        height: 45,
        fit: BoxFit.fill,
      ),
    );
  }
}
