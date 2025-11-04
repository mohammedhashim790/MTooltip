import 'package:carousel_slider/carousel_slider.dart';
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
  GlobalKey<MTooltipState> state = GlobalKey<MTooltipState>();

  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              CarouselSlider(
                items: List.generate(10, (index) {
                  return Text("$index");
                }),
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 2.0,
                  initialPage: 2,
                ),
              ),
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
                  key: state,
                  context: context,
                  tooltipContent: const Text("This is a text"),
                  backgroundColor: Colors.green,
                  tooltipAlign: TooltipAlign.top,
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
