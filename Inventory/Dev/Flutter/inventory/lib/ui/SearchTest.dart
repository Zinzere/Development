import 'package:flutter/material.dart';

class SearchTest extends StatefulWidget {
  SearchTest({@required this.onSelect});
  final Function(dynamic) onSelect;

  @override
  State<SearchTest> createState() => _SearchTestState();
}

class _SearchTestState extends State<SearchTest> {
  Size screenSize;
  NavigatorState navigator;
  RenderBox itemBox;
  Rect itemRect;
  TextEditingController txtFieldContoller = TextEditingController();

  getPosition(){
    navigator = Navigator.of(context);
    itemBox = context.findRenderObject() as RenderBox;
    itemRect = itemBox.localToGlobal(Offset.zero, ancestor: navigator.context.findRenderObject()) & itemBox.size;
    print(itemBox.localToGlobal(Offset.zero, ancestor: navigator.context.findRenderObject()));
    print(itemRect);
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Container(
      width: 200,
      height: 100,
      child: Stack(
        children: [
          TextField(
              controller: txtFieldContoller,
              onTap:() {
                getPosition();
              }
          ),
          Positioned(
              top: 50,
              left: 200,
              child: Container(
                height: 500,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text("Data 1"),
                    Text("Data 2"),
                    Text("Data 3"),
                    Text("Data 4"),
                    Text("Data 5"),
                    Text("Data 6"),
                    Text("Data 7"),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}
