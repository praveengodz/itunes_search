import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:itunes_player/model/song_model.dart';
import 'package:itunes_player/utilities/app_strings.dart';
import 'package:itunes_player/web_service/api_provider.dart';
import 'package:itunes_player/web_service/network.dart';

part 'song_list_event.dart';
part 'song_list_state.dart';

class SongListBloc extends Bloc<SongListEvent, SongListState> {
  SongListBloc(SongListState initialState) : super(initialState);

  NetworkCheck mNetworkCheck = new NetworkCheck();
  ApiProvider apiProvider = ApiProvider();

  @override
  Stream<SongListState> mapEventToState(SongListEvent event) async* {
    if (event is SongListInitialEvent) {
      yield SongListInitialState();
    }

    if (event is FetchSongList) {
      yield FetchInProgress();
      try {
        bool aNetwork = await mNetworkCheck.check();
        if (aNetwork) {
          List<SongModel> aData = await apiProvider.fetchSongList(event.searchString);
          if (aData.length > 0) {
            yield SongFetchedListState(songList: aData);
          } else {
            yield FetchSongFailure(error: AppStrings.msg_something_went_wrong);
          }
        } else {
          yield FetchSongFailure(error: AppStrings.msg_no_internet_connection);
        }
      } catch (error) {
        yield FetchSongFailure(error: error.toString());
      }
    }
  }
}
