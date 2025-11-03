# Custom Flutter Tooltip

A highly customizable tooltip implementation for Flutter applications that provides enhanced control over tooltip
appearance and behavior. Unlike Flutter's default tooltip, this package allows complete customization of the tooltip's
shape, position, and content.

## Features

- Fully customizable tooltip design
- Custom tooltip shapes with arrow indicators
- Support for both top and bottom tooltip positioning
- Customizable background and barrier colors
- Smooth fade in/out animations
- Multiple tooltip management system
- Built-in pagination support for tooltip content
- Responsive design support

## Installation

Add this dependency to your `pubspec.yaml` file:

```
yaml dependencies: mtooltip: ^0.0.1 responsive_sizer: ^3.1.1
``` 

## Requirements

- Dart SDK: >=2.18.0 <3.0.0
- Flutter: >=1.17.0
- responsive_sizer: ^3.1.1

## Usage

### Basic Tooltip

```
MTooltip( context: context, tooltipContent: Text('Simple tooltip content'), backgroundColor: Colors.blue, child: Icon(Icons.info), );
latex_unknown_tag
``` 

### Advanced Tooltip with Custom Card

```
MTooltip( context: context, tooltipContent: MTooltipCard( title: 'Welcome to the app!', titleColor: Colors.white, paginationLimit: 3, pagination: 1, index: 0, onTap: (index) { // Handle pagination }, ), backgroundColor: Colors.black87, tooltipAlign: TooltipAlign.TOP, barrierDismissible: true, );
latex_unknown_tag
``` 

### Tooltip Positioning

```
// Bottom aligned tooltip 
MTooltip( tooltipAlign: TooltipAlign.BOTTOM,...);
// Top aligned tooltip 
MTooltip( tooltipAlign: TooltipAlign.TOP, ...);
``` 

### Available Properties

- `context` (required): The build context
- `child` (required): The widget that triggers the tooltip
- `tooltipContent` (required): The content to be displayed in the tooltip
- `backgroundColor` (required): Background color of the tooltip
- `barrierColor` (optional): Color of the modal barrier (default: 80% black)
- `barrierDismissible` (optional): Whether clicking outside dismisses the tooltip (default: true)
- `usePadding` (optional): Enable/disable padding (default: true)
- `tooltipAlign` (optional): Alignment of the tooltip (TOP or BOTTOM, default: BOTTOM)

## Testing

To run the tests:

```
flutter test
``` 

## Contributing

We welcome contributions to improve this tooltip package! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please make sure to update tests as appropriate and follow the existing coding style.

## License

```
MIT License
Copyright (c) 2021
