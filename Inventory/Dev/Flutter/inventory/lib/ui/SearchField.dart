/*
SearchField(
  showKeyList: ["NAME","-","TYPE"],
  futureOrList: (val) async {
    var data = await Calls.search({"name":val});
      if(data["res"]){
      return data["data"];
      } else {
      return [];
      }
    },
  width: 200,
  onSelected:(val) {
    print(val);
  }),
*/
import 'dart:async';
import 'package:flutter/material.dart';

//TextEditingController searchController = TextEditingController();
typedef FutureOr<dynamic> futureListCallBack(String pattern);

class SearchField extends StatefulWidget {
  SearchField({@required this.onSelected,this.controller, this.showKeyList, this.futureOrList, this.width = 400, this.label = "Search Here"});

  final Function(dynamic) onSelected; //If selected returns
  final futureListCallBack futureOrList; //Future or List
  final double width; //Width if want to adjust
  final String label; //Label of Search text Field
  final List<String> showKeyList; //List of Key's value will be shown in Search List
  final TextEditingController controller;
  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Size screenSize;
  NavigatorState navigator;
  RenderBox itemBox;
  Rect itemRect;
  bool positionCheck = false; //fasle position values not generated | true generated
  getPosition() {
    navigator = Navigator.of(context);
    itemBox = context.findRenderObject() as RenderBox;
    itemRect = itemBox.localToGlobal(Offset.zero, ancestor: navigator.context.findRenderObject()) & itemBox.size;
    positionCheck = true;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return IntrinsicWidth(
      stepWidth: widget.width,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 2.0, right: 2),
            labelText: widget.label,
            labelStyle: TextStyle(
                color: Colors.purple, fontStyle: FontStyle.italic, fontSize: 18)
        ),
        onTap: () {
          if (!positionCheck) {
            getPosition();
          }
          Navigator.push(context,
              PopupWidget(
                  controllers: widget.controller,
                  buttonRect: itemRect,
                  futureOrList: widget.futureOrList,
                  showKeyList: widget.showKeyList,
                  onSelected: widget.onSelected,
                  label: widget.label,
                  width: widget.width,
                  screenSize: screenSize
              ));
        },
        onChanged: (val) {
          Navigator.push(context,
              PopupWidget(
                  controllers: widget.controller,
                  buttonRect: itemRect,
                  futureOrList: widget.futureOrList,
                  showKeyList: widget.showKeyList,
                  onSelected: widget.onSelected,
                  label: widget.label,
                  width: widget.width,
                  screenSize: screenSize
              ));
        },
      ),
    );
  }
}

class PopupWidget extends PopupRoute {
  PopupWidget({this.buttonRect,this.controllers, this.screenSize, this.futureOrList, this.onSelected, this.width, this.label, this.showKeyList});

  final TextEditingController controllers;
  final Rect buttonRect;
  final futureListCallBack futureOrList;
  final Function(dynamic) onSelected;
  final double width;
  String label;
  final List<String> showKeyList;
  final Size screenSize;
  List<dynamic> searchResult = [];

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => "";

  @override
  Duration get transitionDuration => Duration(milliseconds: 100);

  _dismiss() {
    navigator.removeRoute(this);
  }
  bool upOrDown = false; //false down | true means up

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,Animation<double> secondaryAnimation) {
    bool upOrDown = _upDownCheck(buttonRect.top,screenSize.height);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                Widget items(kv) {
                  String displayText = "";
                  if (this.showKeyList != null) {
                    for (var i = 0; i < this.showKeyList.length; i++) {
                      String displayKey = this.showKeyList[i];
                      displayText = displayText + (kv[displayKey] ?? displayKey);
                    }
                  } else {
                    displayText = displayText + kv[kv.keys[0]];
                  }
                  return TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: 2, top: 15, bottom: 15)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).canvasColor),
                    ),
                    onPressed:(){
                      controllers.text = displayText;
                      this.onSelected(kv);
                      _dismiss();
                    },
                    child: Align(child: Text(displayText, textAlign: TextAlign.start,), alignment: Alignment.centerLeft,),
                  );
                }
                Widget txtField(){
                  return Container(
                    color:Theme.of(context).canvasColor,
                    child:TextField(
                        autofocus: true,
                        controller:controllers,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 2.0, right: 2),
                        ),
                        onChanged:(val) async {
                          if(val.length>0){
                            searchResult = await this.futureOrList(val);
                            if(searchResult.length>7) {
                             searchResult = searchResult.sublist(0,7);
                            }
                            setState(() => {});
                          }
                        }
                    ),
                  );
                }
                return CustomSingleChildLayout(
                  delegate: SingleChildDelegateWidget(
                      buttonRect: buttonRect,
                      screenSize: screenSize,
                      upOrDown:upOrDown
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: FadeTransition(
                       opacity: CurvedAnimation(
                       parent:animation,
                       curve: const Interval(0.0,1),
                       reverseCurve: const Interval(0.75,1.0),
                      ),
                      child: Container(
                        width: width,
                        child: upOrDown ? Column( //True ? Up : Down
                          children:[
                            SizedBox(
                              height:200,
                              child:ListView(
                                shrinkWrap: true,
                                reverse: true,
                                children:[
                                  for(var res in searchResult) items(res)
                                ],
                              ),
                            ),
                            txtField(),
                          ],
                        ) : Column(
                          children:[
                            txtField(),
                            ListView(
                              padding: EdgeInsets.only(top: 2),
                              shrinkWrap: true,
                              children: [
                                for(var res in searchResult) items(res)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          );
        }
    );
  }
}

class SingleChildDelegateWidget extends SingleChildLayoutDelegate {
  SingleChildDelegateWidget({this.buttonRect, this.screenSize,this.upOrDown});

  final Rect buttonRect;
  final Size screenSize;
  bool upOrDown;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double height=0;
    if(upOrDown){ //True => Up
      height = 260;
    } else { //False => Down
      height = screenSize.height + 100;//Good to go
    }
    return BoxConstraints(
      minWidth: buttonRect.width,
      maxWidth: buttonRect.width,
      maxHeight: height,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    if(upOrDown){ //True => Up
      return Offset(buttonRect.left,buttonRect.top * 0.61);
    } else { //False => Down
      return Offset(buttonRect.left,buttonRect.top + 1); //Good to go
    }
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    return false;
  }
}

_upDownCheck(top,height){
  if(height*0.70<top) { //True => Up
    return true;
  } else { //False => Down
    return false;
  }
}
