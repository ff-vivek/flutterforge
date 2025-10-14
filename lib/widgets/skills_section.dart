import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vivek_yadav/models/skill.dart';
import 'package:vivek_yadav/services/portfolio_service.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final theme = Theme.of(context);
    final skills = PortfolioService.getSkills();
    
    final skillsByCategory = <SkillCategory, List<Skill>>{};
    for (final skill in skills) {
      skillsByCategory.putIfAbsent(skill.category, () => []).add(skill);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 32,
        vertical: isDesktop ? 100 : 60,
      ),
      color: theme.colorScheme.surface,
      child: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Column(
          children: [
            // Section Title
            Text(
              'Skills & Expertise',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Skills by category
            Column(
              children: [
                _buildSkillCategory(
                  context,
                  'Primary Technologies',
                  skillsByCategory[SkillCategory.primary] ?? [],
                  theme.colorScheme.primary,
                  const Duration(milliseconds: 200),
                  isDesktop,
                ),
                
                const SizedBox(height: 40),
                
                _buildSkillCategory(
                  context,
                  'Backend & Services',
                  skillsByCategory[SkillCategory.backend] ?? [],
                  theme.colorScheme.secondary,
                  const Duration(milliseconds: 400),
                  isDesktop,
                ),
                
                const SizedBox(height: 40),
                
                _buildSkillCategory(
                  context,
                  'Specializations',
                  skillsByCategory[SkillCategory.specialization] ?? [],
                  theme.colorScheme.tertiary,
                  const Duration(milliseconds: 600),
                  isDesktop,
                ),
                
                const SizedBox(height: 40),
                
                _buildSkillCategory(
                  context,
                  'Leadership & Soft Skills',
                  skillsByCategory[SkillCategory.nonTechnical] ?? [],
                  theme.colorScheme.primary,
                  const Duration(milliseconds: 800),
                  isDesktop,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCategory(
    BuildContext context,
    String title,
    List<Skill> skills,
    Color categoryColor,
    Duration delay,
    bool isDesktop,
  ) {
    final theme = Theme.of(context);
    
    return FadeInUp(
      delay: delay,
      duration: const Duration(milliseconds: 600),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1000),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: categoryColor,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Skills grid
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: skills.map((skill) => _buildSkillChip(context, skill, categoryColor)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(BuildContext context, Skill skill, Color categoryColor) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (skill.description != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                skill.description!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: categoryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return Icon(
                index < skill.proficiencyLevel ? Icons.star : Icons.star_border,
                size: 12,
                color: categoryColor,
              );
            }),
          ),
        ],
      ),
    );
  }
}