import 'package:flutter/material.dart';
import 'package:inventory/ui/AllUi.dart';
import '../ui/SearchField.dart';
import 'package:flutter/services.dart';

/*
Container(
      padding: EdgeInsets.only(top: 100, left: 50),
      width: 900,
        child: CurdForm(
          data: [{"id":24,"Item":{"NAME":"Unni","ID":24},"qty":null,"price":null,"tot":null}],
                 //{"id":44,"Item":{"NAME":"Rajus","ID":34},"qty":0,"price":0,"tot":0}],
          headerList:{"Item Name":"Item","Quantity":"qty","Price":"price","Total":"tot"},
          flex: [1,1,1,1,1],
          widList:[
            {'type':'search','future':call,'show':["NAME","-","ID"],'check':true},
            {'type':'txtFld','upd':Test,'check':false},
            {'type':'txtFld','upd':Test,'check':true},
            {'type':'txt'}
          ],
          onChange: (res){
            print(res);
          },
          action: true,
        ),
    );
  }
  Test(kv){
    if(double.tryParse(kv["qty"].toString())!=null && double.tryParse(kv["price"].toString())!=null) {
      print(kv);
      double qty = double.parse(kv["qty"].toString());
      double rate = double.parse(kv["price"].toString());
      double tot = qty*rate;
      kv["tot"]=tot.toStringAsFixed(2);
    }
    return kv;
  }
  call(val) async {
    var data = await Calls.search({"name":val});
    if(data["res"]){
      return data["data"];
    } else {
      return [];
    }
  }
*/
List<dynamic> formTxtFiledCntrlList = [];

class CurdForm extends StatefulWidget {
  const CurdForm({@required
                  this.headerList,
                  this.flex,
                  this.data,
                  this.widList,
                  this.onChange,
                  this.action=false
                });
  final Map<String,String> headerList; //{'ID':'id','Date':'date','Book':'title','Author':'name'},
  final List<int> flex; //[2,1,1,1]
  final List<Map<String,dynamic>> data; //[{'id':100,'title':'1s'},{'id':100,'title':'2s'}]
  final List<Map<String,dynamic>> widList; //[ {'type':'txt','flex':1}, {'type':'funTxt','flex':1,'fun':function} ]
  final Function(dynamic) onChange;
  final bool action;

  @override
  State<CurdForm> createState() => _CurdFormState();
}

class _CurdFormState extends State<CurdForm> {
  int idx = 0;int len = 0;
  List<String> headerValues,headerKeys = [];
  bool updTextFldCntrlBool = true;
  Map sendMap = {"res":false,"data":[]};

