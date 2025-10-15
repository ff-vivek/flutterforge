import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/constants/app_spacing.dart';
import 'package:vivek_yadav/core/constants/app_dimensions.dart';
import 'package:vivek_yadav/core/constants/app_durations.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';
import 'package:vivek_yadav/core/extensions/color_extensions.dart';

/// Animated technology/skill chip with hover effects
class AnimatedChip extends StatefulWidget {
  final String label;
  final Color? color;
  final bool compact;
  final VoidCallback? onTap;
  
  const AnimatedChip({
    super.key,
    required this.label,
    this.color,
    this.compact = false,
    this.onTap,
  });

  @override
  State<AnimatedChip> createState() => _AnimatedChipState();
}

class _AnimatedChipState extends State<AnimatedChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.fast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chipColor = widget.color ?? context.colorScheme.primary;
    
    _colorAnimation = ColorTween(
      begin: chipColor.subtle,
      end: chipColor.light,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: AppDurations.fast,
                padding: EdgeInsets.symmetric(
                  horizontal: widget.compact ? AppSpacing.xs : AppSpacing.sm,
                  vertical: widget.compact ? AppSpacing.xxs : AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  borderRadius: BorderRadius.circular(
                    widget.compact ? AppSpacing.sm : AppDimensions.radiusXl,
                  ),
                  border: _isHovered 
                      ? Border.all(color: chipColor.withValues(alpha: 0.4), width: 1)
                      : null,
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: chipColor.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: AppDurations.fast,
                  style: (widget.compact 
                      ? context.textTheme.labelSmall 
                      : context.textTheme.bodyMedium)?.copyWith(
                    color: _isHovered ? chipColor : chipColor,
                    fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                  ) ?? const TextStyle(),
                  child: Text(widget.label),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}