import 'package:flutter/material.dart';

class TableDropDown extends StatefulWidget {
  TableDropDown(this.list,this.selected,{@required this.onSelected, this.id});
  String selected;
  final List<String> list;
  final Function(String,String) onSelected;
  final String id;
  @override
  State<TableDropDown> createState() => _TableDropDownState();
}

class _TableDropDownState extends State<TableDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.only(left: 30, right: 10),
      child: DropdownButton<String>(
        underline:SizedBox(),
        onChanged:(value) {
          setState((){
            widget.selected = value;
            widget.onSelected(value,widget.id);
          });
        },
        value: widget.selected,
        isExpanded: true,
        style:TextStyle(color:Colors.white, fontSize: 16),
        dropdownColor: Colors.black87,
        items: widget.list.map((e) =>
            DropdownMenuItem(
             child: Text(e + " ",
              style:TextStyle(fontSize: 18)),
          value: e,)).toList(),
      ),
    );
  }
}
