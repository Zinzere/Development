import 'package:flutter/material.dart';
import '../../ui/AllUi.dart';
import '../../api/Calls.dart';

class Operations extends StatefulWidget {
  Operations(this.settingsData,this.updJobTypes);
  var settingsData;
  final Function(List) updJobTypes;

  @override
  State<Operations> createState() => _OperationsState();
}

class _OperationsState extends State<Operations> {
  TextEditingController newJobTypeController = TextEditingController();
  bool newInsert = false;
  Color celColor = Colors.black26;
  List filter(type){
    return widget.settingsData.where((kv) => kv["TYPE"]==type).toList();
  }

  Widget Cell(child,{@required flex}){
    return Expanded(
      flex: flex ?? 1,
      child: Container(
          height: 45,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  width: 1,
                  color: celColor
              ),
              top: BorderSide(
                  width: 1,
                  color: celColor
              ),
            ),
          ),
          child: child
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Job Types / Operations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
            CSpace(),
            Text("Add Job Types here"),
            CSpace(),
            for(var jobs in filter("Work")) delShowRow(jobs["NAME"],jobs["ID"]),
            newInsert ? insRow() : SizedBox(),
            addNew(),
          ]
      ),
    );
  }

  Widget addNew() {
    return GestureDetector(
      onTap: () {
        newInsert=!newInsert;
        newJobTypeController.text="";
        setState(()=>{});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Icon(
              Icons.add,
              size: 15.0,
              color: Colors.blue,
            ),
          ),
          Text(
            "Add new row",
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget delShowRow(rowValue,id){
    return Container(
      width: 500,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 1,
              color: celColor
          ),
          right: BorderSide(
              width: 1,
              color: celColor
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Cell(Icon(
            Icons.person_add_alt,
            size: 15.0,
          ),flex: 1),
          Cell(Center(
            child: Text(
              rowValue,
              textScaleFactor: 1.5,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ),
          flex:2),
          Cell(
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
                size: 20.0,
              ),
              onPressed:(){
                deleteJobTye(id);
              },
            ),
            flex: 1
          ),
        ],
      ),
    );
  }

  Widget insRow() {
    return Container(
      decoration:BoxDecoration(
        border:Border(
          bottom:BorderSide(
              width: 1,
              color: celColor
          ),
          right:BorderSide(
              width: 1,
              color: celColor
          ),
        ),
      ),
      width: 500,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Cell(Icon(
            Icons.person_add_alt,
            size:15.0,
          ),flex:1),
          Cell(IntrinsicWidth(
              child: TextField(
                textAlign: TextAlign.center,
                autofocus: true,
                controller: newJobTypeController,
              ),
            ),
            flex: 2
          ),
          Cell(
            IconButton(
              icon: Icon(
                Icons.add_box,
                color: Colors.green,
                size: 20.0,
              ),
              onPressed:(){
                insertJobType(newJobTypeController.text);
              },
            ),
            flex:1,
          ),
        ],
      ),
    );
  }

  deleteJobTye(id) async {
    var result = await Calls.insDelMasterTypes({'id':id,'type':"DEL"});
    if(result["res"]){
      widget.settingsData = widget.settingsData.where((kv)=> kv["ID"]!=id).toList();
      widget.updJobTypes(widget.settingsData);
    }
    setState(()=>{});
  }
  insertJobType(newJobType) async {
    var result = await Calls.insDelMasterTypes({'name':newJobType,'type':"Work"});
    if(result["res"]){
      widget.settingsData.add({"ID":result["data"],"NAME":newJobType,"TYPE":"Work"});
      newInsert=false;
      newJobTypeController.text="";
      setState(()=>{});
    }
  }
}
