part of 'video_bloc.dart';

abstract class VideoEvent extends BaseEvent<VideoBloc, VideoState> {
  VideoEvent();
}

class UpdateVideoEvent extends VideoEvent {
  final VideoEntity entity;

  UpdateVideoEvent(this.entity);

  @override
  Future<VideoState> on(VideoBloc bloc, VideoState currentState) async {
    return VideoInitialState(entity);
  }
}
