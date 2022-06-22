import 'package:flutter/material.dart';

class General extends StatefulWidget {

  @override
  State<General> createState() => _GeneralState();
}
class _GeneralState extends State<General> {
  List<DataRow> _rowList = [];
  final List<String> Tableheadtxt = ["Colour","Variant/SKU","Default sales price","Default purchase price","Ingredients cost","Operation cost","In stock"];
  bool chkbox1 = false;
  bool chkbox2 = false;
  bool chkbox3 = false;
  bool chkbox4 = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            height: size.height * 0.55,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(padding: EdgeInsets.all(30.0),
                    color: Colors.white,
                    height: size.height * 0.55,
                    width: size.width * 0.50,
                    child:Column(
                      children: [
                        SizedBox(height: 20,),
                        buildTxtfield("Product name"),
                        SizedBox(height: 50,),
                        buildTxtfield("Category"),
                        SizedBox(height: 50,),
                        buildTxtfield("Unit of Measure"),
                      ],
                    )
                ),
                Container(
                  padding: EdgeInsets.all(30.0),
                  color: Colors.white,
                  height: size.height * 0.55,
                  width: size.width * 0.50,
                  child: Column(
                    children: [
                      SizedBox(height: 50,),
                      buildTxt("Do you track quantities batches or lots?"),
                      checkbox("I track batch/lot numbers", chkbox1,1),
                      SizedBox(height: 50,),
                      buildTxt("How do you source this product?"),
                      Row(
                        children: [
                          checkbox("I make this product", chkbox2,2),
                          checkbox("I buy this product", chkbox3,3),
                        ],
                      ),
                      SizedBox(height: 20,),
                      buildTxtfield("Default supplier"),
                      SizedBox(height: 50,),
                      buildTxt("Do you buy this item in a different unit of measure?"),
                      checkbox("Yes I purchase in a dufferent unit", chkbox4,4),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
              padding: EdgeInsets.all(7.0),
              color: Colors.white,
              height: size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              child:ListView(
                children: [
                  Container(
                      color: Colors.white,
                      height: size.height * 0.05,
                      child:Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            color:Colors.white,
                            padding: EdgeInsets.all(8.0),
                            height: size.height * 0.05,
                            width: size.width * 0.15,
                            child:TextButton.icon(     // <-- TextButton
                              onPressed: () {
                              },
                              icon: Icon(
                                Icons.do_not_touch,
                                size: 24.0,
                              ),
                              label: Text('Open Configuration '),
                            ),
                          )
                      )
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child:DataTable(
                        headingRowColor:
                        MaterialStateColor.resolveWith((states) => Colors.grey),
                        columns: [
                          for(var i=0;i<Tableheadtxt.length;i++)
                      DataColumn(label: Container(
                        // width: 150,
                        child:Text(Tableheadtxt[i]))),
                        ],
                        rows: _rowList),
                  ),
                ],
              )
          ),


          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                color:Colors.white,
                padding: EdgeInsets.all(8.0),
                height: size.height * 0.05,
                width: size.width * 0.10,
                child:TextButton.icon(     // <-- TextButton
                  onPressed:_addRow,
                  icon: Icon(
                    Icons.add,
                    size: 24.0,
                  ),
                  label: Text('Add new row'),
                ),
              )
          )
        ],
      ),
    );
  }
  Widget buildTxtfield(String lbltxt) {
    return TextField (
      decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: lbltxt,
          hintText: ''
      ),
    );
  }

  Widget buildTxt(String txtvalue) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        txtvalue,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 16),
      ),
    );
  }



  Widget checkbox(String title, bool boolValue,int num) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Checkbox(
          value: boolValue,
          onChanged: ( value) {
            /// manage the state of each value
            setState(() {
              switch (num) {
                case 1:
                  chkbox1 = value;
                  break;
                case 2:
                  chkbox2 = value;
                  break;
                case 3:
                  chkbox3 = value;
                  break;
                case 4:
                  chkbox4  = value;
                  break;
              }
            });
          },
        ),
        Text(title),
      ],
    );
  }

  void _addRow() {
    setState(() {
      _rowList.add(DataRow(cells: <DataCell>[
        for(var j=0;j<Tableheadtxt.length;j++)
        DataCell(Container(
          padding: EdgeInsets.all(8.0),
          // width: 150,
          child:TextField(
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
              ),
            ),
          ),)),
      ]));
    });
  }
}
