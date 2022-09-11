import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

double widthPercentage = 1.4; //Global Percentage
TextStyle hdrTxtStyle = TextStyle(color:Colors.white,fontSize:14);
TextStyle dataTxtxStyle = TextStyle(color:Colors.black,fontWeight:FontWeight.w500);
Decoration btmRight = BoxDecoration(border: Border(bottom:BorderSide(width:1,color:Colors.black26),
                         right: BorderSide(width:1,color:Colors.black26)),);

class MapChangeCntrl {
  static updData(map,keyList,keyListLen,colNm,newData){//keyList ["ITEM",1,"WAGE",1];
    if(keyListLen==0){
      map[colNm]=newData;
      map["flag"]="upd";
    } else if(keyListLen==2){
      map[keyList[0]][keyList[1]][colNm]=newData;
      dynamic data = map[keyList[0]][keyList[1]];
      if(!data.containsKey("flag") && data["flag"]!="new"){
        map[keyList[0]][keyList[1]]["flag"]="upd";
      }
    } else if(keyListLen==4){
      dynamic data = map[keyList[0]][keyList[1]][keyList[2]][keyList[3]];
      if(!data.containsKey("flag") && data["flag"]!="new"){
        map[keyList[0]][keyList[1]][keyList[2]][keyList[3]]["flag"]="upd";
      }
      map[keyList[0]][keyList[1]][keyList[2]][keyList[3]][colNm]=newData;
    }
    return map;
  }
  static getData(map,keyMaps,dataKeyLstMap,keySubLvlMap,keyList){
    //keyMaps = {MAIN:["NM","ID"},ITEM:{"ITNM"}} | keyList = ["ITEM",0,"WAGE",1];
    //dataKeyLstMap = {"MAIN":["ID","NAME"]} | keySubLvlMap = {"MAIN":1,"ITEM":2}
    Map returnMap = {};
    keyMaps.forEach((key,val) {
      returnMap[key]={};
      int currSubLvl = keySubLvlMap[key];
      if(currSubLvl==0){
        val.forEach((sKey) {
          returnMap[key][sKey]=map[sKey].toString();
        });
      } else if(currSubLvl==1) {
        val.forEach((sKey) {
          returnMap[key][sKey]=map[keyList[0]][keyList[1]][sKey].toString();
        });
      } else {
        val.forEach((sKey) {
          returnMap[key][sKey]=map[keyList[0]][keyList[1]][keyList[2]][keyList[3]][sKey].toString();
        });
      }
    });
    return returnMap;
  }
  static setData(map,keyMaps,dataKeyLstMap,keySubLvlMap,keyList) {
    //keyMaps = {MAIN:{NM:ORD01},ITEM:{INM: Shirts}} | keyList = ["ITEM",0,"WAGE",1];
    //dataKeyLstMap = {"MAIN":["ID","NAME"]} | keySubLvlMap = {"MAIN":1,"ITEM":2}
    keyMaps.forEach((key, subMap) {
      if(key!="id"){
        int currSubLvl = keySubLvlMap[key];
        if (currSubLvl == 0) {
          subMap.forEach((sKey, val) {
            map[sKey] = val;
          });
        } else if (currSubLvl == 1) {
          subMap.forEach((sKey,val) {
            map[keyList[0]][keyList[1]][sKey] = val;
          });
        } else {
          subMap.forEach((sKey,val) {
            map[keyList[0]][keyList[1]][keyList[2]][keyList[3]][sKey] = val;
          });
        }
      }
    });
    return map;
  }
  static newMap(map) {
    Map<String,dynamic> newObj={};
    map.forEach((k,v) {
      if(v is List) {
        newObj[k]=[{}];
        map[k][0].forEach((k1,v1) {
          if(v1 is List) {
            newObj[k][0][k1]=[{}];
            map[k][0][k1][0].forEach((k2,v2) {
              newObj[k][0][k1][0][k2]="";
            });
          } else {newObj[k][0][k1]="";}
        });
      } else {newObj[k]="";}
    });
    newObj["flag"]="new";
    newObj["del"]={};
    return newObj;
  }
  static addData(map,keyList,keyListLen){//keyList ["ITEM",1,"WAGE",1];
    Map newObj={"flag":"new"};
    if(keyListLen==2) {
      dynamic data = map[keyList[0]][keyList[1]];
      data.forEach((k,v) {
        if(v is List) {
          newObj[k]=[];var tempObj = {};
          data[k][0].forEach((key,vl){tempObj[key]="";});
          newObj[k].add(tempObj);
        } else {newObj[k]="";}
      });
      map[keyList[0]].add(Map<String, Object>.from(newObj));
    } else if (keyListLen==4) {
      dynamic data = map[keyList[0]][keyList[1]][keyList[2]][keyList[3]];
      data.forEach((k,v) {
        if(v is List) {
          newObj[k]=[];var tempObj = {};
          data[k][0].forEach((key,vl){tempObj[key]="";});
          newObj[k].add(tempObj);
        } else {newObj[k]="";}
      });
      map[keyList[0]][keyList[1]][keyList[2]].add(Map<String, Object>.from(newObj));
    }
    return map;
  }
  static delData(map,keyList,keyListLen){
    if (keyListLen==2) {
      String keyNm = keyList[0];
      dynamic data = map[keyList[0]][keyList[1]];
      if(map["del"].containsKey(keyNm)){
        if(!data.containsKey("flag") && data["flag"]!="new"){ map["del"][keyNm].add(data); }
        map[keyList[0]].removeAt(keyList[1]);
      } else {
        if(!data.containsKey("flag") && data["flag"]!="new"){ map["del"][keyNm]=[data];}
        map[keyList[0]].removeAt(keyList[1]);
      }
    } else if (keyListLen==4) {
      String keyNm = keyList[2];
      dynamic data = map[keyList[0]][keyList[1]][keyList[2]][keyList[3]];
      if(map["del"].containsKey(keyNm)){
        if(!data.containsKey("flag") && data["flag"]!="new"){ map["del"][keyNm].add(data);}
        map[keyList[0]][keyList[1]][keyList[2]].removeAt(keyList[3]);
      } else {
        if(!data.containsKey("flag") && data["flag"]!="new"){ map["del"][keyNm]=data;}
        map[keyList[0]][keyList[1]][keyList[2]].removeAt(keyList[3]);
      }
    }
    return map;
  }
}



