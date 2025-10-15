import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/constants/app_durations.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';

/// Animated wrapper for buttons with hover and press effects
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final bool isElevated;
  final double scaleFactor;
  
  const AnimatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.width,
    this.height,
    this.isElevated = true,
    this.scaleFactor = 0.95,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _elevationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: AppDurations.fast,
      vsync: this,
    );
    _elevationController = AnimationController(
      duration: AppDurations.medium,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _elevationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _elevationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() => _isPressed = true);
      _scaleController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering && widget.isElevated) {
      _elevationController.forward();
    } else {
      _elevationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: AppDurations.fast,
                width: widget.width,
                height: widget.height,
                transform: Matrix4.identity()
                  ..translate(0.0, _isPressed ? 2.0 : 0.0),
                decoration: widget.isElevated
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.shadow.withValues(alpha: 0.12),
                            blurRadius: _elevationAnimation.value,
                            offset: Offset(0, _elevationAnimation.value / 2),
                          ),
                        ],
                      )
                    : null,
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}