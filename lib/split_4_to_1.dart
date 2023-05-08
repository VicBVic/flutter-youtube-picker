import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Split4To1 extends StatelessWidget {
  final Widget top, bottom;

  const Split4To1({super.key, required this.top, required this.bottom});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Flexible(
        child: top,
        flex: 4,
      ),
      Flexible(
        child: bottom,
        flex: 1,
      ),
    ]);
  }
}