class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newTxt = newValue.text;
    String oldTxt = oldValue.text;
    int newLen = newTxt.length;
    int oldLen = oldTxt.length;
    String onlyNum = newTxt.replaceAll("-","");
    if(newTxt==""){
      return newValue;
    } else if(RegExp(r'^[0-9]+$').hasMatch(onlyNum)) {
      if(newLen>4 && !newTxt.contains("-")){
        return TextEditingValue(
            text: newTxt.substring(0,4)+"-",
            selection: TextSelection.collapsed(
                offset:5
            )
        );
      } else if(newLen==4 && oldLen==3){
        return TextEditingValue(
            text: newTxt+"-",
            selection: TextSelection.collapsed(
                offset:5
            )
        );
      } else if(newLen==7 && oldLen==6){
        if(int.parse(newTxt.substring(5,7))>12){
          return TextEditingValue(
              text: newTxt.substring(0,4)+"-",
              selection: TextSelection.collapsed(
                  offset:5
              )
          );
        } else {
          return TextEditingValue(
              text: newTxt+"-",
              selection: TextSelection.collapsed(
                  offset:newValue.selection.end+1
              )
          );
        }
      } else if(newLen>10) {
        return oldValue;
      } else {
        return newValue;
      }
    } else {
      return oldValue;
    }
  }
}

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

typedef FutureOr<dynamic> futureListCallBack(String pattern);

class CellSearch extends StatefulWidget {
  CellSearch({@required
  this.onSelected,
    this.controller,
    this.showKeyList,
    this.futureOrList,
  });

  final Function(dynamic) onSelected; //If selected returns
  final futureListCallBack futureOrList; //Future or List
  final List<String> showKeyList; //List of Key's value will be shown in Search List
  final TextEditingController controller;

  @override
  State<CellSearch> createState() => _CellSearchState();
}