  @override
  Widget build(BuildContext context) {
    if(headerKeys.length==0) {
      headerKeys = widget.headerList.keys.toList();
      if(widget.action){
        headerKeys.add("Action");
      }
      headerValues = widget.headerList.values.toList();
    }
    len=widget.data.length;
    Widget Rows(rowMap){
      List<Widget> rows=[];
      idx = formTxtFiledCntrlList.length;
      formTxtFiledCntrlList.add({});
      for(var i=0;i<widget.widList.length;i++){
        var currKey = headerValues[i]; //"ID":"id" => "id"
        var Widgetype = widget.widList[i]["type"]; //txt/TxtFld/search
        int flex = widget.flex[i];
        if(Widgetype=="txt"){
          rows.add(Txt(flex,rowMap[currKey].toString()));
        } else if(Widgetype=="txtFld"){
          formTxtFiledCntrlList[idx][currKey] = TextEditingController();
          if(rowMap[currKey]!="" && rowMap[currKey]!=null){
            String txtFldData = rowMap[currKey].toString();
            formTxtFiledCntrlList[idx][currKey].text=txtFldData;
            formTxtFiledCntrlList[idx][currKey].selection = TextSelection(
                baseOffset: txtFldData.length,extentOffset: txtFldData.length);}
          rows.add(TxtFld(idx,flex,formTxtFiledCntrlList[idx][currKey],currKey,widget.widList[i]));
        } else if(Widgetype=="search"){
          List showKeyList = widget.widList[i]['show'];
          formTxtFiledCntrlList[idx][currKey] = TextEditingController();
          if(rowMap[currKey].length>0){
            String displayText="";
            for(var i = 0; i <showKeyList.length; i++){
              String displayKey = showKeyList[i];
              String val = rowMap[currKey][displayKey].toString();
              displayText = displayText + (val == "null" ? displayKey : val);
            }
            formTxtFiledCntrlList[idx][currKey].text=displayText;
          }
          rows.add(TxtSearch(idx,flex,widget.widList[i],formTxtFiledCntrlList[idx][currKey],currKey));
        }
      }
      if(widget.action){
        if(len==idx+1){
            var sendMap = widget.data[0];
            rows.add(addIcon(sendMap,idx));
        } else {
          rows.add(delIcon(idx));
        }
      }
      return Row(
        children: rows,
      );
    }
    return SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Row(
                children:[
                  for(var i=0;i<headerKeys.length;i++) headerKeys[i]=="Action" ? Container(
                      width: 100,
                      child: Center(
                        child: Text(headerKeys[i], style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    height: 30,
                    decoration: topLeft(Colors.transparent),
                  ) : Expanded(
                    flex: widget.flex[i],
                    child: Container(
                      child: Center(
                        child: Text(headerKeys[i], style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      height: 30,
                      decoration: topLeft(Colors.transparent),
                    ),
                  ),
                ],
              ),
              for(var rws in widget.data) Rows(rws)
           ],
          ),
          decoration: btmRight(),
        )
    );
  }
  Widget addIcon(rowMap,idx){
    return Container(
      height: 40,
      width: 100,
      decoration: btmRight(),
      child: ElevatedButton(
          onPressed:(){
            Map<String,dynamic> newMap = Map.from(rowMap); //Sample data {} taken
            var checkData = sendData();
            if(checkData["res"]){
              newMap.updateAll((key, value) => value=""); //creating blank data {}
              widget.data.add(newMap);
              formTxtFiledCntrlList =[];
              setState(()=>{});
            }
          },
          child: Text("Add"),
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
             ),
            ),
           );
  }
  Widget delIcon(idx){
    return Container(
      width: 100,
      height: 40,
      decoration: btmRight(),
      child: ElevatedButton(
        onPressed:() {
          widget.data.removeAt(idx);
          formTxtFiledCntrlList =[];
          setState(()=>{});
        },
        child: Text("Delete",),
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          primary: Colors.red
        ),
      ),
    );
  }
  Widget TxtSearch(idx,flex,widList,cntrler,currKey){
    var futureCall = widList['future'];
    var showList = widList['show'];
    String hintVal = "";
    var check = widList["check"];
    if(check!=null && check && cntrler.text==""){hintVal="required";}
    return Cell(flex,
        SearchField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left:5.0),
              hintText: hintVal,
              hintStyle: TextStyle(color: Colors.red[100])
            ),
            width: 700,
            controller: cntrler,
            showKeyList: showList,
            futureOrList: futureCall,
            onSelected:(val){
              if(val.length>0) {
                formTxtFiledCntrlList=[];
                widget.data[idx][currKey]=val; //Issue here | When select search values changing
              } else {
                formTxtFiledCntrlList=[];
                widget.data[idx][currKey]={};
              }
              setState(()=>{});
              widget.onChange(sendData());
            }
        ),Colors.transparent);
  }
  Widget TxtFld(idx,flex,cntrler,currKey,widDetails){
    String hintVal = "";
    var check = widDetails["check"];
    if(check!=null && check && cntrler.text==""){hintVal="required";}
    return Cell(flex,
        IntrinsicWidth(
          stepWidth:600,
          child:TextField(
              controller: cntrler,
              textAlign: TextAlign.center,
              decoration:InputDecoration(
                contentPadding:EdgeInsets.only(left: 3.0),
                hintText: hintVal,
                hintStyle: TextStyle(color: Colors.red[100])
              ),
             onChanged:(val){
               widget.data[idx][currKey]=val;
               if(widDetails.containsKey("upd")) {
                 widDetails["upd"](widget.data[idx]);
               }
               formTxtFiledCntrlList = [];
               setState(()=>{});
               widget.onChange(sendData());
             },
          ),
        ),
      Colors.transparent
    );
  }
  sendData(){
    List data=widget.data;
    List widLst = widget.widList;
    for(var i=0;i<widLst.length;i++){
       if(widLst[i].containsKey("check") && widLst[i]["check"]){
         for(var j=0;j<data.length;j++){
           var currData=data[j][headerValues[i]];
           if(widLst[i]["type"]=="txtFld" && (currData=="" || currData==0 || currData==null)){
             sendMap["res"]=false;
             sendMap["data"]=data;
             return sendMap;
           } else if(widLst[i]["type"]=="search" && currData.isEmpty){
             sendMap["res"]=false;
             sendMap["data"]=data;
             return sendMap;
           }
         }
       }
    }
    sendMap["res"]=true;
    sendMap["data"]=data;
    return sendMap;
  }
  Widget Txt(flex,val){
    String value = val == "null" ? "" : val;
    return Cell(flex,Text(value,textAlign: TextAlign.center),Colors.black12);
  }
  Widget Cell(flex,child,color){
    return Expanded(
      flex: flex ?? 1,
      child: Container(
          height: 40,
          child:Center(
            child: child,
          ),
          decoration: topLeft(color)
      ),
    );
  }
  Widget Action(child,color){
    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: Container(
          height: 40,
          child:Center(
            child: child,
          ),
          decoration: topLeft(color)
      ),
    );
  }
}

Decoration topLeft(color){
  return BoxDecoration(
    color: color,
    border: Border(
      left: BorderSide(
          width: 1,
          color: Colors.black26
      ),
      top: BorderSide(
          width: 1,
          color: Colors.black26
      ),
    ),
  );
}
Decoration btmRight(){
  return const BoxDecoration(
    border: Border(
        bottom: BorderSide(
            width: 1,
            color: Colors.black26
        ),
        right: BorderSide(
            width: 1,
            color: Colors.black26
        )
    ),
  );
}

// return IconButton(
//     onPressed: () {
//       widget.data.removeAt(idx);
//       formTxtFiledCntrlList =[];
//       setState(()=>{});
//     },
//     icon: Icon(Icons.delete, color: Colors.red,size: 20,));
