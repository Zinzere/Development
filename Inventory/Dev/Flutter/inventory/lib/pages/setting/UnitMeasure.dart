import 'package:flutter/material.dart';
import '../../ui/AllUi.dart';
import '../../api/Calls.dart';

class UnitMeasure extends StatefulWidget {
  UnitMeasure(this.settingsData);
  var settingsData;
  @override
  State<UnitMeasure> createState() => _UnitMeasureState();
}

class _UnitMeasureState extends State<UnitMeasure> {
  TextEditingController newUnitsController = TextEditingController();
  TextEditingController unitNameCntrl = TextEditingController();
  TextEditingController unitCalcCntrl = TextEditingController();
  List<TextEditingController> unitValList = [];
  Color celColor = Colors.black26;
  Future _future;
  bool refreshTable = false;
  bool newInsert = false;
  List mainUnitList = [];
  List unitTypes = [];
  List dataList = [];
  String selected = "Mass (Weight)";
  String compareUnit = "";
  String warning ="";

  @override
  initState(){
    _future = Calls.getMstUnits();
    unitTypes = widget.settingsData.where((kv)=> kv["TYPE"]=="Units").toList();
  }

  Widget addNew() {
    return SizedBox(
      width: 150,
      child: TextButton(
        onPressed: () => showDialogueBox(),
        child: Row(
          children: [
            Icon(Icons.add_box,size: 12, color: Colors.blue,),Text(" Add New Row", style: TextStyle(color: Colors.blue,fontSize: 12),)
          ],
        ),
      ),
    );
  }

  showDialogueBox(){//Popup dialogue to add new Unit comes here
    Popup(
      title: "Add Records here",
      ctx: context,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Tables(
                      headers:["Unit Name", "Unit Calculation", "Unit Type"],
                      flex: [2, 3, 2],
                      children: [
                        TRow([
                          Cell(child: TFFlex(TFPlain(
                            focus: true,
                            cntrolr: unitNameCntrl,
                            txtAlign: TextAlign.center,
                          ),),),
                          Cell(child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TFFlex(TFPlain(cntrolr: unitCalcCntrl,
                                txtAlign: TextAlign.center,),),
                              Text(compareUnit + " units"),
                              RSpace()
                            ],
                          ),),
                          Cell(
                            child: DropDown(
                              onSelected: (val) {
                                mainUnitList.forEach((elm) {
                                  if (elm["TYPE_ID"] == val["ID"]) {
                                    compareUnit = elm["UNIT"];
                                  }
                                });
                                setState(() => {});
                              },
                              selected: selected,
                              showKey: "NAME",
                              kvList: unitTypes,
                            ),
                          ),
                        ])
                      ]
                  ),
                  CSpace(),
                  ElevatedButton(
                      onPressed: () => insRow(), child: Text("Add New Unit")
                  )
                ],
              ),
            );
          }
      ),
    );
  }
//Each Row consists of Icon,Text, (TxtField/Txt/txtButton), Text created below
  Widget eachRow(kv) {
    unitValList.add(TextEditingController());
    unitValList[unitValList.length-1].text = kv["UNIT_CALC"].toString();
    String showMainUnit = "";
    mainUnitList.forEach((elm) {
      if(elm["TYPE_ID"]==kv["TYPE_ID"]) {
        showMainUnit=elm["UNIT"];
      }
    });
    return TRow([
      Cell(
          icon:kv["ACTV_UNIT"]==1? Icons.check_box : Icons.check_box_outline_blank,
          iconPress: () => updateFlag(kv["ID"],kv)
      ),
      Cell(txt:kv["UNIT"]),
      Cell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TFFlex(TFSQuare(
                cntrolr: unitValList[unitValList.length-1],
                txtAlign: TextAlign.center,
                onChanged: (val) {
                  print(kv["ID"].toString() + val);
                },
              ), width: 60,),
              Text(" " + showMainUnit + " units  "),
              TextButton(
                  onPressed:(){},
                  child: Text("Update"))
            ],
          )
      ),
      Cell(txt:getType(kv["TYPE_ID"]),),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Futures(
      refresh: refreshTable,
      child: (data){
        unitValList = [];
        mainUnitList = [];
        dataList = data;
        dataList.forEach((elm){
          if(elm["ACTV_UNIT"]==1) {
            mainUnitList.add({"UNIT":elm["UNIT"],"TYPE_ID":elm["TYPE_ID"]});
          }
        });
        compareUnit = mainUnitList[0]["UNIT"];
        return SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text("Units of Measurements",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                CSpace(),
                Text("Add New Units here"),
                CSpace(),
                Tables(
                  headers: ["Active","Units","Unit Calculation","Measurement Unit Type"],
                  flex: [1,1,4,2],
                  children:[
                    for(var unit in dataList) eachRow(unit),
                  ]
                ),
                addNew(),
                SizedBox(height: 30,),
                Text(warning, style: TextStyle(color: Colors.red, fontSize: 22),)
              ]
          ),
        );
      },
      future: Calls.getMstUnits(),
    );
  }
  String getType(type){ //get
    String out = "";
    unitTypes.forEach((elm){if(elm["ID"]==type){out = elm["NAME"];}});
    return out;
  }
  updateFlag(id,kv) async{ //update flag as per TYPE of measurements Length/Mass/Weight
    List recds = [];
    if(kv["ACTV_UNIT"]!=1){
      recds.add({"id":kv["ID"],"flag":1});
      warning = "Update all related units of Text box values. Then Press Update! \nExample 1 KiloMeter = 1000 Meter";
      for(var i=0;i<dataList.length;i++){
        if(dataList[i]["ACTV_UNIT"]==1 && dataList[i]["TYPE_ID"]==kv["TYPE_ID"]){
          dataList[i]["ACTV_UNIT"]=0;
          recds.add({"id":dataList[i]["ID"],"flag":0});
        }
        if(dataList[i]["ID"]==kv["ID"]){
          dataList[i]["ACTV_UNIT"]=1;
        }
      }
      var results = await Calls.insUpdDelMstUnits({"type":"UF","rec":recds}); //update Flag
      if(results["res"]) {
        setState(()=>{});
      }
    }
  }

  //When new record insert button clicked below function works
  insRow() async {
    var type_id;
    mainUnitList.forEach((elm) {
      if(elm["UNIT"]==compareUnit) {
        type_id = elm["TYPE_ID"];
      }
    });
    var results = await Calls.insUpdDelMstUnits({"type":"INS","unit":unitNameCntrl.text,"typeId":type_id,"calc":unitCalcCntrl.text});
    if(results["res"]) {
      unitNameCntrl.text="";
      unitCalcCntrl.text="";
      refreshTable=true;
      Navigator.pop(context);
      setState(() => {});
    }

  }

  //Function to insert new record to Server Database
  insertJobType(newJobType) async {
    var result = await Calls.insDelMasterTypes({'name':newJobType,'type':"Work"});
    if(result["res"]){
      //widget.settingsData.add({"ID":result["data"],"NAME":newJobType,"TYPE":"Work"});
      newInsert=false;
      newUnitsController.text="";
      setState(()=>{});
    }
  }
}
