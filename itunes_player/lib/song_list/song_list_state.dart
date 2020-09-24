part of 'song_list_bloc.dart';

abstract class SongListState extends Equatable {
  const SongListState();

  @override
  List<Object> get props => [];
}

class SongListInitialState extends SongListState {}

class FetchInProgress extends SongListState {}

class FetchSongFailure extends SongListState {
  final String error;

  const FetchSongFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FetchSongFailure { error: $error }';
}

class SongFetchedListState extends SongListState {
  final List<SongModel> songList;

  const SongFetchedListState({@required this.songList});

  @override
  String toString() => 'SongFetchedListState';
}