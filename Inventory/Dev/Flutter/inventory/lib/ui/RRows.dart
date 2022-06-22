import 'package:flutter/material.dart';
import 'package:http/http.dart' ;
import 'dart:convert';
import 'RRDropDown.dart';
import '../api/Calls.dart';

class RRows extends StatefulWidget {
  RRows({@required this.future,this.headers,this.rows, this.subKey,this.subRows, this.subHeaders});
  final List<String> headers;
  Future future;
  final List<Map<String,dynamic>> rows;
  final String subKey;
  final List<String> subHeaders;
  final List<Map<String,dynamic>> subRows;

  @override
  State<RRows> createState() => _RRowsState();
}

class _RRowsState extends State<RRows> {

  final List<String> _dropList = [
    "Not Yet Started",
    "Work In Progress",
    "Done",
    "Delivered"
  ];

  @override
  Widget build(BuildContext context) {
    Color rowBg = Colors.white;
    Color lines = Colors.black26;
    Color subRowBg = Colors.grey[200];
    Color headerClr = Colors.blue;
    Color rowhdrClr = Colors.deepPurple;
    Color itemsClr = Colors.black54;

    Widget HeadWid(name, textClr,{@required flex, bgClr}){
      int flexVal = flex ?? 1;
      return Expanded(
        flex: flexVal,
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
            // color: bgClr ?? rowBg,
            border: Border(
              right: BorderSide(
                  width: 2,
                  color: lines
              ),
            ),
          ),
          child: Text(name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textClr,
                fontSize: 20),),
        ),
      );
    }
    Widget SubRowWid(skv){
      List<Widget> kids = [];
      for(var elm in widget.subRows) {
        if(elm.containsKey("text")) {
          if(elm.containsKey("flex")) {
            kids.add(HeadWid(skv[elm["text"]],itemsClr, flex: elm["flex"], bgClr: subRowBg));
          } else {
            kids.add(HeadWid(skv[elm["text"]],itemsClr, bgClr: subRowBg));
          }
        }
      };
      return Padding(
        padding: const EdgeInsets.only(left: 15, right: 50),
        child: Row(
            children: kids
        ),
      );
    }
    Widget RowWid(kv) {
      List<Widget> kids = [];
      for(var elm in widget.rows) {
        if(elm.containsKey("text")) {
          kids.add(HeadWid(kv[elm["text"]],itemsClr));
        } else if(elm.containsKey("dd")) {
          kids.add(RRDropDown(_dropList, kv[elm["dd"]],
             onSelected:dropDownSelected,
             id: kv[elm["id"]],
          ));
        }
      };
      return Container(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: ExpansionTile(
          title: Row(
            children: kids
          ),
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 50),
                child: Row(
                children: [
                  for(var i=0;i<widget.subHeaders.length;i++)
                    HeadWid(widget.subHeaders[i],
                        rowhdrClr,
                        flex: widget.subRows[i].containsKey("flex") ? widget.subRows[i]["flex"] : 1,
                        bgClr: subRowBg
                    )
                  ],
                ),
              ),
             for(var srows in kv[widget.subKey]) SubRowWid(srows)
          ],
        ),
      );
    }

    return FutureBuilder(
        builder: (ctx, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<dynamic> data = snapshot.data as List<dynamic>;
              int len = data.length;
              return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 50, bottom: 5, top: 5),
                        child: Row(
                          children: [
                            for(var hdrs in widget.headers) HeadWid(hdrs, headerClr),
                          ],
                        ),
                      ),
                      for(var kv in data) RowWid(kv),
                    ],
                  )
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Text("No Records Found");
        },
        future: widget.future
    );
  }

  dropDownSelected(val,id) async {
    if(val=="Delivered") {
      var result = await Calls.updBillStatus({"status":val,"id":id});
      if(result["res"]){
        widget.future = Calls.getOrderReports();
        setState((){});
      }
    } else {
      await Calls.updBillStatus({"STATUS":val,"ID":id});
    }
  }
}
