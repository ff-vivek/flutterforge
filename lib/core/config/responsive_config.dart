import 'package:responsive_framework/responsive_framework.dart';

/// Centralized responsive configuration
class ResponsiveConfig {
  ResponsiveConfig._();
  
  // Breakpoint values
  static const double mobileEnd = 450;
  static const double tabletStart = 451;
  static const double tabletEnd = 800;
  static const double desktopStart = 801;
  static const double desktopEnd = 1920;
  static const double fourKStart = 1921;
  
  // Breakpoints configuration
  static List<Breakpoint> get breakpoints => [
    const Breakpoint(start: 0, end: mobileEnd, name: MOBILE),
    const Breakpoint(start: tabletStart, end: tabletEnd, name: TABLET),
    const Breakpoint(start: desktopStart, end: desktopEnd, name: DESKTOP),
    const Breakpoint(start: fourKStart, end: double.infinity, name: '4K'),
  ];
  
  // Responsive padding getter
  static double getHorizontalPadding(bool isDesktop) => isDesktop ? 80 : 32;
  static double getVerticalPadding(bool isDesktop) => isDesktop ? 100 : 60;
  
  // Grid configurations
  static double getGridExtent(bool isDesktop, {double? mobileExtent, double? desktopExtent}) {
    return isDesktop ? (desktopExtent ?? 300) : (mobileExtent ?? 250);
  }
  
  static double getGridAspectRatio(bool isDesktop, {double? mobileRatio, double? desktopRatio}) {
    return isDesktop ? (desktopRatio ?? 1.2) : (mobileRatio ?? 1.0);
  }
}
