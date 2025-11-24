import 'package:flutter/material.dart';
import 'package:mtooltip/src/constants/apex_position.dart';

import '../constants/tooltip_align.dart';

/// A shape that paints a rounded rectangle with a triangular "apex" (arrow)
/// pointing to the target.
///
/// This shape is used as the decoration for the tooltip container. The main
/// rectangle is inset from the supplied [rect] by 20 logical pixels on the
/// bottom edge to make room for the triangular apex. The apex orientation
/// depends on [tooltipAlign]:
/// - TooltipAlign.top: apex is drawn on the top edge of the rounded rect
///   and points upward (suitable when the tooltip is shown below the target).
/// - TooltipAlign.bottom: apex is drawn on the bottom edge of the rounded rect
///   and points downward (suitable when the tooltip is shown above the
///   target).
///
/// The [usePadding] flag controls whether the shape reports extra bottom
/// insets via [dimensions] (20 px) which can be useful when laying out the
/// tooltip to avoid overlap with other UI.
class TooltipApex extends ShapeBorder {
  /// When true the shape reports a bottom padding of 20px via [dimensions].
  final bool usePadding;

  /// Controls whether the apex (arrow) is placed on the top or bottom edge.
  final TooltipAlign tooltipAlign;

  /// Controls whether the apex (arrow) is placed on the left or right.
  final ApexPosition apexPosition;

  /// Create a [TooltipApex].
  ///
  /// - [usePadding] defaults to true and causes [dimensions] to return a
  ///   bottom inset of 20.0.
  /// - [tooltipAlign] selects apex placement and defaults to [TooltipAlign.bottom].
  const TooltipApex(
      {this.usePadding = true,
      this.tooltipAlign = TooltipAlign.bottom,
      this.apexPosition = ApexPosition.center});

  /// The extra space the shape requires. When [usePadding] is true this
  /// returns an [EdgeInsets] with 20px on the bottom; otherwise zero.
  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 20 : 0);

  /// The inner path is not used for this shape so an empty [Path] is returned.
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  /// Build the outer path for the shape including the rounded rectangle and
  /// the triangular apex.
  ///
  /// Implementation details:
  /// - The provided [rect] is shrunk by 20px on the bottom to reserve space
  ///   for the apex.
  /// - A rounded rectangle is created using a corner radius proportional to
  ///   the rectangle height (rect.height / 10).
  /// - A small triangular apex is appended to the rounded rectangle. The
  ///   triangle is positioned near the horizontal center of the top or bottom
  ///   edge depending on [tooltipAlign].
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // Reduce the bottom edge to leave room for the apex triangle.
    rect = Rect.fromPoints(
      rect.topLeft,
      rect.bottomRight - const Offset(0, 20),
    );

    // Rounded rectangle base for the tooltip body.
    Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 10)),
      );

    // Draw the triangular apex. Coordinates are relative to the modified rect.
    if (tooltipAlign == TooltipAlign.bottom) {
      // Apex on the bottom edge pointing downward.
      Offset offset = rect.topCenter;
      double x = offset.dx - 20, y = offset.dy;
      if (apexPosition == ApexPosition.left) {
        offset = rect.topLeft;
        // Adjusting the x-axis to prevent positioning to the end.
        x = offset.dx + 10;
      } else if (apexPosition == ApexPosition.right) {
        offset = rect.topRight;
        x = offset.dx - 30;
      }
      // Apex on the top edge pointing upward.
      path
        ..moveTo(x, y)
        ..relativeLineTo(20, 0)
        ..relativeLineTo(-10, -10)
        ..close();
    } else {
      // Apex on the bottom edge pointing downward.
      Offset offset = rect.bottomCenter;
      double x = offset.dx - 10, y = offset.dy;
      if (apexPosition == ApexPosition.left) {
        offset = rect.bottomLeft;
        // Adjusting the x-axis to prevent positioning to the end.
        x = offset.dx + 10;
      } else if (apexPosition == ApexPosition.right) {
        offset = rect.bottomRight;
        x = offset.dx - 30;
      }

      path
        ..moveTo(x, y)
        ..relativeLineTo(10, 10)
        ..relativeLineTo(10, -10)
        ..close();
    }

    return path;
  }

  /// No custom painting beyond the path is required; this method is a no-op.
  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  /// Scaling is not supported for this shape; return this instance.
  @override
  ShapeBorder scale(double t) => this;
}
