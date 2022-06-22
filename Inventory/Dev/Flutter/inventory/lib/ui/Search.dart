import 'dart:async';
import 'package:flutter/material.dart';

typedef FutureOr<dynamic> futureListCallBack(String pattern);

class Search extends StatefulWidget {
  final futureListCallBack futureOrList;
  final TextEditingController controller;
  final List<String> displayList;
  final String hintText;
  final Function(dynamic) onChanged;
  final InputDecoration textFieldDecoration;
  final bool returnValueText;
  final bool isAddWidget;
  final Widget addWidget;

  Search(
      {Key key,
        this.hintText,
        this.controller,
        this.displayList,
        this.onChanged,
        this.textFieldDecoration,
        this.returnValueText,
        this.isAddWidget,
        this.addWidget,
        this.futureOrList})
      : assert(futureOrList != null),assert(controller != null),
        super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool futureOrListCheckBool;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isAddWidget!=null && !widget.isAddWidget){
      widget.onChanged({"NEW":true});
      Navigator.pop(context);
    }
    if(widget.futureOrList.runtimeType.toString().contains("Future")) {
      futureOrListCheckBool = true;
    } else {
      futureOrListCheckBool = false;
    }
    return Padding(
        padding: EdgeInsets.only(left: 30, right: 30.0),
        child: TextField(
            controller: widget.controller,
            decoration: widget.textFieldDecoration ?? InputDecoration(
                labelText: widget.hintText ?? "",
                labelStyle: TextStyle(
                    color: Colors.purple, fontStyle: FontStyle.italic)),
            readOnly: true,
            onTap: _onExpanded));
  }

  void _onExpanded() {
    Navigator.push(context, _DataDisplayRoute(builder: (BuildContext context) {
      return _MenuItems(
        onChangedReturn: widget.onChanged,
        controller: widget.controller,
        displayList: widget.displayList,
        hintText: widget.hintText,
        futureOrList: widget.futureOrList,
        addWidget:widget.addWidget,
        isAddWidget: widget.isAddWidget,
        futureOrListCheckBool:futureOrListCheckBool,
        returnValueText: widget.returnValueText ?? false,
      );
    }));
  }
}

class _MenuItems extends StatefulWidget {

  _MenuItems(
      {@required this.onChangedReturn,
        this.controller,
        this.displayList,
        this.hintText,
        this.futureOrListCheckBool,
        this.returnValueText,
        this.isAddWidget,
        this.addWidget,
        this.futureOrList});

  final Function(dynamic) onChangedReturn;
  final TextEditingController controller;
  final List<String> displayList;
  final futureListCallBack futureOrList;
  final bool returnValueText;
  final String hintText;
  final bool futureOrListCheckBool;
  final bool isAddWidget;
  final Widget addWidget;

  @override
  _MenuItemsState createState() => _MenuItemsState();
}

class _MenuItemsState<T> extends State<_MenuItems> {
  Future _future;
  List<String> suggestionsList = [];
  bool addCheck = false;

