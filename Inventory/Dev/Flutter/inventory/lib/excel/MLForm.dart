import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../excel/MLConstants.dart';

//https://segmentfault.com/a/1190000040974138/en

class MLForm extends StatefulWidget {
  const MLForm({@required this.dataType,this.subNums,this.maxCols,this.future,this.isSubmit});
  final dynamic dataType;
  final int maxCols;
  final int subNums;
  final Future future;
  final Function(dynamic) isSubmit;

  @override
  State<MLForm> createState() => _MLFormState();
}

class _MLFormState extends State<MLForm> {
  ScrollController _scrollController = ScrollController(initialScrollOffset: 0);
  Map<String,List> dataKeyLstMap = {};//{"MAIN":["ID","NAME"]}
  Map<String,int> keySubLvlMap = {};//{"MAIN":1,"ITEM":2}
  Map<String,List> hdrColLstMap = {};//{"MAIN":["ORD ID","Full Name"]}
  List<double> widthList=[];
  List subLvlKeyList = [];
  int subLevel = 0;

  Size _textSize(String text) {//get String width
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: TextStyle(color:Colors.black,fontWeight:FontWeight.w500)), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth:0,maxWidth: double.infinity);
    return textPainter.size; //height = 15
  }

  loopSubs(subMap,subKey,ListDataObjs,z) {//dataTypes["SUB"],"MAIN",[widget.data]
    Map metaMap = subMap[subKey];
    String curHdr = subMap["COLS"][0];
    List columns = metaMap["COL"];
    if(z==0 && !dataKeyLstMap.containsKey(subKey)) {
      List headers = metaMap["HDR"];
      dataKeyLstMap[subKey]=columns;
      hdrColLstMap[subKey]=headers;
      if(!subLvlKeyList.contains(curHdr)) {
        subLvlKeyList.add(curHdr);
        subLevel = subLvlKeyList.length-1;//levels -> 1st -0, 2nd from 1, 3rd from 2
        for(var i=0;i<headers.length;i++) { //Header List Length Setting
          double dataLen = _textSize(headers[i]).width;
          if(widthList[i+subLevel]<dataLen) {
            widthList[i+subLevel] = dataLen;
          }
        }
      }
      keySubLvlMap[subKey]=subLevel;
    }
    subLevel = subLvlKeyList.indexOf(curHdr);
    int ldoLen = ListDataObjs.length;
    for(var k=0;k<ldoLen;k++) { //{"ID":2,"Qty":34}
      for(var j=0;j<columns.length;j++) {//ID/Qty/Gst
        String columnName = columns[j];
        String eachData = ListDataObjs[k][columnName].toString();
        double dataLen = _textSize(eachData).width;
        if(widthList[j+subLevel]<dataLen) {
          widthList[j+subLevel] = dataLen;
        }
      }
      var isSub = metaMap["SUB"];
      if(isSub!=null) {
        List subCols = isSub["COLS"];
        for(var l=0;l<subCols.length;l++) { //Main/Item/Pur/Wage
          loopSubs(isSub,subCols[l],ListDataObjs[k][subCols[l]],z);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widthList=List.filled(widget.maxCols+widget.subNums+2,50);

    return FutureBuilder(builder: (ctx, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if(snapshot.hasData) {
          List<bool> submitLst = [false];
           List<dynamic> data = snapshot.data["data"];
           for(var z=0;z<data.length;z++) {
             submitLst.add(false);
             if(!data[z].containsKey("del")){data[z]["del"]={};}
             loopSubs(widget.dataType["SUB"],"MAIN",[data[z]],z);
           }
           Map<String,dynamic> blankRow = MapChangeCntrl.newMap(data[0]);
           data.insert(0,blankRow);

           return Container(
               child: Scrollbar(
                   thumbVisibility: true,
                   thickness: 15,
                   controller: _scrollController,
                   child: ScrollConfiguration(
                       behavior: ScrollConfiguration.of(context)
                           .copyWith(
                           dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}
                       ),
                       child: SingleChildScrollView(
                           controller: _scrollController,
                           scrollDirection: Axis.horizontal,
                           child: Container (
                             padding: EdgeInsets.all(10),
                             child: Column (
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 for(var z=0;z<data.length;z++) SingleChildScrollView (
                                   child: MLMap(data[z],Map<String,dynamic>.from(widget.dataType),
                                     dataKeyLstMap: dataKeyLstMap,
                                     subLvlKeyList: subLvlKeyList,
                                     widthList: widthList,
                                     keySubLvlMap: keySubLvlMap,
                                     hdrColLstMap: hdrColLstMap,
                                     z:z,
                                     hasChanged:(change) {
                                       if(change["submit"]) {
                                         widget.isSubmit(change);
                                       } else {
                                         int z = change["z"];
                                         bool check = false;
                                         for(var i=0;i<submitLst.length;i++){
                                           if(i!=z && submitLst[i]==true){
                                             check=true;
                                           }
                                         }
                                         if(check){
                                           showDialog(context: context, builder: (context) => AlertDialog(
                                             title: Text("SUBMIT OLD CHANGES",style: TextStyle(color: Colors.red),),
                                             content: Text("More than 1 [SUBMITS] Available to be SUBMITTED!!"),
                                             actions: [
                                               TextButton(onPressed:() => Navigator.pop(context), child: Text("Ok")),
                                             ],
                                            )
                                           );
                                         }
                                         submitLst[z]=true;
                                       }
                                     },
                                   ),
                                 )
                               ],
                             ),
                           )
                       )
                   )
               )
           );
        }
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator(),);
      }
      return const Center(child:Text("No Records Received from Server",style: TextStyle(color: Colors.red,fontSize: 20),));
     },
    future: widget.future,
    );
  }
}

