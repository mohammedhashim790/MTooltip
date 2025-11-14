import 'package:mtooltip/controller/mtooltip_controller.dart';
import 'package:mtooltip/mtooltip.dart';

/// Concrete implementation of [MTooltipController].
///
/// This controller is intended to be provided to the [MTooltip] widget and
/// attached to the widget's internal state. Calls to [show] and [remove]
/// are forwarded to the attached [MTooltipState]. If no state is attached
/// the methods are no-ops.
class IMTooltipController implements MTooltipController {
  IMTooltipController();

  MTooltipState? _state;

  /// Attach the controller to the live [MTooltipState].
  ///
  /// The controller will forward subsequent [show] and [remove] calls to the
  /// provided state instance.
  @override
  void attach(MTooltipState state) {
    _state = state;
  }

  /// Request the tooltip to be shown.
  ///
  /// If no [MTooltipState] is attached this method does nothing.
  @override
  void show() {
    _state?.show();
  }

  /// Request the tooltip to be removed/dismissed.
  ///
  /// Delegates to the attached state's [dismiss] method. If no state is
  /// attached this method is a no-op.
  @override
  void remove() {
    _state?.dismiss();
  }
}
