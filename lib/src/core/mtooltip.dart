import 'dart:async';

import 'package:flutter/material.dart';

import '../../mtooltip.dart';
import 'mtooltip_position_delegate.dart';

/// Function for when a tooltip is displayed.
typedef MTooltipShowCallBack = void Function();

/// Function for when a tooltip is displayed.
typedef MTooltipDismissCallBack = void Function();

/// A lightweight tooltip widget that displays [tooltipContent] in an [Overlay]
/// positioned relative to the [child] widget's [BuildContext].
///
/// Use an [MTooltipController] (passed as `mTooltipController`) to show or hide
/// the tooltip programmatically. Alignment (top/bottom), visual appearance and
/// timing are configurable via constructor parameters.
class MTooltip extends StatefulWidget {
  /// Applies default padding inside the tooltip content when true:
  /// left: 4.0, right: 4.0, top: 4.0, bottom: 4.0.
  EdgeInsets? padding;

  /// Preferred alignment of the tooltip relative to the target (top or bottom).
  final TooltipAlign tooltipAlign;

  /// The widget that the tooltip is attached to. This widget is returned from
  /// build() and remains in the widget tree while the tooltip may be shown.
  final Widget child;

  /// The [BuildContext] of the target used to compute overlay positioning.
  ///
  /// Note: this must refer to a context whose render object is available when
  /// showing the tooltip.
  final BuildContext context;

  /// Shadow for the tooltip
  /// Default will be set to [Colors.black45], [SpreadRadius=1.0], [BlurRadius=8.0], [BlurStyle.normal]
  final BoxShadow? shadow;

  /// Background color of the tooltip content container.
  final Color backgroundColor;

  /// Whether tapping the barrier dismisses the tooltip.
  final bool barrierDismissible;

  /// Arbitrary widget used as the tooltip's content (card, text, images, etc).
  final Widget tooltipContent;

  /// How long the tooltip remains visible after being shown (0 = persist until removed).
  final Duration showDuration;

  /// Delay before showing the tooltip when `show()` is called (debounce).
  final Duration waitDuration;

  /// Controller used to interact with this instance (show/remove).
  final MTooltipController _mTooltipController;

  /// Duration used for the fade-in animation.
  final Duration fadeInDuration;

  /// Duration used for the fade-out animation.
  final Duration fadeOutDuration;

  /// Callback when the tooltip is rendered / displayed
  MTooltipShowCallBack? onRendered = () => {};

  /// Callback when the tooltip is dimissed
  MTooltipDismissCallBack? onDismiss = () => {};

  /// Create an [MTooltip].
  ///
  /// - `mTooltipController` is required and will be attached to this state so
  ///   your UI code can call `show()` / `remove()` programmatically.
  /// - If `showDuration` is zero seconds the tooltip will not auto-dismiss.
  /// - `tooltipAlign` controls whether the tooltip prefers to appear above or
  ///   below the target.
  MTooltip({
    super.key,
    required this.child,
    required this.context,
    required this.tooltipContent,
    required MTooltipController mTooltipController,
    this.shadow,
    this.padding,
    this.onRendered,
    this.onDismiss,
    this.backgroundColor = Colors.black54,
    this.barrierDismissible = true,
    this.tooltipAlign = TooltipAlign.bottom,
    Duration? showDuration,
    Duration? waitDuration,
    Duration? fadeInDuration,
    Duration? fadeOutDuration,
  })  : _mTooltipController = mTooltipController,
        waitDuration = waitDuration ?? Duration(seconds: 0),
        fadeInDuration = fadeInDuration ?? Duration(seconds: 1),
        fadeOutDuration = fadeOutDuration ?? Duration(seconds: 1),
        showDuration = showDuration ?? Duration(seconds: 10);

  @override
  State<MTooltip> createState() => MTooltipState();
}

