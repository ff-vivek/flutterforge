import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:vivek_yadav/core/constants/app_durations.dart';

/// Reusable animated wrapper for sections with fade-in effect
class AnimatedSection extends StatelessWidget {
  final Widget child;
  final Duration? delay;
  final Duration? duration;
  
  const AnimatedSection({
    super.key,
    required this.child,
    this.delay,
    this.duration,
  });

  @override
  Widget build(BuildContext context) => FadeInUp(
    delay: delay ?? Duration.zero,
    duration: duration ?? AppDurations.fadeIn,
    child: child,
  );
}