class MLMap extends StatefulWidget {
  MLMap(this.dataMap,this.dataType,{@required this.dataKeyLstMap,this.subLvlKeyList,this.widthList,this.hasChanged,
        this.hdrColLstMap,this.keySubLvlMap,this.z});
  Map<String,dynamic> dataMap;
  final Map<String,dynamic> dataType;
  final Map<String,List> dataKeyLstMap;
  final Map<String,int> keySubLvlMap;
  final Map<String,List> hdrColLstMap;
  final List<double> widthList;
  final List subLvlKeyList;
  final Function(dynamic) hasChanged;
  final int z;

  @override
  State<MLMap> createState() => _MLMapState();
}

class _MLMapState extends State<MLMap> {
  String prevCurHdr="";
  int subLvlLen=0;int vsbCntrl=-1;int x=0;
  bool isNewMap = false;
  bool isSubmit=false;
  bool isExpand=false;
  bool isFirstSubLvl=true;
  Map<String,List> idxKeyLstMap={};//{0:[],1:["ITEM",0]}
  List idxList = [];//["ITEM",0,"WAGE",1]
  List<bool> vsbBoolList=[];
  List<Widget> mainVsbltyWidList=[];
  List<Widget> tempVsbltyHdrDataList=[];//sub temp visibility children
  List<Widget> vsbltyWidList=[];//vsbltyWidList=[HDR,DATA,vsbltyWid(HDR,DATA,vsbltyWid(HDR,DATA)),vsbltyWid(HDR,DATA,vsbltyWid(HDR,DATA))]
  setInit(){prevCurHdr="";x=0;isFirstSubLvl=true;vsbCntrl=-1;idxKeyLstMap={};idxList=[];
            mainVsbltyWidList=[];tempVsbltyHdrDataList=[];vsbltyWidList=[];}

