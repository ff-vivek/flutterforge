import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:provider/provider.dart';
import 'package:vivek_yadav/services/theme_service.dart';
import 'package:vivek_yadav/services/portfolio_service.dart';
import 'package:vivek_yadav/widgets/ai_background.dart';
import 'package:vivek_yadav/core/widgets/animated_button.dart';
import 'package:vivek_yadav/core/widgets/animated_icon_button.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, this.onContactTap, this.onDownloadResume});

  final VoidCallback? onContactTap;
  final VoidCallback? onDownloadResume;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final theme = Theme.of(context);
    
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
          ],
        ),
      ),
        
      child: Stack(
        alignment: Alignment.center,
        children:[

           // AI-flavored animated background behind the left column
                  SizedBox(height: MediaQuery.of(context).size.height, child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: const AINetworkBackground(intensity: 0.7),
                        ),
                      ),
                    ),),

          ResponsiveRowColumn(
        layout: isDesktop ? ResponsiveRowColumnType.ROW : ResponsiveRowColumnType.COLUMN,
        rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
        rowCrossAxisAlignment: CrossAxisAlignment.center,
        columnMainAxisAlignment: MainAxisAlignment.center,
        children: [
          ResponsiveRowColumnItem(
            rowFlex: isDesktop ? 1 : null,
            child: FadeInLeft(
              duration: const Duration(milliseconds: 800),
              child:   Padding(
                    padding: EdgeInsets.all(isDesktop ? 60 : 32),
                    child: Column(
                      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // GDE Badge
                        _buildGDEBadge(context),
                        const SizedBox(height: 24),
                        // Name
                        Text(
                          PortfolioService.name,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        // Title
                        Text(
                          PortfolioService.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Current Position
                        Text(
                          PortfolioService.currentPosition,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        // Quick Stats
                        _buildQuickStats(context, isDesktop),
                        const SizedBox(height: 32),
                        // CTA Buttons
                        _buildActionButtons(context, isDesktop),
                      ],
                    ),
                  ),
            ),
          ),
          
          ResponsiveRowColumnItem(
            rowFlex: isDesktop ? 1 : null,
            child: FadeInRight(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 200),
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 60 : 32),
                child: _buildProfileImage(context, isDesktop),
              ),
            ),
          ),
        ],
      ),
        ]
      )
    );
  }

  Widget _buildGDEBadge(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Google Developer Expert',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final media = MediaQuery.of(context);
    final isLandscape = media.orientation == Orientation.landscape;
    final shortestSide = media.size.shortestSide;
    final isTabletDevice = shortestSide >= 600 && shortestSide < 1024;
    final isLandscapeTablet = isTabletDevice && isLandscape;
    final stats = [
      {'label': 'Years Experience', 'value': '8+'},
      {'label': 'Combined Downloads', 'value': '20M+'},
      {'label': 'Team Leadership', 'value': '20+'},
      {'label': 'Startups Mentored', 'value': '50+'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = isDesktop ? 4 : 2;
          final itemWidth = (constraints.maxWidth - (16 * (crossAxisCount - 1))) / crossAxisCount;
          
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: stats.map((stat) => SizedBox(
              width: itemWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stat['value']!,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stat['label']!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )).toList(),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    
    if (isDesktop) {
      return Wrap(
        spacing: 16,
        runSpacing: 12,
        children: [
          AnimatedButton(
            onPressed: onContactTap,
            child: ElevatedButton.icon(
              onPressed: () {}, // Handled by AnimatedButton wrapper
              icon: const Icon(Icons.mail_outline),
              label: const Text('Get In Touch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                elevation: 2,
              ),
            ),
          ),
          AnimatedButton(
            onPressed: onDownloadResume,
            child: ElevatedButton.icon(
              onPressed: () {}, // Handled by AnimatedButton wrapper
              icon: const Icon(Icons.download_outlined),
              label: const Text('Download Resume'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                elevation: 2,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedButton(
          onPressed: onContactTap,
          child: ElevatedButton(
            onPressed: () {}, // Handled by AnimatedButton wrapper
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              elevation: 2,
            ),
            child: const Text('Get In Touch'),
          ),
        ),
        const SizedBox(height: 12),
        AnimatedButton(
          onPressed: onDownloadResume,
          child: ElevatedButton.icon(
            onPressed: () {}, // Handled by AnimatedButton wrapper
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              elevation: 2,
            ),
            icon: const Icon(Icons.download_outlined),
            label: const Text('Download Resume'),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final size = isDesktop ? 300.0 : 250.0;
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // Floating theme toggle
        Positioned(
          top: 20,
          right: 20,
          child: _buildThemeToggle(context),
        ),
        
        // Profile image placeholder with gradient border
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.tertiary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surface,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                ),
                child: ClipOval( // Added ClipOval to make the image circular
                  child: Image.asset(
                    'assets/images/vivek.jpeg',
                    width: isDesktop ? 120 : 100,
                    height: isDesktop ? 120 : 100,
                    fit: BoxFit.cover, // Added BoxFit.cover to ensure the image fills the circle
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return AnimatedIconButton(
          icon: themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          onPressed: themeService.toggleTheme,
          backgroundColor: Theme.of(context).colorScheme.surface,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
          rotateOnHover: true,
          tooltip: themeService.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        );
      },
    );
  }
}
