import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/config/responsive_config.dart';

extension ContextExtensions on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  
  // Screen dimensions
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  
  // Responsive shortcuts - using explicit width checking
  bool get isMobile => screenWidth <= ResponsiveConfig.mobileEnd;
  bool get isTablet => screenWidth > ResponsiveConfig.mobileEnd && screenWidth <= ResponsiveConfig.tabletEnd;
  bool get isDesktop => screenWidth > ResponsiveConfig.tabletEnd;
}