  expSubFun(type) {
    if(type=="Expand") {
      int len=vsbBoolList.length;
      if(isExpand) {
        vsbBoolList.fillRange(0,len,false);isExpand=!isExpand;
      } else {
        vsbBoolList.fillRange(0,len,true);isExpand=!isExpand;
      } setInit();setState(()=>{});
    } else { //submit
      Map returnMap = {"submit":true,"data":widget.dataMap};
      widget.hasChanged(returnMap);
    }
  }
  onChange(kv) {
    if(kv["typ"]=="upd" || kv["typ"]=="srch" || kv["typ"]=="date"){//update only - no set State
      String xKey = kv["idx"]["x"];
      int yKey = kv["idx"]["y"];
      List keyList = idxKeyLstMap[xKey];
      int keyListLen = keyList.length;
      String subKey = xKey == "1" ? "MAIN" : keyList[keyListLen-2];
      String colNm = widget.dataKeyLstMap[subKey][yKey];
      widget.dataMap=MapChangeCntrl.updData(widget.dataMap,keyList,keyListLen,colNm,kv["data"]);
      isSubmit=true;
      widget.hasChanged({"submit":false,"z":widget.z});
      setInit();
      setState(()=>{});
    } else if(kv["typ"]=="updClbk") {
      String xKey = kv["idx"]["x"];
      int yKey = kv["idx"]["y"];
      List keyList = idxKeyLstMap[xKey];
      int keyListLen = keyList.length;
      String subKey = xKey == "1" ? "MAIN" : keyList[keyListLen-2];
      String colNm = widget.dataKeyLstMap[subKey][yKey];
      widget.dataMap=MapChangeCntrl.updData(widget.dataMap,keyList,keyListLen,colNm,kv["data"]);
      Map returnMap = MapChangeCntrl.getData(widget.dataMap,kv["fun"]["getback"],widget.dataKeyLstMap,widget.keySubLvlMap,keyList);
      returnMap["id"]=xKey+yKey.toString();
      var getResults = kv["fun"]["callback"](returnMap); //{MAIN: {Total: 2530}, ITEMS: {Total: 1 650}, PUR: {Rate: 7, Used: 0}, id: 42}
      widget.dataMap = MapChangeCntrl.setData(widget.dataMap,getResults,widget.dataKeyLstMap,widget.keySubLvlMap,keyList);
      isSubmit=true;
      widget.hasChanged({"submit":false,"z":widget.z});
      setInit();
      setState(()=>{});
    } else if(kv["typ"]=="srchClbk") {
      String xKey = kv["idx"]["x"];
      int yKey = kv["idx"]["y"];
      List keyList = idxKeyLstMap[xKey];
      int keyListLen = keyList.length;
      String subKey = xKey == "1" ? "MAIN" : keyList[keyListLen-2];
      String colNm = widget.dataKeyLstMap[subKey][yKey];
      widget.dataMap=MapChangeCntrl.updData(widget.dataMap,keyList,keyListLen,colNm,kv["data"]);
      Map returnMap = MapChangeCntrl.getData(widget.dataMap,kv["fun"]["getback"],widget.dataKeyLstMap,widget.keySubLvlMap,keyList);
      returnMap["id"]={"sid":xKey+yKey.toString(),"sobj":kv["obj"]};
      var getResults = kv["fun"]["callback"](returnMap); //{MAIN: {Total: 2530}, ITEMS: {Total: 1 650}, PUR: {Rate: 7, Used: 0}, id: 42}
      widget.dataMap = MapChangeCntrl.setData(widget.dataMap,getResults,widget.dataKeyLstMap,widget.keySubLvlMap,keyList);
      isSubmit=true;
      widget.hasChanged({"submit":false,"z":widget.z});
      setInit();
      setState(()=>{});
    } else if(kv["typ"]=="e") {
      int idx = kv["idx"];
      vsbBoolList[idx]=!vsbBoolList[idx];
      setInit();
      setState(()=>{});
    } else if(kv["typ"]=="del") { //{typ: new, idx: {x:7, z: 0}}
      showDialog(
          context: context, builder: (context) => AlertDialog(
            title: Text("Confirm Delete"),
            content: Text("Confirm again before deleting the record"),
            actions: [
              TextButton(onPressed:() => Navigator.pop(context), child: Text("Cancel")),
              TextButton(onPressed:() {
                String key = kv["idx"]["x"];
                List keyList = idxKeyLstMap[key];
                widget.dataMap=MapChangeCntrl.delData(widget.dataMap,keyList,keyList.length);
                isSubmit=true;
                widget.hasChanged({"submit":false,"z":widget.z});
                setInit();
                setState(()=>{});
                Navigator.pop(context);
              }, child: Text("Delete"))
            ],
          )
      );
    } else if(kv["typ"]=="new") {
      String key = kv["idx"]["x"];
      List keyList = idxKeyLstMap[key];
      widget.dataMap=MapChangeCntrl.addData(widget.dataMap,keyList,keyList.length);
      setInit();
      setState(()=>{});
    }
  }
  //Expand widget logic function's 3
  Widget vsbltyWid(List<Widget> cols,bool isVisible) {
    //print("Added data here widget count => " + cols.length.toString());
    return Visibility(
        visible: isVisible,
        child: Column(
          children: cols,
        )
    );
  }
  addToVsblWid() {
    //print("VsbWidList + visibility Widget with temporary. VsbCntrl# :" + vsbCntrl.toString() + " & List: " + isVsbBoolLst.toString());
    vsbltyWidList.add(vsbltyWid(tempVsbltyHdrDataList,vsbBoolList[vsbCntrl]));
  }
  vsbCntrlLstAdd() {
    vsbCntrl=vsbCntrl+1;
    if(vsbBoolList.length<=vsbCntrl) {
      vsbBoolList.add(false);
    }
    //print("VsbCntrl++ " + vsbCntrl.toString() + " List: " + isVsbBoolLst.toString());
  }
  //MLRow and MLDrs Makings
  addMainHDR(subLevel,subKey,dataRow,hdrColList,functionLst,typeLst) {//first record idx=0, vsbCntrl=0
    vsbCntrlLstAdd();//first record added here
    //print("Cntrl#: " + vsbCntrl.toString() + " List: " + isVsbBoolLst.toString());
    mainVsbltyWidList.add(MLHdrRow(widget.widthList,hdrColList,subLevel,isSubmit:isSubmit,
      isExpand:isExpand,onSubExp:expSubFun));
    mainVsbltyWidList.add(MLRow(widthList:widget.widthList,dataRow:dataRow,idx:{"x":x.toString()},
      functionLst:functionLst,typeLst:typeLst,seq:subLevel,isExp:true,options:{"idx":vsbCntrl,"onClick":onChange,"bool":vsbBoolList[vsbCntrl]},));
  }
  //Hdr Rows
  mkHdrRow(hdrColList,subLevel) {
    //print("--Header :" + hdrColList[1]);
    return MLHdrRow(widget.widthList,hdrColList,subLevel);
  }
  //Data Rows
  mkDataRow(subLevel,dataRow,k,kLen,{@required isExp=false,isNew,options,functionLst,typeLst}) {
    if(k>0 && k==kLen){ //k>0 Delete | k Last Insert | Else Both
      return MLRow(widthList:widget.widthList,dataRow:dataRow,isExp:isExp,isDel:true,isIns:true,isNew:isNew,functionLst:functionLst,typeLst:typeLst,
        seq:subLevel,options:options,idx:{"x":x.toString()});
    } else if(k>0) {//{"idx":vsbCntrl,"onClick":expDelInsClick,"bool":isVsbBoolLst[vsbCntrl]}
      return MLRow(widthList:widget.widthList,dataRow:dataRow,isExp:isExp,isDel:true,functionLst:functionLst,typeLst:typeLst,
        seq:subLevel,options:options,idx:{"x":x.toString(),});
    } else if(k==0 && kLen==0) { //new
      return MLRow(widthList:widget.widthList,dataRow:dataRow,isExp:isExp,isIns:true,isNew:isNew,functionLst:functionLst,typeLst:typeLst,
        seq:subLevel,options:options,idx:{"x":x.toString()});
    } else {
      return MLRow(widthList:widget.widthList,dataRow:dataRow,isExp:isExp,functionLst:functionLst,typeLst:typeLst,
          seq:subLevel,options:options,idx:{"x":x.toString()});
    }
  }
  //Data row generator
  getDataRwLst(dataKeyList,ListDataObj,subKey) { List<String> dataRow=[];
    for(var i=0;i<dataKeyList.length;i++) {
      String curKey = dataKeyList[i];
      dataRow.add(ListDataObj[curKey].toString());
    }
    x=x+1;//index of each Row
    return dataRow;
  }
  //print("========" + prevSubKey + "::" + subKey + "===========");
  //print("k: "+ k.toString() + " | SubLevel: " + subLevel.toString() + " | x: " + x.toString());

