import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/constants/app_spacing.dart';
import 'package:vivek_yadav/core/widgets/glass_card.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';
import 'package:vivek_yadav/core/extensions/color_extensions.dart';

/// Reusable stat/metric card
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final EdgeInsetsGeometry? padding;
  
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => GlassCard(
    padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: context.textTheme.headlineMedium?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: context.textTheme.titleMedium?.copyWith(
            color: context.colorScheme.onSurface.muted,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
