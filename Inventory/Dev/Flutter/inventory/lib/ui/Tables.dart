import 'package:flutter/material.dart';

/*
Tables(
      headers: ["Unit Name", "Unit Calculation", "Unit Type"],
      flex: [2, 3, 2],
      children:[
        TRow([
          Cell( //Icon Cell
            icon:Icons.check_box,
            iconPress: () => function()
          ),
          Cell(txt:"Text String") //Text Cell
          Cell( child: TFFlex(TFPlain(
            focus: true,
            cntrolr: unitNameCntrl,
            txtAlign: TextAlign.center,
          ),),),
        ])
      ]
  )
 */


Color celColor = Colors.black26;
List<int> flexList = [];

class Tables extends StatelessWidget {
  Tables({@required this.children, this.headers, this.flex}): assert(flex!=null,"\n\n *** FLEX LIST is must like [1,1,1] *** \n");
  final List<TRow> children;
  final List<String> headers;
  final List<int> flex;
  @override
  Widget build(BuildContext context) {
    flexList = flex;
    List headersList = headers ?? [];
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: celColor),
          ),
        ),
        child: Column(
          children: [
            TRow(
              [for(var i=0;i<headersList.length;i++) Cell(child:Center(
                child: Text(headersList[i],
                  style: const TextStyle(
                      fontWeight:FontWeight.bold,
                      fontSize: 13
                  ),),
                ), flex:flexList[i],),
              ]
            ),
            for(var rows in children) rows
          ]
        ),
      ),
    );
  }
}

class TRow extends StatelessWidget {
  TRow(this.widList);
  final List<Cell> widList;
  @override
  Widget build(BuildContext context) {
    for(var i=0;i<this.widList.length;i++) this.widList[i].flex=flexList[i];
    return Container(
        width: 700,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1, color: celColor),
          ),
        ),
        child: Row(
            children:this.widList
        )
    );
  }
}

class Cell extends StatelessWidget {
  Cell({@required this.flex,this.txt,this.header,this.child,this.icon,this.iconSize,this.iconPress});
  final String txt;
  final String header;
  final IconData icon;
  final double iconSize;
  final Function iconPress;
  final Widget child;
  int flex;

  Widget main(){
    if(txt!=null){
      return Center(
        child: Text(txt,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 13
          ),),
      );
    } else if(header!=null) {
      return Center(
        child: Text(header,
          style: const TextStyle(
              fontWeight:FontWeight.bold,
              fontSize: 13
          ),),
      );
    } else if(icon!=null) {
      return IconButton(onPressed:iconPress, icon: Icon(icon, size: iconSize ?? 20,));
    } else {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: Container(
          height: 45,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 1,color: celColor),
              top: BorderSide(width: 1,color: celColor),
            ),
          ),
          child: main()
      ),
    );
  }
}


