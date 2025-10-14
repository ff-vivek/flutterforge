import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/constants/app_spacing.dart';
import 'package:vivek_yadav/core/constants/app_durations.dart';
import 'package:vivek_yadav/core/widgets/glass_card.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';
import 'package:vivek_yadav/core/extensions/color_extensions.dart';

/// Enhanced animated stat card with counting animation and icons
class AnimatedStatCard extends StatefulWidget {
  final String value;
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final Duration delay;
  final String? subtitle;
  final VoidCallback? onTap;
  
  const AnimatedStatCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
    this.delay = Duration.zero,
    this.subtitle,
    this.onTap,
  });

  @override
  State<AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<AnimatedStatCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _hoverController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _hoverAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.slow,
      vsync: this,
    );
    
    _hoverController = AnimationController(
      duration: AppDurations.fast,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
    
    // Start animation with delay
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hoverController.dispose();
    super.dispose();
  }
  
  void _handleHover(bool hover) {
    setState(() => _isHovered = hover);
    if (hover) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller, _hoverController]),
          builder: (context, child) => Transform.scale(
            scale: _hoverAnimation.value,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        AnimatedContainer(
                          duration: AppDurations.fast,
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: (widget.iconColor ?? context.colorScheme.primary).withValues(
                              alpha: _isHovered ? 0.2 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            widget.icon,
                            size: 32,
                            color: widget.iconColor ?? context.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      
                      // Animated Counter
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          final progress = _controller.value;
                          final animatedValue = _calculateAnimatedValue(widget.value, progress);
                          
                          return Text(
                            animatedValue,
                            style: context.textTheme.headlineMedium?.copyWith(
                              color: context.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: _isHovered ? 32 : 28,
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: AppSpacing.sm),
                      
                      Text(
                        widget.label,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.onSurface.muted,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.subtitle!,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface.subtle,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  String _calculateAnimatedValue(String value, double progress) {
    // Extract numeric part and suffix
    final regex = RegExp(r'(\d+)([^\d]*)');
    final match = regex.firstMatch(value);
    
    if (match == null) return value;
    
    final numericPart = int.tryParse(match.group(1) ?? '0') ?? 0;
    final suffix = match.group(2) ?? '';
    
    final animatedNumber = (numericPart * progress).round();
    return '$animatedNumber$suffix';
  }
}