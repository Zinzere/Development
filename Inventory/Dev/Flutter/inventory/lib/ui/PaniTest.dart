//https://stackoverflow.com/questions/49307677/how-to-get-height-of-a-widget#:~:text=To%20get%20the%20size%2Fposition,global%20position%20and%20rendered%20size.
import 'package:flutter/material.dart';
import 'package:inventory/ui/AllUi.dart';
import 'dart:math' as math;
import 'package:flutter/src/material/constants.dart';

const double _kMenuItemHeight = kMinInteractiveDimension;

class PaintTest extends StatefulWidget {

  @override
  State<PaintTest> createState() => _PaintTestState();
}

class _PaintTestState extends State<PaintTest> with TickerProviderStateMixin {
  AnimationController animation;
  @override
  void initState() {
    super.initState();
    animation = new AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    animation.forward();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: 500,
      height: 500,
      color: Colors.black12,
      child: LayoutBuilder(
        builder: (context, constraints) {
          print(screenSize);
          return Container(
            padding: EdgeInsets.all(50),
            width: 100,
            height: 100,
            child: CustomPaint(
                painter: _DropdownMenuPainter(
                  color: Theme
                      .of(context)
                      .canvasColor,
                  elevation: 8,
                  animation: animation,
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                )
            ),
          );
        }
      ),
    );
  }
}

class _DropdownMenuPainter extends CustomPainter {
  _DropdownMenuPainter({
    this.color,
    this.elevation,
    this.animation,
    //this.selectedIndex,
    this.borderRadius,
    // required this.resize,
    // required this.getSelectedItemOffset,
  }) : _painter = BoxDecoration(
    // If you add an image here, you must provide a real
    // configuration in the paint() function and you must provide some sort
    // of onChanged callback here.
    color: color,
    borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(2.0)),
    boxShadow: kElevationToShadow[elevation],
  ).createBoxPainter(),
        super(repaint: CurvedAnimation(
        parent: animation,
        curve: const Interval(0.25, 0.5),
        reverseCurve: const Threshold(0.0),
      ));

  final Color color;
  final int elevation;
  final Animation animation;
  //final int selectedIndex;
  final BorderRadius borderRadius;
  // final Animation<double> resize;
  // final ValueGetter<double> getSelectedItemOffset;
  final BoxPainter _painter;

  @override
  void paint(Canvas canvas, Size size) {
    //final double selectedItemOffset = getSelectedItemOffset();
    final Tween<double> top = Tween<double>(
      begin: 1.0,
      end: 0.0,
    );

    final Tween<double> bottom = Tween<double>(
      begin: (top.begin + _kMenuItemHeight).clamp(math.min(_kMenuItemHeight, size.height), size.height),
      end: size.height,
    );

    final Rect rect = Rect.fromLTRB(0.0, top.evaluate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.25, 0.5),
      reverseCurve: const Threshold(0.0),
    )), size.width, bottom.evaluate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.25, 0.5),
      reverseCurve: const Threshold(0.0),
    )));
    _painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }

  @override
  bool shouldRepaint(_DropdownMenuPainter oldPainter) {
    return oldPainter.color != color
        || oldPainter.elevation != elevation
        //|| oldPainter.selectedIndex != selectedIndex
        || oldPainter.borderRadius != borderRadius;
  }
}
