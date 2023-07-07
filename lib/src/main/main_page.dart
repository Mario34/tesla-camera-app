/// createTime: 2023/7/4 on 13:55
/// desc:
///
/// @author azhon
import 'package:flutter/material.dart';
import 'package:tesla_camera/src/bloc/tab/tab_bloc.dart';
import 'package:tesla_camera/src/bloc/video/video_bloc.dart';
import 'package:tesla_camera/src/main/main_play_widget.dart';
import 'package:tesla_camera/src/main/main_tab_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TabBloc _tabBloc = TabBloc();
  final VideoBloc _videoBloc = VideoBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: MainTabWidget(
              tabBloc: _tabBloc,
              itemCallback: (item) {
                _videoBloc.showVideo(item);
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: MainPlayWidget(
              videoBloc: _videoBloc,
              selectCallBack: (list) {
                _tabBloc.updateList(list);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabBloc.close();
    _videoBloc.close();
  }
}