  loopSubs(subMap,subKey,ListDataObjs,isLstSub) {
    String curHdr = subMap["COLS"][0];
    List functionLst = subMap[subKey]["FUN"];
    List typeLst = subMap[subKey]["TYPE"];
    int subLevel = widget.subLvlKeyList.indexOf(curHdr);
    List<String> dataKeyList = widget.dataKeyLstMap[subKey];
    int ldoLen = ListDataObjs.length-1;
    //print("========" + prevCurHdr + "::" + curHdr + "===========");
    for(var k=0;k<=ldoLen;k++) { //[{ID:1},{ID:2}]
      var isNew=null;
      if(subMap[subKey].containsKey("NEW")){isNew=subMap[subKey]["NEW"];}
      //=====index creation=====
      if(subLevel==1) {
        idxList=[];idxList.addAll([subKey,k]);
      } else if(subLevel==2) {
        idxList.length==4 ? idxList.replaceRange(2,4,[subKey,k]) : idxList.addAll([subKey,k]);
      }
      //=====Data Flow=====
      List dataRw = getDataRwLst(dataKeyList,ListDataObjs[k],subKey);
      List hdrColList = widget.hdrColLstMap[subKey];
      idxKeyLstMap[x.toString()]=List.from(idxList);
      //=====Visibility Control=====
      if(prevCurHdr!=curHdr) {
        if(subLevel==0) {
          addMainHDR(subLevel,subKey,dataRw,hdrColList,functionLst,typeLst);
          //print("##Added to Main Widget List");
          //print("Adding to Main Widget List then Visible widgets");
        } else if (subLevel==1 && isFirstSubLvl) { //first time only
          //print("First time adding to Visible Widget List - No Visible Widget Added Here");
          isFirstSubLvl=false;
          vsbCntrlLstAdd();
          Map<String,dynamic> options = {"idx":vsbCntrl,"onClick":onChange,"bool":vsbBoolList[vsbCntrl]};
          vsbltyWidList.add(mkHdrRow(hdrColList,subLevel));
          vsbltyWidList.add(mkDataRow(subLevel,dataRw,k,ldoLen,isExp:true,isNew:isNew,options:options,functionLst:functionLst,typeLst:typeLst));
          //print("##Added to vsbWidList");
        } else if (subLevel==1) {
          //print("Second time onwards adding to Visible Widget List - Before Visible Widget");
          addToVsblWid();
          vsbCntrlLstAdd();
          Map<String,dynamic> options = {"idx":vsbCntrl,"onClick":onChange,"bool":vsbBoolList[vsbCntrl]};
          tempVsbltyHdrDataList=[];
          //print("Temp List cleared");
          vsbltyWidList.add(mkHdrRow(hdrColList,subLevel));
          vsbltyWidList.add(mkDataRow(subLevel,dataRw,k,ldoLen,isExp:true,isNew:isNew,options:options,functionLst:functionLst,typeLst:typeLst));
          //print("##Added to vsbWidList");
        } else {
          //print("Keep Adding to Temp List 1");
          Map<String,dynamic> options = {"onClick":onChange};
          tempVsbltyHdrDataList.add(mkHdrRow(hdrColList,subLevel));
          tempVsbltyHdrDataList.add(mkDataRow(subLevel,dataRw,k,ldoLen,isExp:false,isNew:isNew,options:options,functionLst:functionLst,typeLst:typeLst));
          //print("##Added to TempList");
        }
      } else {
        if(isLstSub && k==ldoLen) { //The Last record print("=====The Last record");
          //print("Last time adding to Visible Widget List - Before Visible Widget");
          Map<String,dynamic> options = {"onClick":onChange};
          addToVsblWid();
          tempVsbltyHdrDataList.add(mkHdrRow(hdrColList,subLevel));
          tempVsbltyHdrDataList.add(mkDataRow(subLevel,dataRw,k,ldoLen,isExp:false,isNew:isNew,options:options,functionLst:functionLst,typeLst:typeLst));
          tempVsbltyHdrDataList=[];
          //print("##Added to vsbWidList & TempList");
          //print("Temp List cleared");
        } else {
          //print("Keep Adding to Temp List 2");
          Map<String,dynamic> options = {"onClick":onChange};
          tempVsbltyHdrDataList.add(mkHdrRow(hdrColList,subLevel));
          tempVsbltyHdrDataList.add(mkDataRow(subLevel,dataRw,k,ldoLen,isExp:false,isNew:isNew,options:options,functionLst:functionLst,typeLst:typeLst));
          //print("##Added to TempList");
        }
      }
      prevCurHdr=curHdr;//MAIN,ITEMS,PUR
      //=====If Sub Loop Again=====
      var isSub = subMap[subKey]["SUB"];
      if(isSub!=null) {
        List subCols = isSub["COLS"];
        int len = subCols.length;
        for(var l=0;l<subCols.length;l++) { //Main/Item/Pur/Wage
          if(l==len-1 && subLevel==1 && k==ldoLen) { //Last record
            loopSubs(isSub,subCols[l],ListDataObjs[k][subCols[l]],true);
          } else {//All other records
            loopSubs(isSub,subCols[l],ListDataObjs[k][subCols[l]],false);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    subLvlLen =  widget.subLvlKeyList.length;
    List<Map<String,dynamic>> dataMap = [widget.dataMap];
    loopSubs(widget.dataType["SUB"],"MAIN",dataMap,true);
    mainVsbltyWidList.add(Visibility(visible:vsbBoolList[0],child:Column(children:vsbltyWidList,)));
    //mainWidList=[HDR,MAIN,Visibility([vsbltyWid(HDR,DATA,vsbltyWid(HDR,DATA)), vsbltyWid(HDR,DATA,vsbltyWid(HDR,DATA))])]

    return widget.z==0 ? Visibility(
      child: mlMapWid(),
      replacement: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          SizedBox(
            height: 50,
            width: widget.widthList.reduce((a, b) => a + (b*widthPercentage) + 1) - 50,
          ),
          ElevatedButton(
            child: Text("New"),
            onPressed: () {
              isNewMap=true;
              setInit();
              setState(()=>{});
            },
          ),
        ],
      ),
      visible: isNewMap,
    ) : mlMapWid();
  }

  Widget mlMapWid(){
    return Container(
        margin: EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 1,
              //color: Colors.black26
            ),
          ),
        ),
        child:Column(
          children: mainVsbltyWidList,
        )
    );
  }
}

