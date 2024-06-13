import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LinearPoint extends StatelessWidget {
  const LinearPoint({super.key, required this.point});

  final int point;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Container(
            width: constraints.maxWidth,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xffd9d9d9),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Animate().custom(
            duration: const Duration(milliseconds: 500),
            begin: 0,
            end: constraints.maxWidth * point / 13,
            builder: (context, value, child) {
              return Container(
                width: value,
                height: 5,
                decoration: BoxDecoration(
                  color: point < 5
                      ? const Color(0xffb50f5f)
                      : const Color(0xff0fb520),
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
