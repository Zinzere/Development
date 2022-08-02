import 'package:flutter/material.dart';

Decoration topLeft(){
  return BoxDecoration(
    border: Border(
      left: BorderSide(
          width: 1,
          color: Colors.black26
      ),
      top: BorderSide(
          width: 1,
          color: Colors.black26
      ),
    ),
  );
}
Decoration btmRight(){
  return const BoxDecoration(
    border: Border(
        bottom: BorderSide(
            width: 1,
            color: Colors.black26
        ),
        right: BorderSide(
            width: 1,
            color: Colors.black26
        )
    ),
  );
}