/// Centralized animation duration constants
class AppDurations {
  AppDurations._();
  
  // Animation durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration normal = Duration(milliseconds: 600);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration verySlow = Duration(milliseconds: 1000);
  
  // Scroll animation
  static const Duration scrollAnimation = normal;
  
  // Fade animations
  static const Duration fadeIn = normal;
  static const Duration fadeInStagger = Duration(milliseconds: 100);
  static const Duration fadeInStaggerLong = Duration(milliseconds: 150);
}
