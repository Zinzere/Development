import 'package:flutter/material.dart';
import 'TTableDropDown.dart';

/*
--> WidgetList Types -> button,txt,funTxt,dropdown,link
TTables(
    data: [{'id':100,'title':'Flutter Basics','author':'David John','return':34,'name':'Delivered','date':'2022-01-01'},
      {'id': 101,'title':'Flutter Advanced','author':'David John','return':35,'name':'Not Yet Started','date':'2022-05-31'},
      {'id': 102,'title':'Git and GitHub','author':'Merlin Nick','return':36,'name':'Work In Progress','date':'2022-01-01'},
      {'id': 102,'title':'Git and GitHub','author':'Merlin Nick','return':36,'name':'Work In Progress','date':'2022-01-01'},
      {'id': 102,'title':'Git and GitHub','author':'Merlin Nick','return':36,'name':'Work In Progress','date':'2022-01-01'},
      {'id': 101,'title':'Flutter Advanced','author':'David John','return':35,'name':'Not Yet Started','date':'2022-05-31'}
    ],
    headerList: {'ID':'id','Date':'date','Book':'title','Author':'name'},
    widList:[
      {'type':'txt','flex':1},
      {'type':'funTxt','flex':1,'fun':testFun},
      {'type':'link','flex':1,'click':{'return':'id','fun':click},},
      {'type':'button','flex':1,
        'color':{'Flutter Basics':'orange','Flutter Advanced':'red','Git and GitHub':'green'},
        'click':{'return':'id','fun':click},
      },
      {'type':'dropdown','flex':1,'click':{'return':'id','fun':optFun},
        'list':['Not Yet Started','Work In Progress','Delivered','Blocked']}],
  )
*/

class TTables extends StatefulWidget{
  TTables({@required this.data,this.widList, this.headerList, this.filter=false});
  final List<Map<String,dynamic>> widList; //[ {'type':'txt','flex':1}, {'type':'funTxt','flex':1,'fun':function} ]
  final Map<String,String> headerList; //{'ID':'id','Book':'title'}
  final List<Map<String,dynamic>> data; //[{'id':100,'title':'1s'},{'id':100,'title':'2s'}]
  final bool filter;

  @override
  State<TTables> createState() => _TTablesState();
}
class _TTablesState extends State<TTables> {
  Color celColor = Colors.black26;
  Color headerClr = Colors.black54;
  List headerList = [];
  List ColNameList = [];
  List DataList = [];
  List WidList = [];
  List<TextEditingController> filterTxtFldList = [];
  Widget Button(btnName,i,sendData){
    Color btnColor = Colors.teal;
    String clrVal = WidList[i]['color'][btnName.toString()];
    switch(clrVal) {
      case "red": {
        btnColor = Colors.pink;
      }break;
      case "green": {
        btnColor = Colors.teal;
      }break;
      case "orange": {
        btnColor = Colors.amber[800];
      } break;
    }
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ElevatedButton(
        onPressed:(){
          var fun=WidList[i]["click"]["fun"];
          fun(sendData);
        },
        child: Text(btnName.toString()),
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            fixedSize: const Size(240, 80), primary: btnColor),
      ),
    );
  }
  Widget Link(val,i,sendData){
    return Center(
      child: InkWell(
          child: Text(val,
              style:TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,)),
          onTap:(){
            var fun=WidList[i]["click"]["fun"];
            fun(sendData);
          }
      ),
    );
  }
  Widget Txt(val){
    return Center(
      child:Text(
        val.toString(),
        style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
  Widget OptnTxt(val,fun){
    Color flag = Colors.black;
    if(fun(val)){
      flag = Colors.red;
    }
    return Center(
      child:Text(
        val.toString(),
        style:TextStyle(fontSize: 18, color: flag, fontWeight: FontWeight.bold),
      ),
    );
  }
  Widget filterTxtFld(){
    List<Widget> rowCell=[];
    int len = headerList.length;
    for(var i=0;i<len;i++){
      filterTxtFldList.add(TextEditingController());
      rowCell.add(Cell(Padding(
        padding: const EdgeInsets.all(5.0),
        child: IntrinsicWidth(
          child: TextField(
            textAlign: TextAlign.center,
            controller: filterTxtFldList[i],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(2),
                border: OutlineInputBorder(),
              ),
            onChanged: (val) => onChanged(val, ColNameList[i]),
          ),
        ),
      ),flex:WidList[i]['flex']));
    }
    return Rows(rowCell);
  }
  onChanged(val,key){
    if(val=="") {
      bool check = true;
      filterTxtFldList.forEach((txtFld) {
        if(txtFld.text!="" && check){
          check=false;
        }
      });
      if(check){
        DataList=widget.data;
      }
    } else {
      DataList=widget.data.where((kv)=> kv[key].toString().toLowerCase().contains(val.toLowerCase())).toList();
    }
    setState(()=>{});
  }
  Widget AllRows(eachKV){
    List<Widget> rowCell=[];
    for(var i=0;i<WidList.length;i++){
      String type=WidList[i]['type'];
      if(type=='txt'){
        rowCell.add(Cell(
            Txt(eachKV[ColNameList[i]]),
            flex:WidList[i]['flex']));
      } else if(type=='funTxt'){
        rowCell.add(Cell(
            OptnTxt(eachKV[ColNameList[i]],WidList[i]['fun']),
            flex:WidList[i]['flex']));
      } else if(type=='button'){
        rowCell.add(Cell(
            Button(eachKV[ColNameList[i]],i,eachKV[WidList[i]['click']['return']].toString()),
            flex:WidList[i]['flex']));
      } else if(type=='link'){
        rowCell.add(Cell(//{'type':'link','flex':1,'click':{'return':'id','fun':click},
            Link(eachKV[ColNameList[i]],i,eachKV[WidList[i]['click']['return']].toString()),
            flex:WidList[i]['flex']));
      } else if(type=='dropdown'){
        rowCell.add(Cell(
            TableDropDown(
              WidList[i]['list'],
              eachKV[ColNameList[i]].toString(),
              onSelected: WidList[i]['click']['fun'],
              id:eachKV[WidList[i]['click']['return']].toString())
            ,flex:WidList[i]['flex']));
      }
    }
    return Rows(rowCell);
  }
  Widget Rows(listWids){
    return Row(children:listWids);
  }
  Widget HeaderRow(){
    List<Widget> hdrRws = [];
    for (var i=0;i<headerList.length;i++) {
      hdrRws.add(HeaderCell(headerList[i],flex:WidList[i]['flex']));
    }
    return Rows(hdrRws);
  }
  Widget HeaderCell(txt,{@required flex}){
    return Cell(
        Center(
          child:Text(txt,
              style:TextStyle(
                  fontWeight:FontWeight.bold,
                  color: headerClr,
                  fontSize: 20)
          ),
        ),
        flex: flex);
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
    headerList = List.from(widget.headerList.keys);
    ColNameList = List.from(widget.headerList.values);
    if(DataList.length==0) {
      DataList = widget.data;
    }
    WidList = widget.widList;
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                width: 1,
                color: celColor
            ),
            right: BorderSide(
                width: 1,
                color: celColor
            )
        ),
      ),
      child: Column(
        children:[
          HeaderRow(),
          widget.filter ? filterTxtFld() : SizedBox(),
          for(var eachKV in DataList) AllRows(eachKV)
        ],
      ),
    );
  }
}
