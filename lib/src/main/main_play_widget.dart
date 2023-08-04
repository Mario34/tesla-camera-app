/// createTime: 2023/7/4 on 14:05
/// desc:
///
/// @author azhon
import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:process_run/process_run.dart';
import 'package:tesla_camera/generated/assets/tesla_camera_assets.dart';
import 'package:tesla_camera/src/bloc/video/video_bloc.dart';
import 'package:tesla_camera/src/entity/video_entity.dart';
import 'package:tesla_camera/src/ffmpeg/base_ffmpeg.dart';
import 'package:tesla_camera/src/util/file_util.dart';
import 'package:tesla_camera/src/util/video_direction.dart';
import 'package:todo_flutter/todo_flutter.dart';

class MainPlayWidget extends StatefulWidget {
  final VideoBloc videoBloc;
  final ValueChanged<List<VideoEntity>>? selectCallBack;

  const MainPlayWidget({
    Key? key,
    required this.videoBloc,
    this.selectCallBack,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPlayWidgetState();
}

class _MainPlayWidgetState extends State<MainPlayWidget> {
  StreamSubscription? _subscription;
  StreamSubscription? _statusSubscription;
  StreamSubscription? _totalDurationSubscription;
  StreamSubscription? _progressDurationSubscription;

  final DataChangeBloc<Duration> _totalDurationBloc =
      DataChangeBloc(Duration.zero);
  final DataChangeBloc<Duration> _durationBloc = DataChangeBloc(Duration.zero);
  final DataChangeBloc<bool> _statusBloc = DataChangeBloc(true);
  VideoEntity? _currentVideo;

  ///5个播放控制器
  late VideoController _frontController,
      _backController,
      _leftController,
      _rightController;

  ///当前视角
  VideoDirection _direction = VideoDirection.front;

  @override
  void initState() {
    super.initState();
    _frontController = _createController();
    _backController = _createController();
    _leftController = _createController();
    _rightController = _createController();
    _listenerVideoChange();
  }

  ///创建播放器
  VideoController _createController() {
    return VideoController(Player()..setPlaylistMode(PlaylistMode.loop));
  }

  ///监听视频切换
  void _listenerVideoChange() {
    _subscription = widget.videoBloc.stream.listen((event) async {
      _currentVideo = event.entity!;
      _setDataSource(_frontController, _currentVideo!.front);
      _setDataSource(_backController, _currentVideo!.back);
      _setDataSource(_leftController, _currentVideo!.left);
      _setDataSource(_rightController, _currentVideo!.right);
      setState(() {});
      _listenerProgress(_frontController);
    });
  }

  ///监听播放进度
  void _listenerProgress(VideoController controller) {
    _durationBloc.changeData(Duration.zero);

    _statusSubscription?.cancel();
    _totalDurationSubscription?.cancel();
    _progressDurationSubscription?.cancel();

    _totalDurationSubscription =
        controller.player.stream.duration.listen((event) {
      _totalDurationBloc.changeData(event);
    });
    _progressDurationSubscription =
        controller.player.stream.position.listen((event) {
      _durationBloc.changeData(event);
    });
  }

  ///设置视频数据
  Future<void> _setDataSource(VideoController controller, String? path) {
    return controller.player.open(Media(path!));
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: [
          _topBarWidget(),
          Expanded(
            child: hasVideo
                ? AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => _togglePlay(),
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Video(
                              controller: _getMainController(),
                              controls: null,
                            ),
                          ),
                        ),
                        _createPlayer(
                          _frontController,
                          top: 12,
                          left: 12,
                          direction: VideoDirection.front,
                        ),
                        _createPlayer(
                          _backController,
                          top: 12,
                          right: 12,
                          direction: VideoDirection.back,
                        ),
                        _createPlayer(
                          _leftController,
                          left: 12,
                          bottom: 12,
                          direction: VideoDirection.left,
                        ),
                        _createPlayer(
                          _rightController,
                          right: 12,
                          bottom: 12,
                          direction: VideoDirection.right,
                        ),
                        _timestampWidget(),
                        _pauseWidget(),
                      ],
                    ),
                  )
                : _emptyWidget(),
          ),
          _controlsWidget(),
        ],
      ),
    );
  }

  void _togglePlay({bool pause = false}) async {
    if (pause) {
      await _frontController.player.pause();
      await _backController.player.pause();
      await _leftController.player.pause();
      await _rightController.player.pause();
      _statusBloc.changeData(false);
      return;
    }
    _statusBloc.changeData(!_getMainController().player.state.playing);
    await _frontController.player.playOrPause();
    await _backController.player.playOrPause();
    await _leftController.player.playOrPause();
    await _rightController.player.playOrPause();
  }

  Widget _topBarWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFCCCCCC)),
            ),
            child: IconButton(
              icon: Image.asset(
                TeslaCameraAssets.dir,
                fit: BoxFit.fitWidth,
                width: 128,
                height: 128,
              ),
              tooltip: '选择车载U盘中的TeslaCam目录，\n或者是TeslaCam文件目录的拷贝',
              onPressed: () => _selectDir(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFCCCCCC)),
            ),
            child: IconButton(
              icon: Image.asset(
                TeslaCameraAssets.export,
                fit: BoxFit.fitWidth,
                width: 128,
                height: 128,
              ),
              tooltip: '选择保存位置并添\n加时间水印并导出',
              onPressed: () => _exportVideo(_getMainVideoPath()),
            ),
          ),
        ],
      ),
    );
  }

  ///是否选择了视频播放
  bool get hasVideo => _currentVideo != null;

  ///获取当前主视图显示的视角
  VideoController _getMainController() {
    switch (_direction) {
      case VideoDirection.front:
        return _frontController;
      case VideoDirection.back:
        return _backController;
      case VideoDirection.left:
        return _leftController;
      case VideoDirection.right:
        return _rightController;
    }
  }

  ///获取当前主视图的文件地址
  String? _getMainVideoPath() {
    switch (_direction) {
      case VideoDirection.front:
        return _currentVideo?.front;
      case VideoDirection.back:
        return _currentVideo?.back;
      case VideoDirection.left:
        return _currentVideo?.left;
      case VideoDirection.right:
        return _currentVideo?.right;
    }
  }

  ///创建播放视图
  Widget _createPlayer(
    VideoController controller, {
    required VideoDirection direction,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _direction = direction;
          });
        },
        child: SizedBox(
          width: 140,
          height: 105,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: _smallVideo(direction, controller),
          ),
        ),
      ),
    );
  }

  ///创建四个小窗播放视图
  Widget _smallVideo(VideoDirection direction, VideoController controller) {
    return Stack(
      children: [
        _getMainController() == controller
            ? BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black12.withOpacity(0.1),
                  ),
                ),
              )
            : AspectRatio(
                aspectRatio: 4 / 3,
                child: Video(
                  controller: controller,
                  controls: null,
                ),
              ),
        Positioned(
          bottom: 6,
          left: 6,
          child: Text(
            direction.name,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  ///进度控制
  Widget _controlsWidget() {
    if (!hasVideo) {
      return const SizedBox();
    }
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 16, left: 40, right: 40),
      alignment: Alignment.topCenter,
      child: DataChangeWidget<Duration>(
        bloc: _totalDurationBloc,
        child: (_, total) {
          return DataChangeWidget<Duration>(
            bloc: _durationBloc,
            child: (_, progress) {
              return ProgressBar(
                progress: progress ?? Duration.zero,
                total: total ?? Duration.zero,
                onSeek: (duration) => _changeProgress(duration),
              );
            },
          );
        },
      ),
    );
  }

  ///改变进度
  void _changeProgress(Duration duration) {
    _frontController.player.seek(duration);
    _backController.player.seek(duration);
    _leftController.player.seek(duration);
    _rightController.player.seek(duration);
  }

  Widget _timestampWidget() {
    final start = _currentVideo?.event?.timestamp?.millisecondsSinceEpoch ?? 0;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: DataChangeWidget<Duration>(
          bloc: _durationBloc,
          child: (_, state) {
            final date = TimeUtil.formatTime(start + state!.inMilliseconds,
                format: 'yyyy年MM月dd日 HH:mm:ss');
            return Text(
              date,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _pauseWidget() {
    return DataChangeWidget<bool>(
      bloc: _statusBloc,
      child: (_, state) {
        return state!
            ? const SizedBox()
            : const Center(
                child: Icon(
                  Icons.play_circle_outlined,
                  color: Colors.white,
                  size: 60,
                ),
              );
      },
    );
  }

  ///空状态视图
  Widget _emptyWidget() {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Text(
        '点击上方文件夹图标以导入视频',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  ///选择目录
  void _selectDir() async {
    String? rootPath = await getDirectoryPath();
    if (ObjectUtil.isEmpty(rootPath)) {
      return;
    }

    ///恢复
    setState(() {
      _currentVideo = null;
    });
    final list = await FileUtil.getAllFiles(rootPath!);
    widget.selectCallBack?.call(list);
  }

  ///带水印导出视频
  void _exportVideo(String? input) async {
    if (ObjectUtil.isEmpty(input)) {
      return;
    }
    String fileName = FileUtil.getNameByPath(input!);

    ///选择保存位置
    String? savePath = await getDirectoryPath();
    if (ObjectUtil.isEmpty(savePath)) {
      return;
    }
    File output = File('$savePath/$fileName');

    ///ffmpeg 文件位置
    final ffmpeg = Ffmpeg.instance.ffmpeg;

    const offset = Offset(420, 30);
    int fontSize = 30;
    String fontColor = 'white';

    ///视频开始时间
    int startTime =
        (_currentVideo!.event?.timestamp?.millisecondsSinceEpoch ?? 0) ~/ 1000;
    final List<String> command = [
      ffmpeg.ffmpeg(),
      '-y',
      '-i',
      input,
      '-vf',
      '"drawtext=fontfile=${await ffmpeg.ttf()}:fontsize=$fontSize:fontcolor=$fontColor:x=${offset.dx}:y=${offset.dy}:text=\'%{pts\\:localtime\\:$startTime\\:%Y年%m月%d日 %H时%M分%S秒}\'"',
      output.path,
    ];
    _togglePlay(pause: true);
    _showLoadingDialog();
    final shell = Shell(workingDirectory: await ffmpeg.path());
    debugPrint('----start---\n${command.join(' ')}\n----end---');
    shell.run(command.join(' ')).then((value) {
      Navigator.of(context).pop();
      _showDoneDialog(output.path, true);
    }).catchError((error) {
      Navigator.of(context).pop();
      _showDoneDialog(error.toString(), false);
    });
  }

  ///导出中对话框
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (_) {
        return UnconstrainedBox(
          child: Container(
            width: 150,
            height: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 20),
                Text(
                  '导出中，请稍后...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///完成对话框
  void _showDoneDialog(String msg, bool success) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("导出${success ? '成功' : '失败'}"),
          content: Text(success ? '文件位于：$msg' : msg),
          actions: [
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
    _statusSubscription?.cancel();
    _totalDurationSubscription?.cancel();
    _progressDurationSubscription?.cancel();
    _frontController.player.dispose();
    _backController.player.dispose();
    _leftController.player.dispose();
    _rightController.player.dispose();
    _totalDurationBloc.close();
    _durationBloc.close();
    _statusBloc.close();
  }
}
