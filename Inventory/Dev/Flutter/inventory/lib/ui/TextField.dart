import 'package:flutter/material.dart';

/*
Square Text Filed -> TFSquare
Round Text Field -> TFRound
Plain Text Field -> TFPlain
TFSQuare(
  label:"Header Label String",
  focus: true,
  inputType: TextInputType.text,
  cntrolr: controller(),
  txtAlign: TextAlign.center,
  onChanged: (val) {
    print(val);
  },
  )
//For Adding TextField inside Row or two items use TFFlex - Flexible Text Field
TFFlex(
TFSQuare(
  label:"Header Label String",
  focus: true,
  inputType: TextInputType.text,
  cntrolr: controller(),
  txtAlign: TextAlign.center,
  onChanged: (val) {
    print(val);
  },
  ),
width: 60,)
 */

TextStyle labelStyle = TextStyle(color: Colors.purple,fontStyle: FontStyle.italic, fontSize: 18);

class TFPlain extends StatefulWidget {
  TFPlain({@required this.cntrolr,this.label,this.onChanged, this.inputType,this.txtAlign, this.focus, this.icon});
  final TextEditingController cntrolr;
  final ValueChanged<dynamic> onChanged;
  final String label;
  final TextInputType inputType;
  final TextAlign txtAlign;
  final bool focus;
  final IconData icon;

  @override
  State<TFPlain> createState() => _TFPlainState();
}

class _TFPlainState extends State<TFPlain> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.focus ?? false,
      textAlign: widget.txtAlign ?? TextAlign.start,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: widget.inputType ?? TextInputType.text,
      controller: widget.cntrolr,
      decoration: widget.icon==null ? noIcon(widget.label) : icon(widget.icon,widget.label)
    );
  }
}

InputDecoration icon(icon, label){
  return InputDecoration(
      prefixIcon: Icon(icon),
      labelText: label,
      labelStyle: labelStyle
  );
}
InputDecoration noIcon(label){
  return InputDecoration(
      labelText: label,
      labelStyle: labelStyle
  );
}

class TFRound extends StatefulWidget {
  TFRound({@required this.cntrolr,this.label,this.onChanged, this.inputType,this.focus,this.txtAlign});
  final TextEditingController cntrolr;
  final ValueChanged<dynamic> onChanged;
  final String label;
  final TextInputType inputType;
  final TextAlign txtAlign;
  final bool focus;

  @override
  State<TFRound> createState() => _TFRoundState();
}

class _TFRoundState extends State<TFRound> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.focus ?? false,
      textAlign: widget.txtAlign ?? TextAlign.start,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: widget.inputType ?? TextInputType.text,
      controller: widget.cntrolr,
      decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: labelStyle,
          border:OutlineInputBorder(
             borderRadius: BorderRadius.circular(20.0)
          )
      ),
    );
  }
}

class TFSQuare extends StatefulWidget {
  TFSQuare({@required this.cntrolr,this.label,this.onChanged,this.focus,this.inputType,this.txtAlign});
  final TextEditingController cntrolr;
  final ValueChanged<dynamic> onChanged;
  final String label;
  final TextInputType inputType;
  final TextAlign txtAlign;
  final bool focus;
  @override
  State<TFSQuare> createState() => _TFSQuareState();
}

class _TFSQuareState extends State<TFSQuare> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.focus ?? false,
      textAlign: widget.txtAlign ?? TextAlign.start,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: widget.inputType ?? TextInputType.text,
      controller: widget.cntrolr,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: labelStyle,
          contentPadding: EdgeInsets.all(2),
          border: OutlineInputBorder(gapPadding: 1),
        )
    );
  }
}

class TFFlex extends StatelessWidget {
  TFFlex(this.textField,{@required this.width});
  final Widget textField;
  final double width;
  
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(child: textField, stepWidth: width ?? 100,);
  }
}

