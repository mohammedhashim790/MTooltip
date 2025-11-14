import '../controller/mtooltip_controller_impl.dart';
import '../core/mtooltip.dart';

/// Controller interface for driving an [MTooltip] instance.
///
/// Implementations of this interface can be attached to an [MTooltipState]
/// and provide a simple programmatic API to show or remove the tooltip.
///
/// Usage:
/// ```dart
/// final controller = MTooltipController(); // returns IMTooltipController
/// // Provide `controller` to an MTooltip instance.
/// controller.show();
/// controller.remove();
/// ```
abstract class MTooltipController {
  /// Show the attached tooltip.
  ///
  /// If no [MTooltipState] is attached this call is a no-op.
  void show();

  /// Remove / dismiss the attached tooltip immediately.
  ///
  /// If no [MTooltipState] is attached this call is a no-op.
  void remove();

  /// Attach a live [MTooltipState] to this controller.
  ///
  /// The controller will forward subsequent [show] and [remove] calls to the
  /// provided state instance.
  void attach(MTooltipState widget);

  /// Factory constructor that returns the default implementation.
  ///
  /// Currently returns an instance of [IMTooltipController].
  factory MTooltipController() => IMTooltipController();
}
