import 'package:flutter/material.dart';

class Tables extends StatefulWidget {

  @override
  State<Tables> createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  Map _books = {
      'wid':['text','text','text'],
      'header':['ID','Book','Author'],
      'data':[[100,'Flutter Basics','David John'],[101,'Flutter Basics','David John'],[102,'Git and GitHub','Merlin Nick']]
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        _createDataTable()
      ],
    );
  }

  DataTable _createDataTable() {
    return DataTable(
        columns: _createColumns(),
        rows: _createRows()
    );
  }
  List<DataColumn> _createColumns() {
    List<DataColumn> colList = [DataColumn(label: Text('ID')),DataColumn(label: Text('Book')),DataColumn(label: Text('Author'))];
    // _books["header"].forEach((val)=>{
    //   colList.add(DataColumn(label: Text(val))),
    // });
    return colList;
  }
  List<DataRow> _createRows() {
    return [
      DataRow(cells: [
        DataCell(
            ElevatedButton(
              child: Text("100"),
              onPressed: (){
                print("Helloo");
              },
            )
        ),
        DataCell(Text('Flutter Basics')),
        DataCell(Text('David John'))
      ]),
      DataRow(cells: [
        DataCell(Text("100")),
        DataCell(Text('Dart Internals')),
        DataCell(Text('Alex Wick'))
      ])
    ];
  }
  Widget textFld(){

  }
}
