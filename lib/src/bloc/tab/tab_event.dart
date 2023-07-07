part of 'tab_bloc.dart';

abstract class TabEvent extends BaseEvent<TabBloc, TabState> {
  TabEvent();
}

class UpdateListEvent extends TabEvent {
  final List<VideoEntity> list;

  UpdateListEvent(this.list);

  @override
  Future<TabState> on(TabBloc bloc, TabState currentState) async {
    return TabInitialState(list);
  }
}
