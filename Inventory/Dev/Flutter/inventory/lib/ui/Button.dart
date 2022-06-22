import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  Button(this.name,{@required this.onPressed, this.pad, this.fontSize, this.fontWeight, this.color,this.bgColor, this.round});
  final name;
  final VoidCallback onPressed;
  final EdgeInsets pad;
  final Color bgColor;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final double round;
  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return widget.round!=null ? ElevatedButton(
      onPressed: widget.onPressed,
      child: Text(widget.name, style: TextStyle(fontSize: widget.fontSize ?? 15,
          fontWeight: widget.fontWeight ?? FontWeight.w500,
          color: widget.color ?? Colors.white),),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(widget.bgColor ?? Colors.blue),
        padding: MaterialStateProperty.all(widget.pad ?? const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.round ?? 50)))
      ),
    ) : ElevatedButton(
      onPressed: widget.onPressed,
      child: Text(widget.name, style: TextStyle(fontSize: widget.fontSize ?? 15,
          fontWeight: widget.fontWeight ?? FontWeight.w500,
          color: widget.color ?? Colors.white),),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(widget.bgColor ?? Colors.blue),
        padding: MaterialStateProperty.all(widget.pad ??
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10)),
      ),
    );
  }
}

