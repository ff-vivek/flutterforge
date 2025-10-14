import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/config/responsive_config.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';

/// Reusable section container with responsive padding
class SectionContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Gradient? gradient;
  final EdgeInsetsGeometry? customPadding;
  
  const SectionContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.gradient,
    this.customPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    
    return Container(
      padding: customPadding ?? EdgeInsets.symmetric(
        horizontal: ResponsiveConfig.getHorizontalPadding(isDesktop),
        vertical: ResponsiveConfig.getVerticalPadding(isDesktop),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: gradient,
      ),
      child: child,
    );
  }
}
