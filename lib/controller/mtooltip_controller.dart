import 'package:mtooltip/controller/mtooltip_controller_impl.dart';
import 'package:mtooltip/mtooltip.dart';

abstract class MTooltipController {
  void show();

  void remove();

  void attach(MTooltipState widget);

  factory MTooltipController() => IMTooltipController();
}
