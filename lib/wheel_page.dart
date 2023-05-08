import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:youtube_picker/split_4_to_1.dart';

class WheelPage extends StatefulWidget {
  WheelPage({super.key});

  @override
  State<WheelPage> createState() => _WheelPageState();
}

class _WheelPageState extends State<WheelPage>
    with SingleTickerProviderStateMixin {
  final StreamController<int> wheelController = StreamController();
  final List<Widget> wheelWidgets = [
    Text("Instant Death"),
    Text("Win 1000 dollars"),
    Text(" Spin Again"),
    Text("Free coupon"),
    Text("JACKPOT: Honda Civic"),
  ];
  late final AnimationController passiveSpinController;
  late final Stream<int> wheelStream;
  final Random rng = Random.secure();

  final double fakeoutPercent = 0.5;

  bool isFakeout = false;

  @override
  void initState() {
    passiveSpinController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    passiveSpinController.repeat();

    wheelStream = wheelController.stream.asBroadcastStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Song Picker '),
      ),
      body: Split4To1(
        top: Stack(
          children: [
            RotationTransition(
              turns: passiveSpinController,
              child: FortuneWheel(
                selected: wheelStream,
                animateFirst: false,
                curve: FortuneCurve.spin,
                indicators: [],
                items: wheelWidgets.map((e) => FortuneItem(child: e)).toList(),
                onAnimationStart: () {
                  if (isFakeout) {
                    passiveSpinController.animateTo(0.2,
                        duration: Duration(seconds: 3));
                  } else {
                    passiveSpinController.stop();
                  }
                },
                onAnimationEnd: () {
                  if (isFakeout) {
                    passiveSpinController.animateTo(0.0,
                        duration: Duration(seconds: 3),
                        curve: Curves.bounceOut);
                  }
                },
              ),
            ),
            Align(alignment: Alignment.topCenter, child: TriangleIndicator()),
          ],
        ),
        bottom: Center(
          child: ElevatedButton(
            child: const Text(
              "SPIN",
              textScaleFactor: 3.0,
            ),
            onPressed: () {
              wheelController.add(0);
              setState(() {
                isFakeout = rng.nextDouble() <= fakeoutPercent;
              });
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith(
                  (states) => states.contains(MaterialState.hovered)
                      ? 15.0
                      : states.contains(MaterialState.dragged)
                          ? 5.0
                          : 7.0),
              shadowColor:
                  MaterialStateColor.resolveWith((states) => Colors.black),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