class MLRow extends StatelessWidget {
  const MLRow({@required this.widthList,this.dataRow,this.seq,this.options,this.idx,this.functionLst,this.typeLst,
                         this.isDel=false,this.isExp=false,this.isIns=false,this.isNew});
  final Function isNew;
  final List<double> widthList;
  final List<String> dataRow;
  final List<String> typeLst;
  final List<dynamic> functionLst;
  final Map<String,dynamic> options;//{"typ":"i-insert","xyz":023},{"typ":"d-delete","xyz":023},{"typ":"e-exapnd","idx":0},{"typ":"b"-blank"}
  final Map<String,dynamic> idx;//{"x","y","z","id"}
  final int seq;//first data 0, second 1, third 2 like wise sequence
  final bool isDel;
  final bool isIns;
  final bool isExp;

  Widget data(i,wid,padLeft) {
    return Container(
      padding: EdgeInsets.only(left: padLeft),
      decoration: BoxDecoration(
        border: Border(
            right: BorderSide(
                width: 1,
                color: Colors.black12
            )
        ),
      ),
      height: 20,
      width: widthList[i] * widthPercentage,
      child: wid,
    );
  }
  txtStyle(){return TextStyle(fontSize: 14);}
  List<Widget> rows() {
    List<Widget> row = [];
    int widthLen = widthList.length;
    int dataLen = dataRow.length;
    for(var i=0;i<seq;i++) {
      row.add(MLCell("","null",widthList[i]));
    }
    for(var j=seq;j<widthLen;j++) {
      int curr = j-seq;
      if(curr<dataLen) {
        Map newOptions = Map.from(options);
        newOptions["fun"]=functionLst[curr];
        Map newIdx = Map<String,dynamic>.from(idx);
        newIdx["y"]=curr;
        row.add(MLCell(dataRow[curr],typeLst[curr],widthList[j],idx:newIdx,options:newOptions,));
      } else if(j==widthLen-3 && isDel) {
        row.add(MLCell("","del",widthList[j],options:options,idx:idx));
      } else if(j==widthLen-2 && isIns) {
        row.add(MLCell("","new",widthList[j],options:options,idx:idx,isNew:isNew,));
      } else if(j==widthLen-1 && isExp) {
        row.add(MLCell("","open",widthList[j],options:options,));
      } else { row.add(MLCell("","null",widthList[j])); }
    }
    return row;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children:rows(),
    );
  }
}

