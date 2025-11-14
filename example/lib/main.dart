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
  MTooltipController mc1 = MTooltipController();
  MTooltipController mc2 = MTooltipController();

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
                  mc1.show();
                },
                child: const Text("Click to Show Bottom"),
              ),
              Align(
                alignment: Alignment.center,
                child: MTooltip(
                  context: context,
                  backgroundColor: Colors.blue,
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
                      ],
                    ),
                  ),
                  tooltipAlign: TooltipAlign.top,
                  useDefaultPadding: true,
                  waitDuration: Duration(seconds: 1),
                  fadeInDuration: Duration(seconds: 2),
                  showDuration: Duration(seconds: 4),
                  mTooltipController: mc1,
                  child: const Text("Explain this sentence"),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: MTooltip(
                  context: context,
                  backgroundColor: Colors.black,
                  tooltipContent: Container(
                    child: Column(
                      children: [
                        Text(
                          "This is a Tooltip",
                          style: TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {
                            mc2.remove();
                            mc1.show();
                          },
                          icon: Icon(Icons.navigate_next),
                        ),
                      ],
                    ),
                  ),
                  tooltipAlign: TooltipAlign.bottom,
                  useDefaultPadding: true,
                  waitDuration: Duration(seconds: 1),
                  fadeInDuration: Duration(seconds: 2),
                  showDuration: Duration(seconds: 4),
                  mTooltipController: mc2,
                  child: const Text("Navigate Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
