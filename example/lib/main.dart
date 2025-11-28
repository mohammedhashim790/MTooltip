import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mtooltip/mtooltip.dart';

void main() {
  runApp(const MyTooltipApp());
}

class MyTooltipApp extends StatelessWidget {
  const MyTooltipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTooltip Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(0, 38, 79, 1.0),
        ),
      ),
      home: const TooltipExample(title: 'MTooltip Example'),
    );
  }
}

class TooltipExample extends StatefulWidget {
  const TooltipExample({super.key, required this.title});

  final String title;

  @override
  State<TooltipExample> createState() => _TooltipExampleState();
}

class _TooltipExampleState extends State<TooltipExample> {
  MTooltipController mc1 = MTooltipController();
  MTooltipController mc2 = MTooltipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: MTooltip(
              context: context,
              backgroundColor: Colors.blue,
              tooltipContent: Row(
                children: [
                  Text("This is a Tooltip"),
                  IconButton(
                    onPressed: () {
                      mc1.remove();
                      mc2.show();
                    },
                    icon: Icon(Icons.navigate_next),
                  ),
                ],
              ),
              tooltipAlign: TooltipAlign.top,
              showDuration: Duration(seconds: 10),
              onRendered: () {
                if (kDebugMode) {
                  print("MC1 Rendered");
                }
              },
              onDismiss: () {
                if (kDebugMode) {
                  print("MC1 Dismiss");
                }
              },
              mTooltipController: mc1,
              child: TextButton(
                onPressed: () {
                  mc2.show();
                },
                child: const Text("Click to Show Tooltip"),
              ),
            ),
          ),
          Positioned(
            left: -10,
            child: MTooltip(
              context: context,
              backgroundColor: Colors.black,
              tooltipContent: Row(
                children: [
                  Text(
                    "This is a Tooltip",
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      // mc2.remove();
                      // mc1.show();
                    },
                    icon: Icon(Icons.navigate_next),
                  ),
                ],
              ),
              onRendered: () {
                if (kDebugMode) {
                  print("MC2 Rendered");
                }
              },
              onDismiss: () {
                if (kDebugMode) {
                  print("MC2 Dismiss");
                }
              },
              tooltipAlign: TooltipAlign.bottom,
              waitDuration: Duration(seconds: 1),
              fadeInDuration: Duration(seconds: 2),
              showDuration: Duration(seconds: 4),
              mTooltipController: mc2,
              child: const Text("Image Tooltip Example"),
            ),
          ),
        ],
      ),
    );
  }
}
