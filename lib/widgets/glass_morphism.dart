import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';

/// A frosted-glass container with configurable blur and opacity.
class GlassMorphism extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const GlassMorphism({
    super.key,
    required this.child,
    this.blur = 26.0,
    this.opacity = 0.17,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(28);
    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: br,
            border: Border.all(
              color: Colors.white.withOpacity(0.24),
              width: 1.1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 24,
                offset: Offset(0, 10),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}