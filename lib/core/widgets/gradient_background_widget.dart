import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;
  final List<double>? stops;

  const GradientBackground({
    required this.child,
    this.colors = const [Color(0xFF191244), Colors.white],
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.stops,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
          stops: stops,
        ),
      ),
      child: child,
    );
  }
}
