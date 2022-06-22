import 'package:flutter/material.dart';

class Date extends StatefulWidget {
  Date({@required this.date,this.onSelected, this.pad});
  final String date;
  final Padding pad;
  final ValueChanged<dynamic> onSelected;

  @override
  State<Date> createState() => _DateState();
}

class _DateState extends State<Date> {
  String dte = "";

  @override
  Widget build(BuildContext context) {
    var dates = widget.date==null ? Format(DateTime.now()) : Format(widget.date);
    if(dte=="") { dte = dates["Y"]; }
    return Padding(
      padding: widget.pad ?? EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () => DatePicker(context, dates["y"]),
        child: Container(
          width: 160,
          height: 60,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Select Date',
              labelStyle: TextStyle(color: Colors.purple, fontSize: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.calendar_today),
                Text(dte)
              ],),
          ),
        ),
      ),
    );
  }

  Future<Null> DatePicker(BuildContext context, String strDate) async {
    DateTime selectedDate = DateTime.parse(strDate);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000,1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate){
      setState((){
        selectedDate = picked;
        var resDate = Format(picked);
        dte = resDate["Y"];
        if(widget.onSelected!=null){
          widget.onSelected(resDate);
        }
      });
    }
  }
  Format(date){
    String strDate = date.toString().substring(0,10);
    String year = strDate.substring(0,5);
    String dd = strDate.substring(7,10);
    String mon = "";
    switch (date.month) {
      case 1:
        mon = "Jan";
        break;
      case 2:
        mon = "Feb";
        break;
      case 3:
        mon = "Mar";
        break;
      case 4:
        mon = "Apr";
        break;
      case 5:
        mon = "May";
        break;
      case 6:
        mon = "Jun";
        break;
      case 7:
        mon = "July";
        break;
      case 8:
        mon = "Aug";
        break;
      case 9:
        mon = "Sep";
        break;
      case 10:
        mon = "Oct";
        break;
      case 11:
        mon = "Nov";
        break;
      case 12:
        mon = "Dec";
        break;
    }
    return {"Y":year+mon+dd,"y":strDate};
  }
}
