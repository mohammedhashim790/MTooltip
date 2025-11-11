import 'package:flutter/material.dart';
import 'package:mtooltip/controller/mtooltip_controller.dart';
import 'package:mtooltip/mtooltip.dart';
import 'package:mtooltip/tooltip_custom_shape.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  MTooltipController mTooltipController = MTooltipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: IntrinsicHeight(
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  // buttonCarouselController.nextPage();
                  mTooltipController.show();
                },
                child: const Text("Click to Show Bottom"),
              ),
              Align(
                alignment: Alignment.center,
                child: MTooltip(
                  context: context,
                  backgroundColor: Colors.redAccent,
                  tooltipContent: Text("This is a text 12313"),
                  tooltipAlign: TooltipAlign.bottom,
                  child: const Text("This is a text 123"),
                  mTooltipController: mTooltipController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
