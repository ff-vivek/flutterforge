import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/constants/app_spacing.dart';
import 'package:vivek_yadav/core/constants/app_dimensions.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';

/// Reusable section header with title and decorative divider
class SectionHeader extends StatelessWidget {
  final String title;
  final TextAlign textAlign;
  
  const SectionHeader({
    super.key,
    required this.title,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        title,
        style: context.textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.colorScheme.onSurface,
        ),
        textAlign: textAlign,
      ),
      const SizedBox(height: AppSpacing.md),
      Container(
        width: AppDimensions.dividerWidth,
        height: AppDimensions.dividerHeight,
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
      ),
    ],
  );
}