/// State implementation for [MTooltip]. Manages overlay entry creation,
/// animations, timers and controller attachment.
///
/// The state exposes methods used by [MTooltipController] to show / dismiss the
/// tooltip and handles lifecycle events to keep overlay state consistent.
class MTooltipState extends State<MTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  OverlayEntry? _entry;
  Timer? _dismissTimer;
  Timer? _showTimer;

  late bool _isConcealed;
  late bool _visible;

  /// Controller instance attached to this state for external control.
  late MTooltipController mTooltipController;

  /// Cached overlay state used to insert the tooltip entry.
  OverlayState? overlayState;

  @override
  void initState() {
    super.initState();
    _isConcealed = false;
    // Animation controller used for fade transitions.
    _controller = AnimationController(
      duration: widget.fadeInDuration,
      reverseDuration: widget.fadeOutDuration,
      vsync: this,
    );
    mTooltipController = widget._mTooltipController;

    // Attach this state to the external controller so UI callers can trigger
    // show/remove.
    mTooltipController.attach(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Determine whether tooltips are globally visible in this context (uses
    // TooltipVisibility from the widget tree).
    _visible = TooltipVisibility.of(context);
  }

  @override
  void didUpdateWidget(covariant MTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If a tooltip is currently shown and the widget updates, remove the
    // existing entry and create a fresh one that reflects the updated params.
    if (_entry != null) {
      _concealTooltip(immediately: true).then((_) => _newEntry());
    }
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    // Return the child unchanged; tooltip is rendered via an OverlayEntry.
    return IndexedSemantics(index: 99, child: widget.child);
  }

  /// Build a new [OverlayEntry] for the tooltip and assign to [_entry].
  ///
  /// The method computes the target position using the provided `widget.context`
  /// and wraps the tooltip content in a [CustomSingleChildLayout] that uses
  /// [MTooltipPositionDelegate] to position the overlay.
  void _newEntry() {
    final viewPort = MediaQuery.of(context).size;

    overlayState = Overlay.of(context, debugRequiredFor: widget);

    final RenderBox self = context.findRenderObject()! as RenderBox;
    final Offset selfOffset = self.localToGlobal(
      self.size.center(Offset.zero),
      ancestor: overlayState?.context.findRenderObject(),
    );

    final Size selfBounds = self.size;
    if (selfOffset.dx < 0 ||
        selfOffset.dy < 0 ||
        selfOffset.dx + selfBounds.width > viewPort.width ||
        selfOffset.dy + selfBounds.height > viewPort.height) {
      // TODO Must adjust apex position Here
      // print('Widget is out of bounds!');
    } else {
      // Use the default or parametrised apex positioning.
      // print('Widget is within bounds.');
    }

    var tooltipWidget = createWidget();

    var positionedWidget = Positioned.fill(
      bottom: MediaQuery.maybeOf(context)?.viewInsets.bottom ?? 0.0,
      child: CustomSingleChildLayout(
        delegate: MTooltipPositionDelegate(
          target: selfOffset,
          verticalOffset:
              (widget.tooltipAlign == TooltipAlign.bottom) ? 20.0 : 10.0,
          preferBelow: widget.tooltipAlign == TooltipAlign.bottom,
        ),
        child: IntrinsicWidth(child: IntrinsicHeight(child: tooltipWidget)),
      ),
    );

    final Widget overlay = Directionality(
      textDirection: Directionality.of(context),
      child: positionedWidget,
    );

    _entry = OverlayEntry(
      builder: (BuildContext context) => overlay,
      opaque: false,
      maintainState: true,
    );
  }

  /// Create the widget that is inserted into the overlay for display.
  ///
  /// Wraps [widget.tooltipContent] in a shaped container and applies a
  /// [FadeTransition] controlled by [_controller].
  Widget createWidget() {
    return Material(
      color: Colors.transparent,
      child: FadeTransition(
        opacity: _controller,
        child: IndexedSemantics(
          index: 100,
          child: Container(
            decoration: ShapeDecoration(
              color: widget.backgroundColor,
              shadows: [
                widget.shadow ??
                    BoxShadow(
                        color: Colors.black45,
                        spreadRadius: 1.0,
                        blurRadius: 8.0,
                        blurStyle: BlurStyle.normal)
              ],
              shape: TooltipApex(tooltipAlign: widget.tooltipAlign),
            ),
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.only(
                    left: 4.0,
                    right: 4.0,
                    top: 4.0,
                    bottom: 4.0,
                  ),
              child: widget.tooltipContent,
            ),
          ),
        ),
      ),
    );
  }

  /// Conceal the tooltip.
  ///
  /// If [immediately] is true the overlay entry is removed without running the
  /// fade-out animation. Otherwise the animation controller is reversed and
  /// the entry removed when the reverse completes.
  Future<void> _concealTooltip({bool immediately = false}) {
    if (_isConcealed) {
      return Future.value();
    }
    _isConcealed = true;

    _dismissTimer?.cancel();
    _dismissTimer = null;
    _showTimer?.cancel();
    _showTimer = null;

    if (immediately) {
      _entry!.remove();
      widget.onDismiss?.call();
      return Future.value();
    }

    return _controller.reverse().then((_) {
      if (_entry != null) {
        _entry!.remove();
        widget.onDismiss?.call();
      }
    });
  }

  /// Insert the overlay entry and start the fade-in animation.
  ///
  /// Returns true if the tooltip was shown. The tooltip will not be shown if
  /// [TooltipVisibility.of] in this context is false or this state is not
  /// mounted.
  bool _showTooltip() {
    if (!_visible || !mounted) {
      return false;
    }
    _showTimer?.cancel();
    _showTimer = null;
    // if (_entry == null) {
    _newEntry();
    // }
    overlayState!.insert(_entry!);
    _controller.forward().then((_) => widget.onRendered?.call());
    _isConcealed = false;

    if (widget.showDuration.inSeconds != 0) {
      _dismissTimer ??= Timer(widget.showDuration, _concealTooltip);
    }
    return true;
  }

  /// Forcefully remove timers and overlay entry without animation.
  void dismiss() {
    _concealTooltip();
  }

  /// Public API used by the attached [MTooltipController] to show the tooltip.
  ///
  /// If [immediately] is true the tooltip is shown right away; otherwise the
  /// widget waits for `widget.waitDuration` before showing (debounced).
  void show({bool immediately = false}) {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (immediately) {
      _showTooltip();
      return;
    }
    _showTimer ??= Timer(widget.waitDuration, _showTooltip);
  }

  @override
  void dispose() {
    super.dispose();
    dismiss();
  }
}
