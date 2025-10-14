import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vivek_yadav/services/portfolio_service.dart';
import 'package:vivek_yadav/core/widgets/section_header.dart';
import 'package:vivek_yadav/core/widgets/section_container.dart';
import 'package:vivek_yadav/core/widgets/animated_section.dart';
import 'package:vivek_yadav/core/widgets/animated_stat_card.dart';
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
          final statEntry = entry.value;
          final statData = statEntry.value;
          final delay = AppDurations.fast + (AppDurations.fadeInStagger * index);
          
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < stats.length - 1 ? AppSpacing.cardSpacing : 0,
            ),
            child: AnimatedStatCard(
              value: statData['value'],
              label: statEntry.key,
              icon: _getIconData(statData['icon']),
              iconColor: _getStatColor(context, statData['color']),
              subtitle: statData['subtitle'],
              delay: delay,
            ),
          );
        }).toList(),
      );
    }
    
    return ResponsiveGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: ResponsiveGridDelegate(
        crossAxisExtent: 320,
        mainAxisSpacing: AppSpacing.cardSpacing,
        crossAxisSpacing: AppSpacing.cardSpacing,
        childAspectRatio: 1.3,
        minCrossAxisExtent: 280,
      ),
      alignment: Alignment.center,
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final statEntry = stats[index];
        final statData = statEntry.value;
        final delay = AppDurations.fast + (AppDurations.fadeInStagger * index);
        
        return AnimatedStatCard(
          value: statData['value'],
          label: statEntry.key,
          icon: _getIconData(statData['icon']),
          iconColor: _getStatColor(context, statData['color']),
          subtitle: statData['subtitle'],
          delay: delay,
        );
      },
    );
  }
  
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'work_history':
        return Icons.work_history;
      case 'download':
        return Icons.download;
      case 'groups':
        return Icons.groups;
      case 'lightbulb':
        return Icons.lightbulb;
      default:
        return Icons.star;
    }
  }
  
  Color _getStatColor(BuildContext context, String colorName) {
    switch (colorName) {
      case 'primary':
        return context.colorScheme.primary;
      case 'secondary':
        return context.colorScheme.secondary;
      case 'tertiary':
        return context.colorScheme.tertiary;
      default:
        return context.colorScheme.primary;
    }
  }
}