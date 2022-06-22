import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  CheckBox({@required this.label, this.choices, this.selected, this.multiple});
  final String label;
  final List choices;
  bool multiple;
  final Function(dynamic) selected;

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  List<bool> checkList = [];
  bool mulCheck;
  check(i){
    if(mulCheck){
      checkList[i]=!checkList[i];
      widget.selected(checkList);
    } else {
      checkList.fillRange(0, checkList.length, false);
      checkList[i]=true;
      widget.selected(i);
    }
    setState(()=>{});
  }

  children(){
    List<Widget> rows = [];
    for(var i=0;i<widget.choices.length;i++) {
      rows.addAll(
        [
          Checkbox(value: checkList[i], onChanged:(value){
            check(i);
          }),
          SizedBox(width: 5,),
          GestureDetector(
            child: Text(widget.choices[i], style: TextStyle(fontSize: 20),),
            onTap: (){
              check(i);
            },
          ),
          SizedBox(width: 20,),
        ]
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    mulCheck=widget.multiple ?? false;
    if(checkList.length==0){
      checkList = List.filled(widget.choices.length, false);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        Text(widget.label ?? "",style: TextStyle(color: Colors.purple, fontSize: 15),),
        Wrap(
          alignment: WrapAlignment.start,
          children:children(),
        )
      ],
    );
  }
}

// Checkbox(
// value: boolValue,
// onChanged: onChanged,
// )