import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/constants/app_spacing.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';
import 'package:vivek_yadav/core/widgets/animated_section.dart';
import 'package:vivek_yadav/core/widgets/section_container.dart';
import 'package:vivek_yadav/core/widgets/section_header.dart';
import 'package:vivek_yadav/core/widgets/glass_card.dart';
import 'package:vivek_yadav/core/widgets/animated_card.dart';
import 'package:vivek_yadav/core/widgets/circular_experience_timeline.dart';
import 'package:vivek_yadav/services/portfolio_service.dart';
import 'package:vivek_yadav/models/experience.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final experiences = PortfolioService.getExperiences();

    return SectionContainer(
      child: AnimatedSection(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Experience'),
            const SizedBox(height: AppSpacing.xl),
            // Circular Timeline Overview
            Center(
              child: CircularExperienceTimeline(
                experiences: experiences,
                size: 400,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (context.isDesktop)
              _buildDesktopLayout(experiences, context)
            else
              _buildMobileLayout(experiences, context),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(List<Experience> experiences, BuildContext context) {
    return Column(
      children: experiences.asMap().entries.map((entry) {
        final index = entry.key;
        return Padding(
          padding: EdgeInsets.only(bottom: index < experiences.length - 1 ? AppSpacing.lg : 0),
          child: _buildExperienceCard(experience: entry.value, context: context),
        );
      }).toList(),
    );
  }

  Widget _buildMobileLayout(List<Experience> experiences, BuildContext context) {
    return Column(
      children: experiences.asMap().entries.map((entry) {
        final index = entry.key;
        return Padding(
          padding: EdgeInsets.only(bottom: index < experiences.length - 1 ? AppSpacing.lg : 0),
          child: _buildExperienceCard(experience: entry.value, context: context),
        );
      }).toList(),
    );
  }

  Widget _buildExperienceCard({required Experience experience, required BuildContext context}) {
    return AnimatedCard(
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          experience.position,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          experience.company,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          experience.duration,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                experience.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Achievements:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ...experience.achievements.map((achievement) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6, right: 8),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            achievement,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}