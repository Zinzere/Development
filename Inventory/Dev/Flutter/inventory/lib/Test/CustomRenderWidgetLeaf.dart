import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class CustomRenderWidgetLeaf extends LeafRenderObjectWidget {
  CustomRenderWidgetLeaf({
    this.width = 0,
    this.height = 0,
    this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomRenderBox(width,height,color);
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    CustomRenderBox renderBox = renderObject as CustomRenderBox;
    renderBox
      ..width = width
      ..height = height
      ..color = color;
  }
  @override
  bool hitTestSelf(Offset position) => true;
}

class CustomRenderBox extends RenderProxyBox {
  CustomRenderBox(this.width,this.height,this.color);
  double width;
  double height;
  Color color;

  void performLayout() { //If there is a child use it's size. Else use performeresize
    //child and size available
    if (child != null) {
      child.layout(constraints, parentUsesSize: true); //parentUseSize -> mandatory | size adjustments
      size = child.size;
      final BoxParentData childParentData = child.parentData;

    } else {
      performResize();
    }
  }

  void performResize() { // if performresize = use minimum constraint value
    size = constraints.smallest;
    assert(size.isFinite);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final BoxParentData childParentData = child.parentData;
      context.paintChild(child, childParentData.offset + offset);
    }
  }

}