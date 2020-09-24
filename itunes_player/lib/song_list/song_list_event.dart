part of 'song_list_bloc.dart';

abstract class SongListEvent extends Equatable {
  const SongListEvent();
}

class SongListInitialEvent extends SongListEvent {
  @override
  String toString() => 'SongListInitialEvent';

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FetchSongList extends SongListEvent {
  @override
  String toString() => 'FetchSongList';

  final String searchString;

  const FetchSongList({
    @required this.searchString,
  });

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

