import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vivek_yadav/services/portfolio_service.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
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
              'Let\'s Connect',
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
            
            const SizedBox(height: 24),
            
            Text(
              'Ready to collaborate on your next Flutter project?\nLet\'s build something amazing together!',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 60),
            
            ResponsiveRowColumn(
              layout: isDesktop ? ResponsiveRowColumnType.ROW : ResponsiveRowColumnType.COLUMN,
              rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Contact Information
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: FadeInLeft(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 600),
                    child: _buildContactInfo(context, isDesktop),
                  ),
                ),
                
                if (isDesktop) const ResponsiveRowColumnItem(child: SizedBox(width: 60)),
                if (!isDesktop) const ResponsiveRowColumnItem(child: SizedBox(height: 40)),
                
                // Social Links
                ResponsiveRowColumnItem(
                  rowFlex: 1,
                  child: FadeInRight(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 600),
                    child: _buildSocialLinks(context, isDesktop),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 60),
            
            // Call to Action
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              duration: const Duration(milliseconds: 600),
              child: _buildCallToAction(context, isDesktop),
            ),
            
            const SizedBox(height: 40),
            
            // Footer
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 600),
              child: _buildFooter(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, bool isDesktop) {
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
            'Contact Information',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          _buildContactItem(
            context,
            Icons.email,
            'Email',
            'iamprocoach@gmail.com',
            'mailto:iamprocoach@gmail.com?subject=Inquiry%20from%20Your%20Website&body=Hello%20[Your%20Name],%0A%0AI\'m%20reaching%20out%20after%20visiting%20your%20website.%20I\'d%20like%20to%20inquire%20about...%0A%0A%5BPlease%20write%20your%20message%20here%5D%0A%0AThank%20you,%0A%0A[Visitor\'s%20Name]',
          ),
          
          const SizedBox(height: 16),
          
          // Phone number removed as per request
          
          const SizedBox(height: 16),
          
          _buildContactItem(
            context,
            Icons.location_on,
            'Location',
            PortfolioService.location,
            null,
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Available for:',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          
          const SizedBox(height: 12),
          
          ...[
            'Speaking engagements & workshops',
            'Technical consulting & mentorship',
            'Flutter project architecture reviews',
            'Team training & development',
          ].map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: theme.colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String label, String value, String? url) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: url != null ? () => _launchUrl(url) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
            
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      label,
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
    ),
    Text(
      value,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: url != null ? theme.colorScheme.primary : theme.colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
    ),
  ],
),
            ),
            
            if (url != null)
              Icon(
                Icons.launch,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinks(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final socialLinks = PortfolioService.socialLinks;
    
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
            'Connect on Social',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Follow my journey and stay updated',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: socialLinks.entries.map((link) => _buildSocialButton(
              context,
              link.key,
              link.value,
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, String platform, String url) {
    final theme = Theme.of(context);
    final icon = _getSocialIcon(platform);
    // Ensure GitHub is visible in dark mode by using a contrasting color
    final color = platform.toLowerCase() == 'github' && theme.brightness == Brightness.dark
        ? theme.colorScheme.onSurface
        : _getSocialColor(platform);
    
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            const SizedBox(width: 8),
            Text(
              platform.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSocialIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'linkedin': return Icons.business;
      case 'twitter': return Icons.alternate_email;
      case 'github': return Icons.code;
      case 'medium': return Icons.article;
      case 'youtube': return Icons.play_circle;
      case 'sessionize': return Icons.event;
      default: return Icons.link;
    }
  }

  Color _getSocialColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'linkedin': return const Color(0xFF0077B5);
      case 'twitter': return const Color(0xFF1DA1F2);
      case 'github': return const Color(0xFF333333);
      case 'medium': return const Color(0xFF00AB6C);
      case 'youtube': return const Color(0xFFFF0000);
      case 'sessionize': return const Color(0xFF1AB394);
      default: return Colors.blue;
    }
  }

  Widget _buildCallToAction(BuildContext context, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Ready to Start Your Flutter Journey?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Let\'s discuss your next project or speaking opportunity',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          ResponsiveRowColumn(
            layout: isDesktop ? ResponsiveRowColumnType.ROW : ResponsiveRowColumnType.COLUMN,
            rowMainAxisAlignment: MainAxisAlignment.center,
            children: [
              ResponsiveRowColumnItem(
                child: ElevatedButton.icon(
                  onPressed: () => _launchUrl('https://forms.gle/wnAwr5pwEr6SWAdQ6'),
                  icon: const Icon(Icons.mail_outline),
                  label: const Text('Get In Touch'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    elevation: 0,
                  ),
                ),
              ),
              
              if (isDesktop) const ResponsiveRowColumnItem(child: SizedBox(width: 16)),
              if (!isDesktop) const ResponsiveRowColumnItem(child: SizedBox(height: 16)),
              
              ResponsiveRowColumnItem(
                child: OutlinedButton.icon(
                  onPressed: () => _launchUrl(PortfolioService.socialLinks['linkedin']!),
                  icon: const Icon(Icons.business),
                  label: const Text('LinkedIn'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Divider(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
          height: 40,
        ),
        
        ResponsiveRowColumn(
          layout: ResponsiveBreakpoints.of(context).isDesktop 
              ? ResponsiveRowColumnType.ROW 
              : ResponsiveRowColumnType.COLUMN,
          rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ResponsiveRowColumnItem(
              child: Text(
                '© 2024 Vivek Yadav. All rights reserved.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            
            ResponsiveRowColumnItem(
              child: Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveBreakpoints.of(context).isDesktop ? 0 : 8,
                ),
                child: Text(
                  'Built with Dreamflow 💙 (dreamflow.com)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}