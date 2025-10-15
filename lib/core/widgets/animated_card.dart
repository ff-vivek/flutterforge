import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/constants/app_durations.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';

/// Animated card with hover effects and optional tap interaction
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double elevation;
  final double hoverElevation;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double hoverScale;
  
  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.elevation = 2.0,
    this.hoverElevation = 8.0,
    this.borderRadius = 12.0,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.hoverScale = 1.02,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.hoverScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.hoverElevation,
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
              child: Container(
                margin: widget.margin,
                child: Material(
                  elevation: _elevationAnimation.value,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: widget.backgroundColor ?? context.colorScheme.surface,
                  shadowColor: context.colorScheme.shadow.withOpacity(0.15),
                  child: Container(
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: _isHovered 
                          ? Border.all(
                              color: context.colorScheme.primary.withOpacity(0.3),
                              width: 1,
                            )
                          : null,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}