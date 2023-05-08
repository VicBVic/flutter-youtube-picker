import 'dart:async';

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
  late final AnimationController passiveSpinController;
  late final Stream<int> wheelStream;

  @override
  void initState() {
    passiveSpinController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    passiveSpinController.repeat();

    wheelStream = wheelController.stream.asBroadcastStream();

    wheelStream.listen((event) {
      passiveSpinController
          .animateTo(0.0)
          .then((value) => passiveSpinController.stop());
    });
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
                indicators: [],
                items: const [
                  FortuneItem(child: Text('Numarul 1')),
                  FortuneItem(child: Text('Numarul 2')),
                  FortuneItem(child: Text('Numarul 3')),
                ],
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
