/*
SearchField(
  controller: TextEdittingController(),
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
  SearchField({@required
      this.onSelected,
      this.controller,
      this.showKeyList,
      this.futureOrList,
      this.width = 400,
      this.decoration,
      this.textAlign=TextAlign.start,
      this.label = ""});

  final Function(dynamic) onSelected; //If selected returns
  final futureListCallBack futureOrList; //Future or List
  final double width; //Width if want to adjust
  final String label; //Label of Search text Field
  final List<String> showKeyList; //List of Key's value will be shown in Search List
  final TextEditingController controller;
  final InputDecoration decoration;
  final TextAlign textAlign;

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
        textAlign: widget.textAlign,
        controller: widget.controller,
        decoration: widget.decoration ?? InputDecoration(
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
                  textAlign: widget.textAlign,
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
          if (!positionCheck) {
            getPosition();
          }
          Navigator.push(context,
              PopupWidget(
                  controllers: widget.controller,
                  textAlign: widget.textAlign,
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
  PopupWidget({
    this.buttonRect,
    this.controllers,
    this.textAlign,
    this.screenSize,
    this.futureOrList,
    this.onSelected,
    this.width,
    this.label,
    this.showKeyList});

  final TextEditingController controllers;
  final TextAlign textAlign;
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
    bool heightCheck = false;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                Widget items(kv) {
                  String displayText = "";
                  if (this.showKeyList != null) {
                    for (var i = 0; i < this.showKeyList.length; i++) {
                      String displayKey = this.showKeyList[i];
                      var val = kv[displayKey] ?? displayKey;
                      displayText = displayText + val.toString();
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
                Widget txtField(width){
                  return Container(
                    height: 35,
                    color:Theme.of(context).canvasColor,
                    child:IntrinsicWidth(
                      stepWidth: width,
                      child: TextField(
                          textAlign: textAlign,
                          autofocus: true,
                          controller:controllers,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 2.0, right: 2,bottom: 3),
                          ),
                          onChanged:(val) async {
                            if(val.length>0){
                              heightCheck=true;
                              searchResult = await this.futureOrList(val);
                              if(searchResult.length>7) {
                               searchResult = searchResult.sublist(0,7);
                              }
                            } else {
                              heightCheck=false;
                              searchResult = [];
                              this.onSelected({});
                              _dismiss();
                            }
                            setState(() => {});
                          }
                      ),
                    ),
                  );
                }
                return CustomSingleChildLayout(
                  delegate: SingleChildDelegateWidget(
                      buttonRect: buttonRect,
                      screenSize: screenSize,
                      upOrDown:upOrDown,
                      heightCheck:heightCheck,
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
                            txtField(width),
                          ],
                        ) : Column(
                          children:[
                            txtField(width),
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
  SingleChildDelegateWidget({this.buttonRect, this.screenSize,this.upOrDown,this.heightCheck});

  final Rect buttonRect;
  final Size screenSize;
  bool upOrDown;
  bool heightCheck;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double height=0;
    if(upOrDown){ //True => Up
      height = 260;
    } else { //False => Down
      height = screenSize.height + 100;//Good to go screenSize.height + 100
    }
    return BoxConstraints(
      minWidth: buttonRect.width,
      maxWidth: buttonRect.width,
      maxHeight: heightCheck ? height : buttonRect.height,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    if(upOrDown){ //True => Up
      return Offset(buttonRect.left,buttonRect.top * 0.61);
    } else { //False => Down
      return Offset(buttonRect.left,buttonRect.top + 3); //Good to go | buttonRect.left,buttonRect.top + 1
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
