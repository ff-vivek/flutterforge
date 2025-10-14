import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/constants/app_spacing.dart';
import 'package:vivek_yadav/core/constants/app_dimensions.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';
import 'package:vivek_yadav/core/extensions/color_extensions.dart';

/// Reusable technology/skill chip
class TechChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool compact;
  
  const TechChip({
    super.key,
    required this.label,
    this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? context.colorScheme.primary;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: compact ? AppSpacing.xxs : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: chipColor.subtle,
        borderRadius: BorderRadius.circular(
          compact ? AppSpacing.sm : AppDimensions.radiusXl,
        ),
      ),
      child: Text(
        label,
        style: (compact ? context.textTheme.labelSmall : context.textTheme.bodyMedium)?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
