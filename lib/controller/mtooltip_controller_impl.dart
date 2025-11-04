import 'package:mtooltip/controller/mtooltip_controller.dart';
import 'package:mtooltip/mtooltip.dart';

class IMTooltipController implements MTooltipController {
  @override
  void remove() {
    _state?.dismiss();
  }

  @override
  void show() {
    _state?.show();
  }

  MTooltipState? _state;

  @override
  void attach(MTooltipState state) {
    _state = state;
  }
}
