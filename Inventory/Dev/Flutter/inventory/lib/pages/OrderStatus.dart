import 'package:flutter/material.dart';
import '../ui/TTable.dart';
import '../Test/Test.dart';
import '../ui/SearchTest.dart';

class OrderPage extends StatefulWidget {

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  bool testFun(val){
    if(DateTime.parse(val).isBefore(DateTime.now())){
      return false;
    } else {
      return true;
    }
  }
  optFun(val,id){
    print(val);
    print(val);
    print(id);
  }
  click(i){
    print(i.toString());
    print("Clicked");
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            {'type':'button','flex':1,
              'color':{'Flutter Basics':'orange','Flutter Advanced':'red','Git and GitHub':'green'},
              'click':{'return':'id','fun':click},
            },
            {'type':'dropdown','flex':1,'click':{'return':'id','fun':optFun},
              'list':['Not Yet Started','Work In Progress','Delivered','Blocked']}],
        ),
        SearchTest(onSelect: (val) {
          print("Hello");
        })
      ],
    );
  }
}
