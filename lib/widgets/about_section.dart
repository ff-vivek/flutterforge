import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vivek_yadav/services/portfolio_service.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 32,
        vertical: isDesktop ? 100 : 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.18),
          
            theme.colorScheme.surface,
          ],
        ),
      ),
      child: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Column(
          children: [
            // Section Title
            Text(
              'About Me',
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
            
            const SizedBox(height: 40),
            
            // Summary
            Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Text(
                PortfolioService.summary,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Key Statistics
            _buildKeyStatistics(context, isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyStatistics(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final stats = PortfolioService.keyStats.entries.toList();
    
    return ResponsiveGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: ResponsiveGridDelegate(
        crossAxisExtent: isDesktop ? 300 : 250,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: isDesktop ? 1.2 : 1.0,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        final delay = Duration(milliseconds: 200 + (index * 100));
        
        return FadeInUp(
          delay: delay,
          duration: const Duration(milliseconds: 600),
          child: Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Text(
                  stat.key,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}