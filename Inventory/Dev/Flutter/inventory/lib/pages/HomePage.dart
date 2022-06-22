import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inventory/pages/AddProduct.dart';
import 'package:inventory/pages/OrderStatus.dart';
import 'package:inventory/ui/AllUi.dart';
import '../pages/AllPages.dart';
import '../layout/AllLayout.dart';
import '../ui/SearchTest.dart';


import '../Test/RenderTest.dart';
import '../Test/CustomSingleChildLayOutTest.dart';
import '../Test/CustomRenderWidgetLeaf.dart';
import '../Test/GapWidget.dart';
import '../Test/RenderProxyTest.dart';
import '../Test/ParentTest.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> abc = [1,2,3];
  var myChildSize = Size.zero;
  Widget ShowWidget = OrderPage();
  // Column(
  //   children: [
  //     Container(width: 100,height: 100,color: Colors.transparent,),
  //     // RenderProxyTest(child: Container(width: 50, height: 50,color: Colors.teal,)),
  //     Container(width: 100,height: 100,color: Colors.yellow,child: DropdownButton(),),
  //     Container(width: 100,height: 100,color: Colors.black12,
  //         child: ParentTest(child: Container(width: 50,height: 50,color: Colors.black,),),
  //     ),
      // CustomSingleChildLayout(
      //     delegate: SingleChildDelegateTest(),
      //   child: Container(
      //     width: 100,
      //     height: 100,
      //     color: Colors.black12,
      //   ),
      // )
  //   ],
  // );

  // Container(
  //   width: 500,
  //   height: 400,
  //   color: Colors.black12,
  //   child: CustomRenderWidgetLeaf(width: 200,height: 300,color: Colors.blue,),
  // );

  // CustomSingleChildLayoutTest(
  // child: Container(
  // color: Colors.teal,
  // width: 50,
  // height: 200,
  // child: Text("Final Last Container Child"),
  // ),
  // )

  //Widget ShowWidget = OrderPage();

  @override
  Widget build(BuildContext context){
    return MApp(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Navigate(onSelected:(value) => menuSelected(value))
        ),
        child: SingleChildScrollView(child: ShowWidget
        // Container(
        //   width: 500,
        //   height: 500,
        //   color: Colors.black12,
        //   child: MeasureSize(
        //     onChange: (size){
        //       myChildSize=size;
        //     },
        //     child: Container(
        //       width: 100,
        //       height: 100,
        //       color: Colors.red,
        //     ),
        //   ),
        // )
    )
    );
  }

  menuSelected(value) {
    if (value == "SETTINGS") {
      ShowWidget = SettingsPage();
    } else if (value == "REPORTS") {
      ShowWidget = AddProduct();
    }  else if (value == "ORDERS") {
      ShowWidget = OrderPage();
    }
    setState(()=>{});
  }
}

// getWindowSize() async {
//   Size size = await DesktopWindow.getWindowSize();
//   await DesktopWindow.setMaxWindowSize(Size(1500,1000));
//   await DesktopWindow.resetMaxWindowSize();
//   await DesktopWindow.toggleFullScreen();
//   bool isFullScreen = await DesktopWindow.getFullScreen();
//   await DesktopWindow.setFullScreen(true);
//   await DesktopWindow.setFullScreen(false);
//   setState(()=>{});
// }
// @override
// initState(){
//   getWindowSize();
// }
// if (value == "ORDER/PURCHASE/SALE") {
// ShowWidget = ShowDeals();
// } else if (value == "PL") {
// ShowWidget = ProfitLoss();
// } else if (value == "ORDER REPORTS") {
// ShowWidget = ReportsPage();
// }