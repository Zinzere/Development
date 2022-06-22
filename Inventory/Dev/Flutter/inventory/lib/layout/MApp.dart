import 'package:flutter/material.dart';

final _snackKey = GlobalKey<ScaffoldMessengerState>();

class MApp extends StatefulWidget {
  MApp({@required this.child,this.appBar, this.title});
  final Widget child;
  final PreferredSizeWidget appBar;
  final String title;

  @override
  State<MApp> createState() => _MAppState();
}

class _MAppState extends State<MApp> {
  Color shadowColor;
  double elevation;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _snackKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: widget.appBar,
        body: widget.child,
      ),
    );
  }
}

class Snack {
  static Function call(Widget snack) {
    _snackKey.currentState.showSnackBar(snack);
  }
}

SnackBar TxtMsg(txt,{@required color}) {
  return SnackBar(
      duration: const Duration(seconds: 2, milliseconds: 500),
      backgroundColor: color ?? Colors.black,
      content: Text(txt,),
      );
}

SnackBar TxtBtnMsg(txt, btnName, {@required onClick, color }) {
  return SnackBar(
    duration: const Duration(seconds: 2, milliseconds: 500),
    backgroundColor: color ?? Colors.red,
    content: Text(txt, style: TextStyle(color: Colors.white),),
    action: SnackBarAction(
      label: btnName,
      textColor: Colors.white,
      onPressed: onClick,
    ),
  );
}