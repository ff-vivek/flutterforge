import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vivek_yadav/models/speaking_topic.dart';
import 'package:vivek_yadav/services/portfolio_service.dart';

class SpeakingSection extends StatelessWidget {
  const SpeakingSection({super.key, this.onInviteToSpeak});

  final VoidCallback? onInviteToSpeak;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final theme = Theme.of(context);
    final speakingTopics = PortfolioService.getSpeakingTopics();
    final conferences = PortfolioService.getConferenceAppearances();
    final communityRoles = PortfolioService.getCommunityRoles();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 32,
        vertical: isDesktop ? 100 : 60,
      ),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.05),
      child: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Column(
          children: [
            // Section Title
            Text(
              'Speaking & Community',
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
            
            ResponsiveRowColumn(
              layout: isDesktop ? ResponsiveRowColumnType.ROW : ResponsiveRowColumnType.COLUMN,
              rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
              rowCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Speaking Topics
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: FadeInLeft(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 600),
                    child: _buildSpeakingTopics(context, speakingTopics, isDesktop),
                  ),
                ),
                
                if (isDesktop) const ResponsiveRowColumnItem(child: SizedBox(width: 40)),
                if (!isDesktop) const ResponsiveRowColumnItem(child: SizedBox(height: 40)),
                
                // Community & Conferences
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: Column(
                    children: [
                      FadeInRight(
                        delay: const Duration(milliseconds: 400),
                        duration: const Duration(milliseconds: 600),
                        child: _buildCommunityRoles(context, communityRoles, isDesktop),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      FadeInRight(
                        delay: const Duration(milliseconds: 600),
                        duration: const Duration(milliseconds: 600),
                        child: _buildConferences(context, conferences, isDesktop),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakingTopics(BuildContext context, List<SpeakingTopic> topics, bool isDesktop) {
    final theme = Theme.of(context);
    
    return Container(
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
          Text(
            'Speaking Topics',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Available for conferences, workshops, and technical talks',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          
          const SizedBox(height: 24),
          
          ...topics.take(4).map((topic) => _buildTopicCard(context, topic)).toList(),
          
          const SizedBox(height: 16),
          
          ElevatedButton.icon(
            onPressed: onInviteToSpeak,
            icon: const Icon(Icons.campaign),
            label: const Text('Invite Me to Speak'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, SpeakingTopic topic) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  topic.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(topic.difficulty, theme).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  topic.difficulty,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getDifficultyColor(topic.difficulty, theme),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            topic.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '${topic.estimatedDuration} minutes',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty, ThemeData theme) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }

  Widget _buildCommunityRoles(BuildContext context, Map<String, String> roles, bool isDesktop) {
    final theme = Theme.of(context);
    
    return Container(
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
          Row(
            children: [
              Icon(
                Icons.group,
                color: theme.colorScheme.tertiary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Community Leadership',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          ...roles.entries.map((role) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: theme.colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.key,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        role.value,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildConferences(BuildContext context, List<ConferenceAppearance> conferences, bool isDesktop) {
    final theme = Theme.of(context);
    
    return Container(
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
          Row(
            children: [
              Icon(
                Icons.event,
                color: theme.colorScheme.secondary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Recent Conferences',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          ...conferences.take(6).map((conference) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${conference.name} ${conference.year}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        conference.location,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
          
          const SizedBox(height: 16),
          
          Text(
            '...and many more conferences worldwide',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}