  @override
  void initState() {
    if(widget.futureOrListCheckBool) {
      _future = widget.futureOrList(widget.controller.text);
    } else {
      suggestionsList = widget.futureOrList(widget.controller.text);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Builder(builder: (BuildContext context) {
            return CustomSingleChildLayout(
                delegate: _singleChildDelegate(),
                child: Material(
                    color: Theme.of(context).canvasColor,
                    child: addCheck ? widget.addWidget
                        : ListView(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 30, right: 30.0, top: 10.0),
                          child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: widget.controller,
                              autofocus: true,
                              onChanged: (value) {
                                if(widget.futureOrListCheckBool) {
                                  _future = widget.futureOrList(widget.controller.text);
                                } else {
                                  suggestionsList = widget.futureOrList(widget.controller.text);
                                  suggestionsList = suggestionsList.where((listValue) => listValue.toLowerCase().contains(value.toLowerCase())).toList();
                                }
                                setStates();
                              },
                              onEditingComplete: () {
                                if(widget.returnValueText && widget.controller.text!=null) {
                                  _onSelected(widget.controller.text,widget.controller.text);
                                } else {
                                  _onSelected("","");
                                }
                                setState((){});
                              },
                              decoration: InputDecoration(
                                  suffixIcon: Container(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(icon: Icon(Icons.close),
                                          onPressed: () {
                                            WidgetsBinding.instance.addPostFrameCallback((_) => widget.controller.clear());
                                            if(widget.futureOrListCheckBool) {
                                              _future = widget.futureOrList("");
                                            } else {
                                              suggestionsList = widget.futureOrList("");
                                            }
                                            setStates();
                                          },),
                                        IconButton(icon: Icon(Icons.arrow_back),
                                          onPressed: () {
                                            if(widget.returnValueText && widget.controller.text!=null) {
                                              _onSelected(widget.controller.text,widget.controller.text);
                                            } else {
                                              _onSelected("","");
                                            }
                                            setStates();
                                          },)
                                      ],
                                    ),
                                  ),
                                  labelText: widget.hintText ?? "",
                                  labelStyle: TextStyle(
                                      color: Colors.purple,
                                      fontStyle: FontStyle.italic)
                              )
                          )),
                      widget.futureOrListCheckBool==true ? ifFuture() : ifList(),
                    ])));
          });
        }
    );
  }

  void setStates() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget ifList() {
    List<Widget> rows = [];
    String displayText ="";
    for(var i=0;i<suggestionsList.length;i++) {
      dynamic value = suggestionsList[i];
      if(widget.displayList!=null) {
        for (var i = 0; i < widget.displayList.length; i++) {
          String displayKey = widget.displayList[i];
          displayText = displayText + (value[displayKey] ?? displayKey);
        }
      } else {
        displayText = displayText + value[value.keys[0]];
      }
      rows.add(
          InkWell(
              onTap: () {
                _onSelected(displayText, value);
              },
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 30.0),
                title: Text(displayText),
              ))
      );
    }

    return Column(
      children: rows,
    );
  }

  Widget ifFuture() {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
             return SizedBox(
                  width: 300,
                  height: 500,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        String displayText = "";
                        dynamic value = snapshot.data[index];
                        if (widget.displayList != null) {
                          for (var i = 0; i < widget.displayList.length; i++) {
                            String displayKey = widget.displayList[i];
                            displayText = displayText + (value[displayKey] ?? displayKey);
                          }
                        } else {
                          displayText = displayText + value[value.keys[0]].toString();
                        }
                        return InkWell(
                            onTap: () {
                              if (value["ADD"] == "Y") {
                              } else {
                                _onSelected(displayText, value);
                              }
                            },
                            child: ListTile(
                                contentPadding: EdgeInsets.only(left: 30.0),
                                title: Text(displayText)
                            ));
                      }));
          } else {
            return SizedBox();
          }
        } else {
          return Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Function _onSelected(String display, dynamic item) {
    widget.controller.text = display;
    suggestionsList = [];
    if(item.length>0){
      widget.onChangedReturn(item);
    } else {
      widget.onChangedReturn("");
    }
    Navigator.pop(context);
  }
}

//This class calls new Data Menu using the Routes.
// Routes will call its child having the Structure of Data form for selection like Box Menu, Choice Cip etc
class _DataDisplayRoute extends PopupRoute {
  _DataDisplayRoute({
    @required this.builder,
    this.dismissible = true,
    this.label,
    this.color,
    RouteSettings setting,
  }) : super(settings: setting);

  final WidgetBuilder builder;
  final bool dismissible;
  final String label;
  final Color color;

  @override
  Color get barrierColor => color;

  @override
  bool get barrierDismissible => dismissible;

  @override
  String get barrierLabel => label;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> opacity,
      Animation<double> secondaryAnimation,
      ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> opacity,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return child;
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

//This class is used to position the CustomChildWidget (Selection Menu), used as delegate for CustomSingleChildLayout Widget
class _singleChildDelegate extends SingleChildLayoutDelegate {
  double mobMaxWidth;
  double mobMaxHeight;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    mobMaxWidth = constraints.maxWidth;
    mobMaxHeight = constraints.maxHeight;

    return BoxConstraints(
      minWidth: mobMaxWidth,
      maxWidth: mobMaxWidth,
      minHeight: mobMaxHeight,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0,10); //Starts from 0th Position below App Bar, Till Bottom. //kToolbarHeight + 30
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    //Update this condition
    return false;
  }
}
