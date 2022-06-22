import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

class Gap extends LeafRenderObjectWidget {
  const Gap(
      this.mainAxisExtent, {
        Key key,
      }) : assert(mainAxisExtent >= 0 && mainAxisExtent < double.infinity),
        super(key: key);
  final double mainAxisExtent;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderGap(mainAxisExtent: mainAxisExtent);
  }
  @override
  void updateRenderObject(BuildContext context, _RenderGap renderObject) {
    renderObject.mainAxisExtent = mainAxisExtent;
  }
}

class _RenderGap extends RenderBox {
  _RenderGap({ double mainAxisExtent}) : _mainAxisExtent = mainAxisExtent;
  double get mainAxisExtent => _mainAxisExtent;
  double _mainAxisExtent;

  @override
  setupParentData(RenderObject child){

  }

  set mainAxisExtent(double value) {
    if (_mainAxisExtent != value) {
      _mainAxisExtent = value;
      markNeedsLayout();
    }
  }
  @override
  void performLayout() {

    final AbstractNode flex = parent;
    if (flex is RenderFlex) {
      if (flex.direction == Axis.horizontal) {
        size = constraints.constrain(Size(mainAxisExtent, 0));
      } else {
        size = constraints.constrain(Size(0, mainAxisExtent));
      }
    } else {
      throw FlutterError(
        'Gap widget is not inside a Flex Parent',
      );
    }
  }
}