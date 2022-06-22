import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class RenderTest extends SingleChildRenderObjectWidget {

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderTestWid();
  }
  //@override void updateRenderObject(BuildContext context, covariant RenderObject renderObject) {}
}

class RenderTestWid extends RenderProxyBox {

}