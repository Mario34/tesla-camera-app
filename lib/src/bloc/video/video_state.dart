part of 'video_bloc.dart';

abstract class VideoState {
  final VideoEntity? entity;

  VideoState(this.entity);
}

class VideoInitialState extends VideoState {
  VideoInitialState(super.entity);
}
