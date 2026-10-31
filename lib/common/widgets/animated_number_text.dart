import 'package:flutter/material.dart';

class AnimatedNumberText extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final int precision;
  final bool padLeftZeros;
  final int padWidth;
  final Duration duration;
  final Curve curve;

  const AnimatedNumberText({
    super.key,
    required this.value,
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.precision = 0,
    this.padLeftZeros = false,
    this.padWidth = 2,
    this.duration = const Duration(milliseconds: 650),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: value),
      duration: duration,
      curve: curve,
      builder: (context, val, child) {
        String formatted;
        if (precision == 0) {
          final rounded = val.round();
          formatted = padLeftZeros
              ? rounded.toString().padLeft(padWidth, '0')
              : rounded.toString();
        } else {
          formatted = val.toStringAsFixed(precision);
        }
        return Text(
          '$prefix$formatted$suffix',
          style: style,
        );
      },
    );
  }
}