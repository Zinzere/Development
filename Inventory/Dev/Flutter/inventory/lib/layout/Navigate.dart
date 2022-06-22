import 'package:flutter/material.dart';

class Navigate extends StatefulWidget {
  Navigate({@required this.onSelected});
  final Function(String) onSelected;

  @override
  State<Navigate> createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  String selected = "ORDERS";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Row(
          children: [
                    navbar(Icons.home,"ORDERS"),
                    navbar(Icons.settings,"MAKE"),
                    navbar(Icons.details,"BUY"),
                    navbar(Icons.details,"STOCK"),
                    navbar(Icons.account_balance,"REPORTS"),
                    navbar(Icons.settings,"SETTINGS"),
            ],
         ),
    );
  }

  Widget navbar(icon,name){
    Color clr = name == selected ? Colors.white : Colors.white24;
    return GestureDetector(
      onTap: () {
        selected = name;
        widget.onSelected(name);
        setState(() { });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Icon(icon, size: 30,color: clr),
              Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: clr),)
            ],
          ),
        ),
      ),
    );
  }
}