class MLCell extends StatefulWidget {
  const MLCell(this.data,this.type,this.width,{@required this.options,this.idx,this.isNew});
  final String data;
  final String type;
  final dynamic options;
  final double width;
  final Function isNew;
  final Map<String,dynamic> idx;

  @override
  State<MLCell> createState() => _MLCellState();
}

class _MLCellState extends State<MLCell> {
  Widget child;
  dynamic options;
  Widget TxtFld() {
    TextEditingController controller = TextEditingController();
    if (controller.text=="") {
      controller.text=widget.data;
      controller.selection=TextSelection.collapsed(offset: controller.text.length);
    }
    child = TextField(
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 2, bottom: 18),
      ),
      controller:controller,
      onChanged:(val){
        if(val!= "" && val!=widget.data){ //widget.data
          if(options["fun"].isNotEmpty){
            options["onClick"]({"typ":"updClbk","idx":widget.idx,"fun":options["fun"],"data":val});
          } else {
            options["onClick"]({"typ":"upd","idx":widget.idx,"data":val});
          }
        }
      },
    );
  }
  Widget TxtSearch() {//Search Text
    TextEditingController cntrler = TextEditingController();
    cntrler.text=widget.data;
    var futureCall = options['fun']['future'];
    var showList = options['fun']['show'];
    child = CellSearch(
        controller: cntrler,
        showKeyList: showList,
        futureOrList: futureCall,
        onSelected:(val) {
          if(val!="") {
            if(options['fun'].containsKey("new")) {
              String key = options['fun']['new']["key"];
              String value = options['fun']['new']["val"];
              String srchVal = val[key];
              int idxVal = srchVal.indexOf(value)-1;
              if(srchVal.contains(value)) {
                options['fun']['new']["call"](val[key].substring(0,idxVal));
                cntrler.text="";
              }
            } else if(options['fun'].containsKey("callback")) {
              options["onClick"]({"typ":"srchClbk","idx":widget.idx,"fun":options["fun"],"obj":val,"data":cntrler.text});
            } else {
              options["onClick"]({"typ":"srch","idx":widget.idx,"obj":val,"data":cntrler.text});
            }
          }
        }
    );
  }
  Widget TxtDate() {
    TextEditingController controller = TextEditingController();
    if (controller.text == "") { controller.text = widget.data; }
    child = TextField(
      inputFormatters:[DateFormatter()],
      style: TextStyle(color:Colors.black,fontWeight:FontWeight.w500),
      decoration: InputDecoration(
          label:Padding(
            padding: EdgeInsets.only(left:2,top:10),
            child: Text("2050-01-31",//Hint Showing
              style: TextStyle(fontSize:21,fontWeight:FontWeight.w500,color:Colors.black12),),),
          contentPadding: EdgeInsets.only(left:2,bottom: 14),
          floatingLabelBehavior: FloatingLabelBehavior.always
      ),
      controller:controller,
      onChanged:(val) {
        if(val.length==10) {
          options["onClick"]({"typ":"date","idx":widget.idx,"data":val});
        }
      },
    );
  }
  Widget Txt(){
    child = Container(
      padding: const EdgeInsets.only(top: 6.0,left: 2),
      decoration: BoxDecoration(border: Border(bottom:BorderSide(width:1,color:Colors.black26)),color: Colors.grey[200]),
      child: Text(widget.data.toString(),textAlign: TextAlign.left,//widget.data
        style: TextStyle(color: Colors.black,fontWeight:FontWeight.w500,fontSize:16),),
    );
  }
  Widget ExpandIcon() {
    IconData icon;
    Color color;
    if(options["bool"]){ //vsbList[sublevel] = true/false
      icon = Icons.keyboard_arrow_up;
      color = Colors.purple;
    } else {
      icon = Icons.keyboard_arrow_down;
      color = Colors.teal;
    }
    child = IconButton(
        padding: EdgeInsets.only(bottom: 2),
        onPressed:(){
          options["onClick"]({"typ":"e","idx":options["idx"]});
        },
        icon:Icon(icon, color: color,size: 20,)
    );
  }
  Widget NewDel(txt,type,btnColor,txtColor){
    child = Padding(
      padding: const EdgeInsets.all(3.0),
      child: ElevatedButton(
        onPressed:(){
          if(widget.isNew!=null){
            widget.isNew();
          } else {
            options["onClick"]({"typ":type,"idx":widget.idx});
          }
        },child:Center(child: Text(txt,style:TextStyle(color:txtColor,fontSize: 12),)),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            primary:btnColor
        ),
      ),
    );
  }
  Widget Blank() {
    child = TextField(
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 2, bottom: 18),
      ),
      controller:TextEditingController(),
    );
  }
  @override
  Widget build(BuildContext context) {
    String type = widget.type;
    options = widget.options;
    if(type=="txtFld") {
      TxtFld();
    } else if(type=="txt") {
      Txt();
    } else if(type=="null") {
      Blank();
    } else if(type=="search") {
      TxtSearch();
    } else if(type=="date") {
      TxtDate();
    } else if(type=="open") {
      ExpandIcon();
    } else if(type=="new") {
      NewDel("New",type,Colors.grey,Colors.white);
    } else if(type=="del") {
      NewDel("Delete",type,Colors.grey,Colors.pink);
    }
    return Container(
      width: widget.width * widthPercentage,
      height: 28,
      decoration: btmRight,
      child: child,
    );
  }
}

