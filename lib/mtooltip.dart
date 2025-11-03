import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'tooltip_custom_shape.dart';

class _MTooltipPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of a tooltip.
  ///
  /// The arguments must not be null.
  _MTooltipPositionDelegate({
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
  }) : assert(target != null),
       assert(verticalOffset != null),
       assert(preferBelow != null);

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset target;

  /// The amount of vertical distance between the target and the displayed
  /// tooltip.
  final double verticalOffset;

  /// Whether the tooltip is displayed below its widget by default.
  ///
  /// If there is insufficient space to display the tooltip in the preferred
  /// direction, the tooltip will be displayed in the opposite direction.
  final bool preferBelow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
    );
  }

  @override
  bool shouldRelayout(_MTooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }
}

class MTooltip extends StatefulWidget {
  final bool usePadding;

  final TooltipAlign tooltipAlign;

  final Widget child;

  final BuildContext context;

  final Color barrierColor;

  final Color backgroundColor;

  static final List<MTooltipState> _openedTooltips = <MTooltipState>[];

  final bool barrierDismissible;

  final Widget tooltipContent;

  const MTooltip({
    super.key,
    required this.child,
    required this.context,
    required this.tooltipContent,
    required this.backgroundColor,
    this.barrierColor = const Color(0x80000000),
    this.barrierDismissible = true,
    this.usePadding = true,
    this.tooltipAlign = TooltipAlign.bottom,
  });

  @override
  State<MTooltip> createState() => MTooltipState();

  static void _concealOtherTooltips(MTooltipState current) {
    if (_openedTooltips.isNotEmpty) {
      // Avoid concurrent modification.
      final List<MTooltipState> openedTooltips = _openedTooltips.toList();
      for (final MTooltipState state in openedTooltips) {
        if (state == current) {
          continue;
        }
        state._concealTooltip();
      }
    }
  }

  static void concealAll() {
    if (_openedTooltips.isNotEmpty) {
      // Avoid concurrent modification.
      final List<MTooltipState> openedTooltips = _openedTooltips.toList();
      for (final MTooltipState state in openedTooltips) {
        state._concealTooltip();
      }
    }
  }

  static void _revealLastTooltip() {
    if (_openedTooltips.isNotEmpty) {
      _openedTooltips.last._revealTooltip();
    }
  }
}

class MTooltipState extends State<MTooltip>
    with SingleTickerProviderStateMixin {
  static const Duration _fadeInDuration = Duration(milliseconds: 500);
  static const Duration _fadeOutDuration = Duration(milliseconds: 250);

  late AnimationController _controller;
  OverlayEntry? _entry;
  Timer? _dismissTimer;
  Timer? _showTimer;
  late Duration _showDuration;
  late Duration _hoverShowDuration;
  late Duration _waitDuration;
  late bool _mouseIsConnected;
  bool _pressActivated = false;
  late TooltipTriggerMode _triggerMode;
  late bool _enableFeedback;
  late bool _isConcealed;
  late bool _forceRemoval;
  late bool _visible;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _isConcealed = false;
    _forceRemoval = false;
    _mouseIsConnected = RendererBinding.instance.mouseTracker.mouseIsConnected;
    _controller = AnimationController(
      duration: _fadeInDuration,
      reverseDuration: _fadeOutDuration,
      vsync: this,
    );
    // ..addStatusListener(_handleStatusChanged);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _visible = TooltipVisibility.of(context);
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return IndexedSemantics(index: 99, child: widget.child);
  }

  show() {
    ensureTooltip();
  }

  _newEntry() {
    final translation = widget.context
        .findRenderObject()
        ?.getTransformTo(null)
        .getTranslation();
    final mediaQuery = MediaQuery.of(context).size;

    RenderBox parentBox = widget.context.findRenderObject() as RenderBox;

    final OverlayState overlayState = Overlay.of(
      context,
      debugRequiredFor: widget,
    );

    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );

    var tooltipWidget = createWidget();

    var positionedWidget = Positioned.fill(
      bottom: MediaQuery.maybeOf(context)?.viewInsets.bottom ?? 0.0,
      child: CustomSingleChildLayout(
        delegate: _MTooltipPositionDelegate(
          target: target,
          verticalOffset: (widget.tooltipAlign == TooltipAlign.bottom)
              ? 80.0
              : 60.0,
          preferBelow: widget.tooltipAlign == TooltipAlign.bottom,
        ),
        child: tooltipWidget,
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
    _isConcealed = false;
    overlayState.insert(_entry!);

    MTooltip.concealAll();
    // assert(!MTooltip._openedTooltips.contains(this));

    if (!MTooltip._openedTooltips.contains(this)) {
      MTooltip._openedTooltips.add(this);
    }
  }

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
              shape: ToolTipCustomShape(tooltipAlign: widget.tooltipAlign),
            ),
            child: widget.tooltipContent,
          ),
        ),
      ),
    );
  }

  void _concealTooltip() {
    if (_isConcealed || _forceRemoval) {
      // Already concealed, or it's being removed.
      return;
    }
    _isConcealed = true;
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _showTimer?.cancel();
    _showTimer = null;
    if (_entry != null) {
      _entry!.remove();
    }
    _controller.reverse();
  }

  bool ensureTooltip() {
    if (!_visible || !mounted) {
      return false;
    }
    _showTimer?.cancel();
    _showTimer = null;
    _forceRemoval = false;
    if (_isConcealed) {
      MTooltip._concealOtherTooltips(this);
      _revealTooltip();
      return true;
    }
    if (_entry != null) {
      // Stop trying to hide, if we were.
      _dismissTimer?.cancel();
      _dismissTimer = null;
      _controller.forward();
      return false; // Already visible.
    }
    _newEntry();
    _controller.forward();
    return true;
  }

  void _revealTooltip() {
    if (!_isConcealed) {
      // Already uncovered.
      return;
    }
    _isConcealed = false;
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _showTimer?.cancel();
    _showTimer = null;
    if (!_entry!.mounted) {
      final OverlayState overlayState = Overlay.of(
        context,
        debugRequiredFor: widget,
      );
      overlayState.insert(_entry!);
    }
    _controller.forward();
  }

  void _dismissTooltip({bool immediately = false}) {
    _showTimer?.cancel();
    _showTimer = null;
    if (immediately) {
      _removeEntry();
      return;
    }
    // So it will be removed when it's done reversing, regardless of whether it is
    // still concealed or not.
    _forceRemoval = true;
    if (_pressActivated) {
      _dismissTimer ??= Timer(_showDuration, _controller.reverse);
    } else {
      _dismissTimer ??= Timer(_hoverShowDuration, _controller.reverse);
    }
    _pressActivated = false;
  }

  void _removeEntry() {
    MTooltip._openedTooltips.remove(this);
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _showTimer?.cancel();
    _showTimer = null;
    if (!_isConcealed) {
      _entry?.remove();
    }
    _isConcealed = false;
    _entry = null;
    if (_mouseIsConnected) {
      MTooltip._revealLastTooltip();
    }
  }

  void _showTooltip({bool immediately = false}) {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (immediately) {
      ensureTooltip();
      return;
    }
    _showTimer ??= Timer(_waitDuration, ensureTooltip);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // GestureBinding.instance.pointerRouter.removeGlobalRoute(_handlePointerEvent);
    // RendererBinding.instance.mouseTracker.removeListener(_handleMouseTrackerChange);
    _removeEntry();
  }
}
