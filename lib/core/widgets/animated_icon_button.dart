import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/constants/app_durations.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';

/// Animated icon button with rotation, scale, and color effects
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final bool rotateOnHover;
  final bool pulseOnTap;
  final String? tooltip;
  
  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 24.0,
    this.rotateOnHover = false,
    this.pulseOnTap = true,
    this.tooltip,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;
  
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );
    _tapController = AnimationController(
      duration: AppDurations.fast,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.rotateOnHover ? 0.5 : 0.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && widget.pulseOnTap) {
      setState(() => _isPressed = true);
      _tapController.forward().then((_) {
        _tapController.reverse();
        setState(() => _isPressed = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.color ?? context.colorScheme.onSurface;
    final bgColor = widget.backgroundColor ?? Colors.transparent;
    
    _colorAnimation = ColorTween(
      begin: iconColor,
      end: context.colorScheme.primary,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    Widget iconButton = MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: Listenable.merge([_hoverController, _tapController]),
          builder: (context, child) {
            return AnimatedContainer(
              duration: AppDurations.fast,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: _isHovered 
                    ? context.colorScheme.primary.withOpacity(0.1)
                    : bgColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: context.colorScheme.primary.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Transform.scale(
                scale: _scaleAnimation.value * 
                       (_isPressed ? 0.9 : 1.0),
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: Icon(
                    widget.icon,
                    size: widget.size,
                    color: _colorAnimation.value,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    if (widget.tooltip != null) {
      iconButton = Tooltip(
        message: widget.tooltip!,
        child: iconButton,
      );
    }

    return iconButton;
  }
}