class _CellSearchState extends State<CellSearch> {
  Size screenSize;
  NavigatorState navigator;
  RenderBox itemBox;
  Rect itemRect;
  bool positionCheck = false; //fasle position values not generated | true generated
  bool isSelected = false; //becomes true if data gets selected from drop down
  getPosition() {
    navigator = Navigator.of(context);
    itemBox = context.findRenderObject() as RenderBox;
    itemRect = itemBox.localToGlobal(Offset.zero, ancestor: navigator.context.findRenderObject()) & itemBox.size;
    positionCheck = true;
  }
  selectedFun(){
    isSelected=true;
  }
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return TextField(
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: "Search..",
        hintStyle: TextStyle(color: Colors.black45),
        contentPadding: EdgeInsets.only(left: 2, bottom: 18),
      ),
      onTap:() {
        if(!positionCheck){
          getPosition();
        }
        Navigator.push(context,
            PopupWidget(
                controllers: widget.controller,
                buttonRect: itemRect,
                futureOrList: widget.futureOrList,
                showKeyList: widget.showKeyList,
                onSelected: widget.onSelected,
                screenSize: screenSize,
                isSelected:{"is":isSelected,"chk":selectedFun}
            ));
      },
      onChanged: (val) {
        if(!positionCheck) {
          getPosition();
        }
        Navigator.push(context,
            PopupWidget(
                controllers: widget.controller,
                buttonRect: itemRect,
                futureOrList: widget.futureOrList,
                showKeyList: widget.showKeyList,
                onSelected: widget.onSelected,
                screenSize: screenSize,
                isSelected:{"is":isSelected,"chk":selectedFun}
            ));
      },
    );
  }
}

class PopupWidget extends PopupRoute {
  PopupWidget({
    this.buttonRect,
    this.controllers,
    this.screenSize,
    this.isSelected,
    this.futureOrList,
    this.onSelected,
    this.showKeyList});

  final TextEditingController controllers;
  final Rect buttonRect;
  final futureListCallBack futureOrList;
  final Function(dynamic) onSelected;
  final List<String> showKeyList;
  final Size screenSize;
  final dynamic isSelected;
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
    TextEditingController searchCntroler = TextEditingController();
    searchCntroler.text = controllers.text;
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
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: BorderSide(width: 1,color: Colors.black26)
                      ))
                    ),
                    onPressed:(){
                      searchCntroler.text = controllers.text = displayText;
                      isSelected["chk"]();
                      this.onSelected(kv);
                      _dismiss();
                    },
                    child: Align(child: Text(displayText, textAlign: TextAlign.start,style: TextStyle(fontSize: 12),), alignment: Alignment.centerLeft,),
                  );
                }
                Widget txtField(){
                  return Container(
                    height: 25,
                    color:Theme.of(context).canvasColor,
                    child:TextField(
                        autofocus: true,
                        controller:searchCntroler,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 2, bottom: 18),
                        ),
                        onChanged:(val) async {
                          if(!isSelected["is"]){
                            controllers.text="";
                          }
                          if(val.length>0){
                            heightCheck=true;
                            searchResult = await this.futureOrList(val);
                            if(searchResult.length>7) {
                              searchResult = searchResult.sublist(0,7);
                            }
                          } else {
                            heightCheck=false;
                            searchResult = [];
                            controllers.text="";
                            this.onSelected("");
                            _dismiss();
                          }
                          setState(() => {});
                        }
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
                                shrinkWrap:true,
                                reverse:true,
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
  SingleChildDelegateWidget({this.buttonRect, this.screenSize,this.upOrDown,this.heightCheck});

  final Rect buttonRect; //Rect.fromLTRB(340.9, 522.0, 450.4, 549.0)
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
      maxHeight: heightCheck ? height : buttonRect.height + 200,//false up | true down
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    if(upOrDown){ //True => Up
      //print(buttonRect.top); //522
      //print(buttonRect.left); //340
      return Offset(buttonRect.left,buttonRect.top - 200); //dx | dy
    } else { //False => Down
      return Offset(buttonRect.left,buttonRect.top); //Good to go | buttonRect.left,buttonRect.top + 1
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
