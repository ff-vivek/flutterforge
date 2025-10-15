import 'package:flutter/material.dart';
import 'package:vivek_yadav/models/project.dart';
import 'package:vivek_yadav/core/widgets/animated_card.dart';
import 'package:vivek_yadav/core/widgets/animated_button.dart';
import 'package:vivek_yadav/core/widgets/tech_chip.dart';
import 'package:vivek_yadav/core/widgets/impact_badge.dart';
import 'package:vivek_yadav/core/constants/app_spacing.dart';
import 'package:vivek_yadav/core/constants/app_dimensions.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';
import 'package:vivek_yadav/core/extensions/color_extensions.dart';
import 'package:vivek_yadav/core/utils/url_launcher_helper.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  
  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) => AnimatedCard(
    borderRadius: AppDimensions.radiusLg,
    backgroundColor: context.colorScheme.surface.withOpacity(0.7),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProjectHeader(context),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Expanded(
                  child: Text(
                    project.description,
                    style: context.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: context.colorScheme.onSurface.muted,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ImpactBadge(text: project.impact),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: project.technologies.take(3).map(
                    (tech) => TechChip(label: tech, compact: true),
                  ).toList(),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildProjectHeader(BuildContext context) => Container(
    height: 120,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLg)),
      gradient: LinearGradient(
        colors: [
          context.colorScheme.primary.withValues(alpha: 0.8),
          context.colorScheme.tertiary.withValues(alpha: 0.6),
        ],
      ),
    ),
    child: Center(
      child: Icon(
        _getProjectIcon(project.title),
        size: AppDimensions.iconXl,
        color: Colors.white,
      ),
    ),
  );

  Widget _buildActionButtons(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      if (project.githubUrl != null)
        AnimatedButton(
          onPressed: () => UrlLauncherHelper.launchURL(project.githubUrl!),
          isElevated: false,
          child: TextButton.icon(
            onPressed: null, // Handled by AnimatedButton
            icon: const Icon(Icons.code, size: AppDimensions.iconSm),
            label: const Text('Code'),
          ),
        ),
      if (project.liveUrl != null)
        AnimatedButton(
          onPressed: () => UrlLauncherHelper.launchURL(project.liveUrl!),
          child: ElevatedButton.icon(
            onPressed: null, // Handled by AnimatedButton
            icon: const Icon(Icons.launch, size: AppDimensions.iconSm),
            label: const Text('View'),
          ),
        ),
    ],
  );

  IconData _getProjectIcon(String title) {
    if (title.toLowerCase().contains('zestmoney')) return Icons.account_balance;
    if (title.toLowerCase().contains('tata')) return Icons.shopping_cart;
    if (title.toLowerCase().contains('plugin')) return Icons.extension;
    if (title.toLowerCase().contains('highlevel')) return Icons.timeline;
    if (title.toLowerCase().contains('package')) return Icons.inventory;
    return Icons.mobile_friendly;
  }
}
