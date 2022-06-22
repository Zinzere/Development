import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ParentTest extends SingleChildRenderObjectWidget{
  ParentTest({Key key, Widget child}):super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ParentTest();
  }
}

class _ParentTest extends RenderBox with RenderObjectWithChildMixin<RenderBox> {

  @override
  void performLayout() {
      if(child!=null) {
        size = constraints.biggest;
        child.layout(constraints.loosen(), parentUsesSize: true);
        double dx = (constraints.maxWidth - child.size.width) / 2;
        double dy = (constraints.maxHeight - child.size.height) / 2;
        BoxParentData childParentData = child.parentData;
        childParentData.offset = Offset(dx, dy);
        print(constraints);
        print(constraints.maxWidth);
        print(constraints.maxHeight);
        print(child.size.width);
        print(child.size.height);
        print(childParentData.offset);
      } else {
        size = Size(0,0);
      }
  }
  @override
  void paint(PaintingContext context, Offset offset){
    if(child!=null) {
        var parentData = child.parentData as BoxParentData;
        print(parentData);
        context.paintChild(child, Offset(100,200));
    }
  }
}