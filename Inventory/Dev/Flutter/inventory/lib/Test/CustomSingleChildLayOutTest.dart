import 'package:flutter/material.dart';
import 'dart:math' as math;

class SingleChildDelegateTest extends  SingleChildLayoutDelegate{
  SingleChildDelegateTest({this.position});
  final Offset position;

  Size _size = Size.zero;

  @override
  Size getSize(BoxConstraints constraints){
    _size = Size(constraints.maxWidth,constraints.maxHeight);
    print(constraints);
    print(_size);
    return _size;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    print(constraints);
    return BoxConstraints.tight(_size);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize){
    return Offset(size.width / 4, size.height / 4);
  }

  @override
  bool shouldRelayout(covariant SingleChildDelegateTest oldDelegate) {
    return position != oldDelegate.position;
  }
}















/*
const Duration _kDropdownMenuDuration = Duration(milliseconds: 300);
const double _kMenuItemHeight = kMinInteractiveDimension;

class CustomSingleChildLayoutTest extends StatefulWidget {
  CustomSingleChildLayoutTest({@required this.child});

  final Widget child;

  @override
  State<CustomSingleChildLayoutTest> createState() =>
      _CustomSingleChildLayoutTestState();
}

class _CustomSingleChildLayoutTestState extends State<CustomSingleChildLayoutTest> {
  final ValueNotifier<Size> _size = ValueNotifier<Size>(const Size(200.0,100.0));

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: CustomLayoutDelegate(_size),
      child: widget.child,
    );
  }
}

class CustomLayoutDelegate extends SingleChildLayoutDelegate {
  //321 dropdown | 414 _DropdownRoute Popup Route/Rect/TextDirection |

  CustomLayoutDelegate(this.size) : super(relayout: size);

  final ValueNotifier<Size> size;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    //return BoxConstraints.tight(size.value / 2);
    double maxHeight =
        math.max(0.0, constraints.maxHeight - 2 * _kMenuItemHeight);
    // if (route.menuMaxHeight != null && route.menuMaxHeight! <= maxHeight) {
    //   maxHeight = route.menuMaxHeight!;
    // }
    final double width = math.min(constraints.maxWidth, 200.0);
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(size.width / 4, size.height / 4);
  }

  @override
  bool shouldRelayout(CustomLayoutDelegate oldDelegate) {
    return size != oldDelegate.size;
  }
}

class PopupRouteTest extends PopupRoute {
  PopupRouteTest({
    @required this.builder,
    this.dismissible = true,
    this.label,
    this.color,
    RouteSettings setting,
  }) : super(settings: setting);

  final WidgetBuilder builder;
  final bool dismissible;
  final String label;
  final Color color;

  @override
  Color get barrierColor => color;

  @override
  bool get barrierDismissible => dismissible;

  @override
  String get barrierLabel => label;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return RotationTransition(
      turns: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);
}
 */