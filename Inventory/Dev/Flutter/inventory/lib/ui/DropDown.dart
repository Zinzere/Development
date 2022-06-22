import 'package:flutter/material.dart';

/*
//Ket Value List
DropDown(
  onSelected: (val) {
    print(val);
  },
  selected: "First Value",
  showKey: "NAME",
  kvList: [{"ID":1,"NAME":"First Value"},{"ID":1,"NAME":"Second Value"},{"ID":1,"NAME":"Third Value"}],
)
// List Drop Down
DropDown(
  onSelected: (val) {
   print(val);
  },
  selected: "First Value",
  list:["First Value","Second Value","Third Value"],
)
 */

class DropDown extends StatefulWidget {
  DropDown(
      {@required this.onSelected,
      this.list,
      this.kvList,
      this.selected,
      this.showKey});

  String selected; //"A"
  final List<String> list; //["A","B","C"]
  final List<dynamic> kvList; //[{"id":2,"name":"A"},{"id":3,"name":"B"}]
  final String showKey; //"name"
  final Function(dynamic) onSelected; //function(val) {print(val)}
  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
          underline: Container(),
          onChanged: (value) {
            widget.selected = value;
            setState(() {
              if (widget.list == null) {
                widget.kvList.forEach((kv) => {
                  if (kv[widget.showKey] == value) {widget.onSelected(kv)}
                });
              } else {
                widget.onSelected(value);
              }
            });
          },
          value: widget.selected,
          items: widget.list == null
              ? [
                  for (var kv in widget.kvList)
                    DropdownMenuItem(
                      child: Text(kv[widget.showKey],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 13)),
                      value: kv[widget.showKey],
                    )
                ]
              : widget.list
                  .map((e) => DropdownMenuItem(
                        child: Text(e,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 20)),
                        value: e,
                      ))
                  .toList()),
    );
  }
}
