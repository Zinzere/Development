import 'package:flutter/material.dart';
import '../ui/AllUi.dart';
import '../api/Calls.dart';

class AddProduct extends StatefulWidget {

  @override
  State<AddProduct> createState() => _AddProductState();
}
class _AddProductState extends State<AddProduct> {
  List<DataRow> _rowList = [];
  final List<String> Tableheadtxt = ["Colour","Variant/SKU","Default sales price","Default purchase price","Ingredients cost","Operation cost","In stock"];
  bool chkbox1 = false;
  bool chkbox2 = false;
  bool chkbox3 = false;
  bool chkbox4 = false;

  Widget HeadOptions(){
      return Container(
        margin: EdgeInsets.only(top: 10),
        height: 50,
        color: Colors.blue[200],
        child: Row(
          children:[
            RSpace(),
            Button("Item Details",onPressed: () {},pad: EdgeInsets.all(18),bgColor: Colors.white,color: Colors.black,),
            SizedBox(width: 5,),
            Button("Work Details",onPressed: () {},pad: EdgeInsets.all(18),bgColor: Colors.blue[100],color: Colors.black,),
          ],
        ),
      );
  }
  Widget AddItem(size){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TFFlex(TFPlain(cntrolr: TextEditingController(),label: "Product Name",), width: size.width*0.4,),
        CheckBox(
          multiple: true,
          label: "Do you track quantities batches or lots?", choices: ["I track batch/lot numbers","I make this product"],
          selected: (list){
            print(list);
        },)
      ],
    );
  }
  Widget rows(list){
    return Padding(padding: EdgeInsets.only(left: 50, right: 50),
    child: Row(
      children: list,
    ),
    );
  }
  Widget cbRow(title,check,function){
    return Column(
      children: [
          
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(
          children: [
            HeadOptions(),
            CSpace(),
            rows([
                TFFlex(TFPlain(cntrolr: TextEditingController(),label: "Product Name",), width: size.width*0.4,),
                SizedBox(width: 50,),
                CheckBox(
                  multiple: true,
                  label: "Do you track quantities batches or lots?", choices: ["I track batch/lot numbers"],
                  selected: (list){
                    print(list);
                  },)
              ],
            ),
            CSpace(),
            rows([
                TFFlex(TFPlain(cntrolr: TextEditingController(),label: "Category",), width: size.width*0.4,),
                SizedBox(width: 50,),
                CheckBox(
                  multiple: true,
                  label: "How do you source this product?", choices: ["I make this product","I Buy this product"],
                  selected: (list){
                    print(list);
                  },)
              ],
            ),
            Search(
              displayList: ["NAME","-","TYPE"],
              futureOrList: (pattern) async {
                var result = await Calls.search({"name":pattern});
                return result["data"];
              },
              controller: searchController,
              hintText: "Search Example",
              onChanged: (val) {
                print(val);
              },
            ),
          ],
        )
    );
  }

  Widget main(size){
    return Container(
      child: Column(
        children:[
          Container(
            color:Colors.white,
            height:size.height * 0.55,
            width:MediaQuery.of(context).size.width,
            child:Row(
              children:[
                Container(padding: EdgeInsets.all(30.0),
                    color:Colors.white,
                    height:size.height * 0.55,
                    width:size.width * 0.50,
                    child:Column(
                      children:[
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
                    children:[
                      SizedBox(height:50,),
                      TFPlain(cntrolr:TextEditingController(),label: "Product Name"),
                      buildTxt("Do you track quantities batches or lots?"),
                      checkbox("I track batch/lot numbers", chkbox1,1),
                      SizedBox(height:50),
                      buildTxt("How do you source this product?"),
                      Row(
                        children:[
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
    return TextField(
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



  Widget checkbox(String title, bool boolValue,onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Checkbox(
          value: boolValue,
          onChanged: onChanged,
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
