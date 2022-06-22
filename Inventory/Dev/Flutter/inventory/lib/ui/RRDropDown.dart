import 'package:flutter/material.dart';

class RRDropDown extends StatefulWidget {
  RRDropDown(this.list,this.selected,{@required this.onSelected, this.id});
  String selected;
  final List<String> list;
  final Function(String,String) onSelected;
  final String id;
  @override
  State<RRDropDown> createState() => _RRDropDownState();
}

class _RRDropDownState extends State<RRDropDown> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex:1,
        child: Container(
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                    width: 2,
                    color: Colors.black26
                ),
              ),
            ),
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Center(
              child: DropdownButton<String>(
                underline: Container(),
                onChanged: (value) {
                  setState(() {
                    widget.selected = value;
                    widget.onSelected(value,widget.id);
                  });
                },
                value: widget.selected,
                items: widget.list.map((e) => DropdownMenuItem(
                  child: Text(e + " ", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54,fontSize: 20)),
                  value: e,)).toList(),
              ),
            )
        )
    );
  }
}
