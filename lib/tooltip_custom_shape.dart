import 'package:flutter/material.dart';

enum TooltipAlign { top, bottom }

class ToolTipCustomShape extends ShapeBorder {
  final bool usePadding;

  final TooltipAlign tooltipAlign;

  const ToolTipCustomShape({
    this.usePadding = true,
    this.tooltipAlign = TooltipAlign.bottom,
  });

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 20 : 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(
      rect.topLeft,
      rect.bottomRight - const Offset(0, 20),
    );

    //Set Rectangle with it's border and borderRadius
    Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 10)),
      );

    if (tooltipAlign == TooltipAlign.bottom) {
      path
        ..moveTo(rect.topCenter.dx - 20, rect.topCenter.dy)
        ..relativeLineTo(20, 0)
        ..relativeLineTo(-10, -10)
        ..close();
    } else {
      path
        ..moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy)
        ..relativeLineTo(10, 10)
        ..relativeLineTo(10, -10)
        ..close();
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
