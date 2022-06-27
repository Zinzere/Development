import 'dart:async';
import 'package:flutter/material.dart';

TextEditingController searchController = TextEditingController();
typedef FutureOr<dynamic> futureListCallBack(String pattern);

class SearchField extends StatefulWidget {
  SearchField({@required this.onSelected, this.showKeyList, this.futureOrList, this.width = 400, this.label = "Search Here"});

  final Function(dynamic) onSelected; //If selected returns
  final futureListCallBack futureOrList; //Future or List
  final double width; //Width if want to adjust
  final String label; //Label of Search text Field
  final List<String> showKeyList; //List of Key's value will be shown in Search List

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
    itemRect = itemBox.localToGlobal(
        Offset.zero, ancestor: navigator.context.findRenderObject()) & itemBox
        .size;
    positionCheck = true;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return IntrinsicWidth(
      stepWidth: widget.width,
      child: TextField(
        controller: searchController,
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
  PopupWidget({this.buttonRect, this.screenSize, this.futureOrList, this.onSelected, this.width, this.label, this.showKeyList});

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
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: 2)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).canvasColor),
                    ),
                    onPressed:(){
                      searchController.text = displayText;
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
                        controller:searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 2.0, right: 2),
                        ),
                        onChanged:(val) async {
                          if(val.length>0){
                            //searchResult = data.where((listValue) => listValue.toLowerCase().contains(val.toLowerCase())).toList();
                            searchResult = await this.futureOrList(val);
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
                        curve: const Interval(0.0, 0.25),
                        reverseCurve: const Interval(0.75, 1.0),
                      ),
                      child: Container(
                        width: width,
                        child: SingleChildScrollView(
                          child: upOrDown ? Column( //True ? Up : Down
                            children:[
                              SizedBox(
                                height: 200,
                                child: ListView(
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
      height = 200;
    } else { //False => Down
      height = screenSize.height - buttonRect.top - 20;
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
      return Offset(buttonRect.left,buttonRect.top - 152);
    } else { //False => Down
      return Offset(buttonRect.left,buttonRect.top);
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
