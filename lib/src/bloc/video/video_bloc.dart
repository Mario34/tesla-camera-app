import 'package:tesla_camera/src/entity/video_entity.dart';
import 'package:todo_flutter/todo_flutter.dart';

part 'video_event.dart';

part 'video_state.dart';

class VideoBloc extends BaseBloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoInitialState(null));

  void showVideo(VideoEntity entity) {
    add(UpdateVideoEvent(entity));
  }
}
