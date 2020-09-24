import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'song_list_bloc.dart';
import 'song_list_form.dart';


class SongListPage extends StatelessWidget {

  SongListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) {
          return SongListBloc(SongListInitialState());
        },
        child: SongListForm(),
      ),
    );
  }
}
