
# mtooltip

A lightweight, highly-customizable tooltip widget for Flutter with support for top/bottom positioning, controllers, and rich content.

Quick links
- Widget: [`MTooltip`](lib/src/core/mtooltip.dart) — [lib/mtooltip.dart](lib/src/core/mtooltip.dart)
- Card helper: [`MTooltipCard`](lib/src/core/mtooltip_card.dart) — [lib/mtooltip_card.dart](lib/src/core/mtooltip_card.dart)
- Shape & alignment: [`ToolTipCustomShape`](lib/src/core/tooltip_apex.dart), [`TooltipAlign`](lib/src/core/tooltip_apex.dart) — [lib/tooltip_custom_shape.dart](lib/src/core/tooltip_apex.dart)
- Positioning delegate: [`MTooltipPositionDelegate`](lib/src/core/mtooltip_position_delegate.dart) — [lib/mtooltip_position_delegate.dart](lib/src/core/mtooltip_position_delegate.dart)
- Controller API: [`MTooltipController`](lib/src/controller/mtooltip_controller.dart), impl [`IMTooltipController`](lib/src/controller/mtooltip_controller_impl.dart) — [lib/controller/mtooltip_controller.dart](lib/src/controller/mtooltip_controller.dart)

## Features
- Custom shape with arrow indicator (top / bottom)
- Attach a controller to programmatically show / remove tooltips
- Accepts any widget as tooltip content (cards, texts, images, etc.)
- Fade-in/out animation and configurable timings
- Example app included: [example/lib/main.dart](example/lib/main.dart)

Installation
Add this package to your project's pubspec.yaml:
```yaml
dependencies:
  mtooltip:
    path: ../   
```

## Requirements
- Dart SDK: ^3.9.2 (see package pubspec) — [pubspec.yaml](pubspec.yaml)
- Flutter: >=1.17.0

## Basic usage
```dart
final controller = MTooltipController();

MTooltip(
  context: context,
  child: Icon(Icons.info),
  tooltipContent: const Text('Simple tooltip content'),
  backgroundColor: Colors.blue,
  mTooltipController: controller,
);
```

## Programmatic control
Use the controller to show or remove the tooltip:
```dart
controller.show();
controller.remove();
```
Controller API: [`MTooltipController.show`](lib/src/controller/mtooltip_controller.dart) and [`MTooltipController.remove`](lib/src/controller/mtooltip_controller.dart).

## Advanced usage (custom card)
```dart
final controller = MTooltipController();

MTooltip(
  context: context,
  mTooltipController: controller,
  tooltipAlign: TooltipAlign.top,
  backgroundColor: Colors.black87,
  tooltipContent: Container(
    child: Column(
        children: [
            Text("This is a Tooltip"),
            IconButton(
                onPressed: () {
                    mc1.remove();
                    mc2.show();
            },
            icon: Icon(Icons.navigate_next),
        ),
    ]),
  ),
  child: const Text('Tap to show tooltip'),
);
```
See [`MTooltipCard`](lib/src/core/mtooltip_card.dart) for the card structure.

## API notes
- The main widget is [`MTooltip`](lib/src/core/mtooltip.dart).
- Alignment choices are provided by [`TooltipAlign`](lib/src/core/tooltip_apex.dart).
- Positioning is computed by [`MTooltipPositionDelegate`](lib/src/core/mtooltip_position_delegate.dart).
- Attach a controller using the `mTooltipController` constructor parameter; the controller factory is [`MTooltipController()`](lib/src/controller/mtooltip_controller.dart).

## Example and testing
- Run the example app in `example/` — see [example/lib/main.dart](example/lib/main.dart).
- Run unit tests:
```sh
flutter test
```
Tests live at [test/mtooltip_test.dart](test/mtooltip_test.dart).

## Contributing
Contributions are welcome. Please follow standard fork/branch/PR workflow and update or add tests where appropriate.

## License
This project is MIT-licensed — see [LICENSE](LICENSE).
