import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  /// Returns color with specified alpha opacity (0.0 - 1.0)
  Color withAlpha(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0, 'Alpha must be between 0.0 and 1.0');
    return Color.fromRGBO(red, green, blue, opacity);
  }
  
  /// Returns color with 15% opacity
  Color get subtle => withValues(alpha: 0.15);
  
  /// Returns color with 25% opacity
  Color get light => withValues(alpha: 0.25);
  
  /// Returns color with 40% opacity
  Color get medium => withValues(alpha: 0.4);
  
  /// Returns color with 75% opacity
  Color get muted => withValues(alpha: 0.75);
}