class MLHdrRow extends StatelessWidget {
  const MLHdrRow(this.widthList,this.headers,this.seq,{@required this.isSubmit=false,this.isExpand,this.onSubExp});
  final List<double> widthList;
  final Function(String) onSubExp; //"s-Submit","e-Expand"
  final List<String> headers;
  final int seq;
  final bool isExpand;
  final bool isSubmit;

  Widget hdr(i,wid,padLeft) {
    Color hdrColor;
    if(seq==0){hdrColor=Colors.black;} else if(seq==1){hdrColor=Colors.blue[900];} else {hdrColor=Colors.blueGrey;}
    return Container(
      padding: EdgeInsets.only(left: padLeft),
      decoration: BoxDecoration(
        color: hdrColor,//Colors.blue[900]
        border: Border(
            right: BorderSide(
                width: 1,
                color: Colors.black12
            )
        ),
      ),
      height: 20,
      width: widthList[i] * widthPercentage,
      child: wid,
    );
  }
  Widget button(j,btnName,txtColor,btnColor,option){
    return SizedBox(
      width: widthList[j] * widthPercentage,
      height: 20,
      child: TextButton(
        child: Text(btnName,style: TextStyle(fontSize:14),),
        style: TextButton.styleFrom(
            primary:txtColor,
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            backgroundColor:btnColor),
        onPressed:() {
          onSubExp(btnName);
        },
      ),
    );
  }

