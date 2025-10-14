/// Centralized spacing constants following Material Design guidelines
class AppSpacing {
  AppSpacing._();
  
  // Base spacing unit (8dp)
  static const double unit = 8.0;
  
  // Spacing scale
  static const double xxs = unit * 0.5;  // 4
  static const double xs = unit;         // 8
  static const double sm = unit * 1.5;   // 12
  static const double md = unit * 2;     // 16
  static const double lg = unit * 3;     // 24
  static const double xl = unit * 4;     // 32
  static const double xxl = unit * 5;    // 40
  static const double xxxl = unit * 6;   // 48
  
  // Section spacing
  static const double sectionVerticalMobile = unit * 7.5;   // 60
  static const double sectionVerticalDesktop = unit * 12.5; // 100
  static const double sectionHorizontalMobile = xl;         // 32
  static const double sectionHorizontalDesktop = unit * 10; // 80
  
  // Card spacing
  static const double cardPadding = xl;                     // 32
  static const double cardSpacing = lg;                     // 24
  static const double cardSpacingLarge = xl;                // 32
  
  // Component spacing
  static const double componentGap = md;                    // 16
  static const double componentGapLarge = lg;               // 24
}
