import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivek_yadav/models/project.dart';
import 'package:vivek_yadav/services/portfolio_service.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width <= 450;
    final isTablet = width > 450 && width <= 800;
    final isDesktop = width > 800;
    final theme = Theme.of(context);
    final projects = PortfolioService.getProjects();
    final featuredProjects = projects.where((p) => p.isFeatured).toList();
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
              'Notable Projects & Impact',
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
            
            // Featured Projects Grid/Column
            if (isDesktop || isTablet)
              ResponsiveGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: ResponsiveGridDelegate(
                  crossAxisExtent: isTablet ? 350 : 400,
                  mainAxisSpacing: 32,
                  crossAxisSpacing: 32,
                  childAspectRatio: 0.9,
                  minCrossAxisExtent: 100,
                ),
                itemCount: featuredProjects.length,
                itemBuilder: (context, index) {
                  final project = featuredProjects[index];
                  final delay = Duration(milliseconds: 200 + (index * 150));
                  
                  return FadeInUp(
                    delay: delay,
                    duration: const Duration(milliseconds: 600),
                    child: _buildProjectCard(context, project, !isMobile),
                  );
                },
              )
            else
              Column(
                children: featuredProjects.asMap().entries.map((entry) {
                  final index = entry.key;
                  final project = entry.value;
                  final delay = Duration(milliseconds: 200 + (index * 150));
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: FadeInUp(
                      delay: delay,
                      duration: const Duration(milliseconds: 600),
                      child: _buildProjectCard(context, project, false),
                    ),
                  );
                }).toList(),
              ),
            
            const SizedBox(height: 40),
            
            // Other projects
            if (projects.length > featuredProjects.length) ...[
              _buildOtherProjects(context, projects.where((p) => !p.isFeatured).toList(), isDesktop),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project, bool isDesktop) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: double.infinity,
      height: isDesktop ? null : 420,
      child: Container(
        width: double.infinity,
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
          // Project image/icon placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.8),
                  theme.colorScheme.tertiary.withValues(alpha: 0.6),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                _getProjectIcon(project.title),
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          
          // Project content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    project.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description
                  Expanded(
                    child: Text(
                      project.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Impact
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 16,
                          color: theme.colorScheme.tertiary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            project.impact,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Technologies
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: project.technologies.take(3).map((tech) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tech,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (project.githubUrl != null)
                        TextButton.icon(
                          onPressed: () => _launchUrl(project.githubUrl!),
                          icon: const Icon(Icons.code, size: 16),
                          label: const Text('Code'),
                        ),
                      if (project.liveUrl != null)
                        ElevatedButton.icon(
                          onPressed: () => _launchUrl(project.liveUrl!),
                          icon: const Icon(Icons.launch, size: 16),
                          label: const Text('View'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  IconData _getProjectIcon(String title) {
    if (title.toLowerCase().contains('zestmoney')) return Icons.account_balance;
    if (title.toLowerCase().contains('tata')) return Icons.shopping_cart;
    if (title.toLowerCase().contains('plugin')) return Icons.extension;
    if (title.toLowerCase().contains('highlevel')) return Icons.timeline;
    if (title.toLowerCase().contains('package')) return Icons.inventory;
    return Icons.mobile_friendly;
  }

  Widget _buildOtherProjects(BuildContext context, List<Project> projects, bool isDesktop) {
    final theme = Theme.of(context);
    
    return FadeInUp(
      delay: const Duration(milliseconds: 800),
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Other Notable Work',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            
            const SizedBox(height: 20),
            
            ...projects.map((project) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          project.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          project.impact,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}