import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mtooltip/controller/mtooltip_controller.dart';
import 'package:mtooltip/mtooltip_position_delegate.dart';

import 'tooltip_custom_shape.dart';

class MTooltip extends StatefulWidget {

  final bool useDefaultPadding;

  final TooltipAlign tooltipAlign;

  final Widget child;

  final BuildContext context;

  final Color barrierColor;

  final Color backgroundColor;

  final bool barrierDismissible;

  final Widget tooltipContent;

  late Duration showDuration;
  late Duration waitDuration;

  final MTooltipController _mTooltipController;

  Duration fadeInDuration;
  Duration fadeOutDuration;

  MTooltip({
    super.key,
    required this.child,
    required this.context,
    required this.tooltipContent,
    this.backgroundColor = Colors.black54,
    required MTooltipController mTooltipController,
    Duration? showDuration,
    Duration? waitDuration,
    Duration? fadeInDuration,
    Duration? fadeOutDuration,
    this.barrierColor = const Color(0x80000000),
    this.barrierDismissible = true,
    this.useDefaultPadding = true,
    this.tooltipAlign = TooltipAlign.bottom,
  }) : _mTooltipController = mTooltipController,
       waitDuration = waitDuration ?? Duration(seconds: 0),
       fadeInDuration = fadeInDuration ?? Duration(seconds: 1),
       fadeOutDuration = fadeOutDuration ?? Duration(seconds: 1),
       showDuration = showDuration ?? Duration(seconds: 10);

  @override
  State<MTooltip> createState() => MTooltipState(_mTooltipController);
}

class MTooltipState extends State<MTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  OverlayEntry? _entry;
  Timer? _dismissTimer;
  Timer? _showTimer;

  late bool _mouseIsConnected;
  late bool _isConcealed;
  late bool _forceRemoval;
  late bool _visible;

  MTooltipController mTooltipController;

  OverlayState? overlayState;

  MTooltipState(this.mTooltipController);

  @override
  void initState() {
    super.initState();
    _isConcealed = false;
    // _forceRemoval = false;
    // _mouseIsConnected = RendererBinding.instance.mouseTracker.mouseIsConnected;
    _controller = AnimationController(
      duration: widget.fadeInDuration,
      reverseDuration: widget.fadeOutDuration,
      vsync: this,
    );

    mTooltipController.attach(this);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _visible = TooltipVisibility.of(context);
  }

  @override
  void didUpdateWidget(covariant MTooltip oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // Rebuild Widget on changes requested
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
    return IndexedSemantics(index: 99, child: widget.child);
  }

  _newEntry() {
    final translation = widget.context
        .findRenderObject()
        ?.getTransformTo(null)
        .getTranslation();
    final mediaQuery = MediaQuery.of(context).size;

    RenderBox parentBox = widget.context.findRenderObject() as RenderBox;

    overlayState = Overlay.of(context, debugRequiredFor: widget);

    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState?.context.findRenderObject(),
    );

    var tooltipWidget = createWidget();

    var positionedWidget = Positioned.fill(
      bottom: MediaQuery.maybeOf(context)?.viewInsets.bottom ?? 0.0,
      child: CustomSingleChildLayout(
        delegate: MTooltipPositionDelegate(
          target: target,
          verticalOffset: (widget.tooltipAlign == TooltipAlign.bottom)
              ? 0.0
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
            child: Padding(
              padding: widget.useDefaultPadding
                  ? const EdgeInsets.only(
                      left: 4.0,
                      right: 4.0,
                      top: 8.0,
                      bottom: 8.0,
                    )
                  : const EdgeInsets.all(0.0),
              child: widget.tooltipContent,
            ),
          ),
        ),
      ),
    );
  }

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
      return Future.value();
    }

    return _controller.reverse().then((_) {
      if (_entry != null) {
        _entry!.remove();
      }
    });
  }

  bool _showTooltip() {
    if (!_visible || !mounted) {
      return false;
    }
    _showTimer?.cancel();
    _showTimer = null;
    if (_entry == null) {
      _newEntry();
    }
    overlayState!.insert(_entry!);
    _controller.forward();
    _isConcealed = false;

    if (widget.showDuration.inSeconds != 0) {
      _dismissTimer ??= Timer(widget.showDuration, _concealTooltip);
    }
    return true;
  }

  void dismiss() {
    // MTooltip._openedTooltips.remove(this);
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _showTimer?.cancel();
    _showTimer = null;
    if (!_isConcealed) {
      _entry?.remove();
    }
    _isConcealed = false;
    _entry = null;
  }

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
