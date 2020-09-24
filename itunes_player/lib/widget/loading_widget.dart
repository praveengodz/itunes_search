import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void showLoadingWidget(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Material(
          type: MaterialType.transparency,
          child: WillPopScope(
            onWillPop: () async {
              Future.value(
                  false); //return a `Future` with false value so this route cant be popped or closed.
            },
            child: new Dialog(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  new Container(
                    padding: EdgeInsets.all(15),
                    child: SizedBox(
                      height: 45,
                      width: 45,
                      child: SpinKitFoldingCube(
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                  new Text("Loading"),
                ],
              ),
            ),
          )));
}
