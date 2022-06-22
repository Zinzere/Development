import 'package:flutter/material.dart';
import 'package:inventory/ui/AllUi.dart';
import 'Operations.dart';
import 'UnitMeasure.dart';
import 'Products.dart';
import 'Materials.dart';
import '../../api/Calls.dart';

var settingsData = [];

class SettingsPage extends StatefulWidget {

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> Menuitems = ["General","Finished Products","Raw Materials","Operations","Resources","Units of Measure","Tax rates"];
  String selected = "General";
  Widget rightPane = General();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    EdgeInsets padLeftDiv = EdgeInsets.only(top: 30, left: size.width*0.1);
    EdgeInsets padEachMenu = const EdgeInsets.only(bottom: 15, top: 15, left: 30, right: 30);
    EdgeInsets padRightDiv = const EdgeInsets.only(top: 20, left: 60);
    EdgeInsets marRightDiv = const EdgeInsets.only(top: 30);

    return Container(
      width: size.width,
      height: size.height,
      color: Colors.black12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Container(
            margin: padLeftDiv,
            decoration: const BoxDecoration(
              color: Colors.black12,
              boxShadow:[
                BoxShadow(
                  color: Colors.black12,
                  offset: const Offset(-5,-5,),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ), //BoxShadow
                BoxShadow(
                  color:Colors.white,
                  offset:const Offset(0.0,0.0),
                  blurRadius:0.0,
                  spreadRadius:0.0,
                ), //BoxShadow
              ],
            ),
            width: size.width*0.20,
            height: size.height*0.75,
            child: ListView(
              shrinkWrap: true,
              children: [
                for(var wid in Menuitems)
                  GestureDetector(
                    child: Container(
                      padding: padEachMenu,
                      color: wid == selected ? Colors.black26 : Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Text(wid),
                          Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                        ],
                      ),
                    ),
                    onTap:(){
                      selected = wid;
                      if(wid=="Operations"){
                        rightPane = Operations(settingsData,(list){
                                settingsData=list;
                              }
                        );
                      } else if(wid=="General"){
                        rightPane = General();
                      } else if (wid=="Units of Measure"){
                        rightPane = UnitMeasure(settingsData);
                      } else if (wid=="Finished Products"){
                        rightPane = Products(settingsData,(list){
                          settingsData=list;
                        });
                      } else if (wid=="Raw Materials"){
                        rightPane = Materials(settingsData,(list){
                          settingsData=list;
                        });
                      }
                      setState(() {});
                    },
                  )
              ],
            ),
          ),
          Container(
            color: Colors.white,
              margin: marRightDiv,
              padding: padRightDiv,
              width: size.width*0.65,
              height: size.height*0.75,
              child: rightPane
          )
        ],
      ),
    );
  }
}

Widget General(){
  return Futures(
    child: (data){
      settingsData=data;
      return Container(
          padding: EdgeInsets.only(top:200),
          child:Column(
            children:[
              Text("General Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
              CSpace(),
              Text("Default Order Delivery days - 30 days", style: TextStyle(color: Colors.blue, fontSize: 20),),
              CSpace(),
              Text("Default Purchase lead time 14 Days", style: TextStyle(color: Colors.blue, fontSize: 20),),
            ],
          )
      );
    },
    future: Calls.getGeneral(),
  );
}