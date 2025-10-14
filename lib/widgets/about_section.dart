import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vivek_yadav/services/portfolio_service.dart';
import 'package:vivek_yadav/core/widgets/section_header.dart';
import 'package:vivek_yadav/core/widgets/section_container.dart';
import 'package:vivek_yadav/core/widgets/animated_section.dart';
import 'package:vivek_yadav/core/widgets/stat_card.dart';
import 'package:vivek_yadav/core/constants/app_spacing.dart';
import 'package:vivek_yadav/core/constants/app_dimensions.dart';
import 'package:vivek_yadav/core/constants/app_durations.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';
import 'package:vivek_yadav/core/extensions/color_extensions.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return SectionContainer(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          context.colorScheme.primaryContainer.withValues(alpha: 0.18),
          context.colorScheme.surface,
        ],
      ),
      child: AnimatedSection(
        duration: AppDurations.slow,
        child: Column(
          children: [
            const SectionHeader(title: 'About Me'),
            const SizedBox(height: AppSpacing.xxl),
            Container(
              constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
              child: Text(
                PortfolioService.summary,
                style: context.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: context.colorScheme.onSurface.muted,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.sectionVerticalMobile),
            _buildKeyStatistics(context, isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyStatistics(BuildContext context, bool isDesktop) {
    final stats = PortfolioService.keyStats.entries.toList();
    
    if (!isDesktop) {
      return Column(
        children: stats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          final delay = AppDurations.fast + (AppDurations.fadeInStagger * index);
          
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < stats.length - 1 ? AppSpacing.cardSpacing : 0,
            ),
            child: AnimatedSection(
              delay: delay,
              child: StatCard(
                value: stat.value,
                label: stat.key,
              ),
            ),
          );
        }).toList(),
      );
    }
    
    return ResponsiveGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: ResponsiveGridDelegate(
        crossAxisExtent: 300,
        mainAxisSpacing: AppSpacing.cardSpacing,
        crossAxisSpacing: AppSpacing.cardSpacing,
        childAspectRatio: 2,
        minCrossAxisExtent: 250,
      ),
      alignment: Alignment.center,
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        final delay = AppDurations.fast + (AppDurations.fadeInStagger * index);
        
        return AnimatedSection(
          delay: delay,
          child: StatCard(
            value: stat.value,
            label: stat.key,
          ),
        );
      },
    );
  }
}