  List<Widget> rows() {
    List<Widget> row = [];
    int widthLen = widthList.length;
    int hdrLen = headers.length;
    for(var i=0;i<seq;i++) {
      row.add(hdr(i,Text("",style:hdrTxtStyle,),0.0));
    }
    for(var j=seq;j<widthLen;j++) {
      int curr = j-seq;
      if(curr<hdrLen) {
        row.add(hdr(j,Text(headers[curr],style:hdrTxtStyle,),0.5));
      } else if(j==widthLen-3) {
        row.add(hdr(j,Text(" Action",style:hdrTxtStyle,),0.0));
      } else if(j==widthLen-2) {
        if(isSubmit){ row.add(button(j,"Submit",Colors.white,Colors.red,"s"));}
        else {row.add(hdr(j,Text(" Action",style:hdrTxtStyle,),0.0));}
      } else if(j==widthLen-1) {
        if(isExpand!=null){ row.add(button(j,"Expand",Colors.white,isExpand ? Colors.purple : Colors.teal,"e")); }
        else {row.add(hdr(j, Text(" Action",style:hdrTxtStyle,),0.0));}
      } else {
        row.add(hdr(j,Text("",style:hdrTxtStyle,),0.0));
      }
    }
    return row;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children:rows()
    );
  }
}

