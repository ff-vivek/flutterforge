import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/constants/app_dimensions.dart';
import 'package:vivek_yadav/core/extensions/color_extensions.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';

/// Reusable glass-morphism card with optional border and shadow
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool showBorder;
  final bool showShadow;
  final Color? backgroundColor;
  
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.showBorder = true,
    this.showShadow = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppDimensions.radiusLg;
    
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder
          ? Border.all(color: context.colorScheme.outline.light)
          : null,
        boxShadow: showShadow ? [
          BoxShadow(
            color: context.theme.shadowColor.subtle,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: child,
    );
  }
}
