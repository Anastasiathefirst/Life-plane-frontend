import 'dart:ui';
import 'package:flutter/material.dart';

class CustomGlassContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final BorderRadius borderRadius;
  final double blur;
  final double opacity;

  const CustomGlassContainer({
    super.key,
    required this.width,
    required this.height,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.blur = 15.0,
    this.opacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: child,
        ),
      ),
    );
  }
}
