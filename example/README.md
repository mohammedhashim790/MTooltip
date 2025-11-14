# mtooltip_example

A comprehensive example application demonstrating the features and usage of the **mtooltip** package.

## Overview

This example app showcases how to integrate and use the `MTooltip` widget in a Flutter application. It demonstrates basic usage, programmatic control via controllers, custom positioning, and rich content rendering.

## Features Demonstrated

- **Basic Tooltip**: Simple tooltip with text content
- **Controller Integration**: Show/remove tooltips programmatically
- **Custom Positioning**: Top and bottom alignment options
- **Custom Styling**: Background colors, animations, and timing
- **Rich Content**: Using cards, images, and complex widgets as tooltip content
- **Fade Animations**: Configurable fade-in/out durations

## Getting Started

### Prerequisites

- Flutter SDK: >=1.17.0
- Dart SDK: ^3.9.2

### Installation

1. Navigate to the example directory:
```bash
cd example
```

2. Install dependencies:
```bash
flutter pub get
```

### Running the App

Run the example on your connected device or emulator:

```bash
flutter run
```

Or run with verbose output for debugging:

```bash
flutter run -v
```

## Project Structure

```
example/
├── lib/
│   └── main.dart          # Main entry point and example screens
├── pubspec.yaml           # Project dependencies
└── README.md              # This file
```

## Code Examples

### Basic Usage

```dart
final controller = MTooltipController();

MTooltip(
  context: context,
  child: Icon(Icons.info),
  tooltipContent: const Text('Hover over me!'),
  backgroundColor: Colors.blue,
  mTooltipController: controller,
);
```

### Programmatic Control

```dart
// Show the tooltip
controller.show();

// Remove the tooltip after 2 seconds
Future.delayed(Duration(seconds: 2), () {
  controller.remove();
});
```

### Custom Positioning

```dart
MTooltip(
  context: context,
  tooltipAlign: TooltipAlign.top,
  child: ElevatedButton(
    onPressed: () {},
    child: Text('Button'),
  ),
  tooltipContent: Text('This tooltip appears above!'),
);
```

### Advanced: Rich Content Card

```dart
MTooltip(
  context: context,
  backgroundColor: Colors.black87,
  tooltipContent: MTooltipCard(
    title: 'Welcome to MTooltip!',
    titleColor: Colors.white,
    paginationLimit: 3,
    pagination: 1,
    index: 0,
    onTap: (index) {
      print('Card tapped at index: $index');
    },
  ),
  child: Text('Tap for card tooltip'),
);
```

## Testing

Run the included unit tests:

```bash
cd ..
flutter test
```

Tests validate tooltip behavior, controller attachment, and animation timings.

## Troubleshooting

### Tooltip not appearing
- Ensure the `context` parameter refers to a valid widget context with an available render object.
- Check that the parent widget has an `Overlay` ancestor (most apps do via `MaterialApp`).

### Animation issues
- Verify `fadeInDuration` and `fadeOutDuration` are set to reasonable values.
- Confirm the animation controller is properly initialized.

### Controller not working
- Ensure the controller is passed to `MTooltip` before calling `show()` or `remove()`.
- Verify the state is properly mounted before invoking controller methods.

## Contributing

Contributions and improvements to the example are welcome. Please follow standard fork/branch/PR workflow.

## License

This example is part of the mtooltip package and is MIT-licensed — see [LICENSE](../LICENSE).

## Additional Resources

- [MTooltip Package Documentation](../README.md)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)

