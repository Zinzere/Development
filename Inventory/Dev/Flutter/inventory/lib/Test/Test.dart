import 'package:flutter/material.dart';
import '../ui/Button.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> with WidgetsBindingObserver {

  onClick(){
    final NavigatorState navigator = Navigator.of(context);
    final RenderBox itemBox = context.findRenderObject() as RenderBox;
    final Rect itemRect = itemBox.localToGlobal(Offset.zero, ancestor: navigator.context.findRenderObject()) & itemBox.size;
    print(itemBox.localToGlobal(Offset.zero, ancestor: navigator.context.findRenderObject()));
    print(itemRect);
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      "Submit",
      onPressed: () {
        print("Hello");
        onClick();
      },
    );
  }
}
