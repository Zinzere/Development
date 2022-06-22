import 'package:flutter/material.dart';
import '../ui/AllUi.dart';

Future Popup({@required ctx,child, title, refresh}){
  return showDialog(context: ctx, builder: (BuildContext context) {
    return Alert(child, title);
  });
}

class Alert extends StatefulWidget {
  Alert(this.child, this.title);
  final Widget child;
  final String title;
  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert>{
  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Center(child:Text(widget.title ?? "")),
      content: widget.child
    );
  }
}




