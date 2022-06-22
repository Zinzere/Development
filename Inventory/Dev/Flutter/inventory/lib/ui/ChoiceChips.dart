import 'package:flutter/material.dart';

class ChoiceChips extends StatefulWidget {
  ChoiceChips(this.itemsList,{@required this.multichoice, this.onSelected, this.align, this.padding, this.hint});

  final List<String> itemsList;
  final bool multichoice;
  final String hint;
  final Function(String) onSelected;
  final WrapAlignment align;
  final EdgeInsets padding;

  @override
  _ChoiceChipsState createState() => _ChoiceChipsState();
}

class _ChoiceChipsState extends State<ChoiceChips> {
  bool multichoice;
  String selectedChoice = "";

  _buildChoiceList() {
    List<Widget> choices = [];
    widget.itemsList.forEach((item) {
      choices.add(Container(
        padding: EdgeInsets.only(right: 3),
        child: choiceChips(item),
      ));
    });
    return choices;
  }

  Widget choiceChips(String item) {
    String showText, sendText;

    if(item.contains("#")) {
      sendText = item.substring(item.indexOf("#") + 1);
      showText = item.substring(0,item.indexOf("#"));
    } else {
      sendText = showText = item;
    }
    return ChoiceChip(
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(side: BorderSide(color: Colors.purple,width: 1.5 )),
      label: Text(showText, style: TextStyle(color: selectedChoice == sendText ? Colors.white : Colors.purple),),
      selected: selectedChoice == sendText,
      selectedColor: Colors.purple,
      onSelected: (selected) {
        if(selectedChoice==sendText) {
          selectedChoice = "";
        } else {
          selectedChoice = sendText;
        }
        sendData();
        setState(() {});
      },
    );
  }

  sendData() => widget.onSelected(selectedChoice);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding == null ? EdgeInsets.only(right: 20.0, left: 20.0, bottom: 10.0, top: 10.0) : widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.hint == null ? " " : widget.hint,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Wrap(
            alignment: widget.align ?? WrapAlignment.start,
            children: _buildChoiceList(),
          ),
        ],
      ),
    );
  }
}