import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class RenderProxyTest extends SingleChildRenderObjectWidget {
  RenderProxyTest({Key key, @required Widget child}):super(key: key, child: child);
  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderProxyTest();
  }
}

class _RenderProxyTest extends RenderProxyBox {

  @override
  void paint(PaintingContext context, Offset offset) {
    print(offset);
    print(size);
    final canvas = context.canvas;
    canvas.saveLayer(offset & size, Paint()..blendMode = BlendMode.difference);
    context.paintChild(child, Offset(10,100));
    canvas.restore();
  }
}