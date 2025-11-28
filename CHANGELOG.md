# Changelog

All notable changes to this project will be documented in this file.

## [1.0.3-beta] - 2025-11-27

### Added
- Included Shadow to Tooltip
- Updated negative vertical offset to 10.0
- onRender and onDismiss Callbacks
- Updated Example
- [New] [TooltipApex](lib/src/constants/apex_position.dart) Position
  [New] autoPosition - a new parameter to auto position tooltip based to avoid overflow constraints. Auto-Positions apex position and overrides [TooltipAlign](lib/src/constants/tooltip_align.dart) parameter.

## [1.0.2-beta] - 2025-11-14

### Added
- Homepage URL updated
- Static Analysis issue from 'pubdev' resolved.

### Notes
- See [README.md](README.md) for usage, API details and example instructions.
- Package is MIT licensed — [LICENSE](LICENSE).

## [1.0.1-beta] - 2025-11-14

### Added
- Initial public beta release of the package.
- Updated README.md
- Unit tests for `MTooltipCard`: [test/mtooltip_test.dart](test/mtooltip_test.dart)

### Notes
- See [README.md](README.md) for usage, API details and example instructions.
- Package is MIT licensed — [LICENSE](LICENSE).

## [1.0.0-beta] - 2025-11-14

### Added
- Initial public beta release of the package.
- Core tooltip widget: [`MTooltip`](lib/src/core/mtooltip.dart) — [lib/src/core/mtooltip.dart](lib/src/core/mtooltip.dart)
- Positioning delegate: [`MTooltipPositionDelegate`](lib/src/core/mtooltip_position_delegate.dart) — [lib/src/core/mtooltip_position_delegate.dart](lib/src/core/mtooltip_position_delegate.dart)
- Tooltip shape with apex: [`TooltipApex`](lib/src/core/tooltip_apex.dart) — [lib/src/core/tooltip_apex.dart](lib/src/core/tooltip_apex.dart)
- Controller API: [`MTooltipController`](lib/src/controller/mtooltip_controller.dart) and implementation [`IMTooltipController`](lib/src/controller/mtooltip_controller_impl.dart) — [lib/src/controller/mtooltip_controller.dart](lib/src/controller/mtooltip_controller.dart), [lib/src/controller/mtooltip_controller_impl.dart](lib/src/controller/mtooltip_controller_impl.dart)
- Example app demonstrating usage: [example/lib/main.dart](example/lib/main.dart)
- Unit tests for `MTooltipCard`: [test/mtooltip_test.dart](test/mtooltip_test.dart)

### Changed
- Exposed package entry points via [lib/mtooltip.dart](lib/mtooltip.dart).

### Deprecated
- `MTooltipCard` marked as deprecated (kept for backward compatibility). See: [lib/src/core/mtooltip_card.dart](lib/src/core/mtooltip_card.dart)

### Notes
- See [README.md](README.md) for usage, API details and example instructions.
- Package is MIT licensed — [LICENSE](LICENSE).
