import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/widgets/animated_chip.dart';

/// Reusable technology/skill chip with animations
class TechChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool compact;
  final VoidCallback? onTap;
  
  const TechChip({
    super.key,
    required this.label,
    this.color,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedChip(
      label: label,
      color: color,
      compact: compact,
      onTap: onTap,
    );
  }
}
