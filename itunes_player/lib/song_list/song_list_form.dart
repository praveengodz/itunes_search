import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itunes_player/model/song_model.dart';
import 'package:itunes_player/widget/loading_widget.dart';
import 'song_list_bloc.dart';

class SongListForm extends StatefulWidget {
  @override
  State<SongListForm> createState() => _SongListFormState();
}

class _SongListFormState extends State<SongListForm> {
  TextEditingController searchTextController = TextEditingController();
  List<SongModel> songList = [];
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool _play = false;

  @override
  void initState() {
    super.initState();
    assetsAudioPlayer.isPlaying.listen((isPlaying){
      setState(() {
        _play = isPlaying;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SongListBloc, SongListState>(
      listener: (context, state) {
        if (state is FetchInProgress) {
          showLoadingWidget(context);
        }
        if (state is SongFetchedListState) {
          Navigator.pop(context);
          songList = state.songList;
        }
        if (state is FetchSongFailure) {
          Navigator.pop(context);
          _showDialog(state.error);
          songList = [];
        }
      },
      child: BlocBuilder<SongListBloc, SongListState>(
        builder: (context, state) {
          return MaterialApp(
            home: Scaffold(
              resizeToAvoidBottomPadding: false,
              body: Column(
                children: <Widget>[
                  searchWidget(),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 150,
                    child: listViewWidget(),
                  ),
                  if(songList.length > 0)
                  playerWidget()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 10.0, right: 10.0, bottom: 10.0),
      child: Center(
        child: TextFormField(
            controller: searchTextController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (v) {
              performSearchAction(v);
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.blue, size: 20),
              hintText: "Search",
            )),
      ),
    );
  }

  Widget playerWidget() {
    return Container(
        height: 50.0,
        child: Center(
          child: RaisedButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              onPressed: () {
               assetsAudioPlayer.playOrPause();
              },
              textColor: Colors.white,
              padding: EdgeInsets.all(0.0),
              child: Container(
                alignment: Alignment.center,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.blue,
                ),
                padding: const EdgeInsets.all(12.0),
                child: _play == true
                    ? Icon(Icons.pause, color: Colors.white, size: 20)
                    : Icon(Icons.play_arrow, color: Colors.white, size: 20),
              )),
        ));
  }

  Widget listViewWidget() {
    return Container(
      child: ListView.builder(
        itemCount: songList.length, // items.length,
        itemBuilder: (context, index) {
          final item = songList[index];
          return listItemCell(item, index);
        },
      ),
    );
  }

  Widget listItemCell(SongModel item, int index) {
    return Container(
      height: 110,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              listItemTapped(item, index);
            },
            trailing: Container(
              width: 20.0,
              child: item.isPLaying == true
                  ? Icon(
                      Icons.play_arrow,
                      size: 20,
                    )
                  : null,
            ),
            leading: Container(
              width: 50.0,
              height: 50.0,
              child: CachedNetworkImage(
                imageUrl: item.artworkUrl100,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            title: Text(
              item.trackName,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),
            ),
            subtitle: Text(
              item.artistName + "\n" + item.collectionName,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Divider()
        ],
      ),
    );
  }

  void performSearchAction(String searchString) {
    BlocProvider.of<SongListBloc>(context)
        .add(FetchSongList(searchString: searchString));
  }

  Future<void> listItemTapped(SongModel item, int index) async {
    try {
      await assetsAudioPlayer.open(Audio.network(item.previewUrl));
    } catch (t) {
      _showDialog(t.toString());
    }
    setState(() {
      songList.forEach((element) {
        if (item == element) {
          element.isPLaying = true;
        } else {
          element.isPLaying = false;
        }
      });
    });
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
