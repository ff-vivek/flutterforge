import 'package:flutter/material.dart';
import 'package:vivek_yadav/core/constants/app_spacing.dart';
import 'package:vivek_yadav/core/constants/app_dimensions.dart';
import 'package:vivek_yadav/core/constants/app_durations.dart';
import 'package:vivek_yadav/core/extensions/context_extensions.dart';
import 'package:vivek_yadav/models/experience.dart';
import 'dart:math' as math;

class CircularExperienceTimeline extends StatefulWidget {
  final List<Experience> experiences;
  final double size;

  const CircularExperienceTimeline({
    super.key,
    required this.experiences,
    this.size = 400,
  });

  @override
  State<CircularExperienceTimeline> createState() => _CircularExperienceTimelineState();
}

class _CircularExperienceTimelineState extends State<CircularExperienceTimeline>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppDurations.slow,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: CircularTimelinePainter(
              experiences: widget.experiences,
              animationValue: _animation.value,
              colorScheme: context.colorScheme,
              textTheme: context.textTheme,
            ),
            child: Center(
              child: _buildCenterContent(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterContent(BuildContext context) {
    final totalYears = _calculateTotalYears();
    final currentCompany = widget.experiences.first.company;
    final totalExperience = widget.experiences.length;

    return Container(
      width: widget.size * 0.35,
      height: widget.size * 0.35,
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: FadeTransition(
        opacity: _animation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAREER',
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
    
          ],
        ),
      ),
    );
  }

  double _calculateTotalYears() {
    double total = 0;
    for (final experience in widget.experiences) {
      total += _getExperienceDuration(experience);
    }
    return total;
  }

  double _getExperienceDuration(Experience experience) {
    // Parse duration like "Sept 2024 - Current" or "May 2023 - Sept 2024"
    final duration = experience.duration;
    final parts = duration.split(' - ');
    if (parts.length != 2) return 1.0; // Default to 1 year if can't parse
    
    try {
      final startYear = _extractYear(parts[0]);
      final startMonth = _extractMonth(parts[0]);
      final startDate = DateTime(startYear, startMonth);
      
      final endDate = parts[1].toLowerCase().contains('current') 
          ? DateTime.now()
          : DateTime(_extractYear(parts[1]), _extractMonth(parts[1]));
      
      return endDate.difference(startDate).inDays / 365.25;
    } catch (e) {
      return 1.0; // Default to 1 year if parsing fails
    }
  }

  int _extractYear(String dateStr) {
    final regex = RegExp(r'\b(20\d{2})\b');
    final match = regex.firstMatch(dateStr);
    return match != null ? int.parse(match.group(1)!) : DateTime.now().year;
  }

  int _extractMonth(String dateStr) {
    const months = {
      'jan': 1, 'january': 1,
      'feb': 2, 'february': 2,
      'mar': 3, 'march': 3,
      'apr': 4, 'april': 4,
      'may': 5,
      'jun': 6, 'june': 6,
      'jul': 7, 'july': 7,
      'aug': 8, 'august': 8,
      'sep': 9, 'sept': 9, 'september': 9,
      'oct': 10, 'october': 10,
      'nov': 11, 'november': 11,
      'dec': 12, 'december': 12,
    };
    
    final lowerStr = dateStr.toLowerCase();
    for (final entry in months.entries) {
      if (lowerStr.contains(entry.key)) {
        return entry.value;
      }
    }
    return 1; // Default to January
  }
}

class CircularTimelinePainter extends CustomPainter {
  final List<Experience> experiences;
  final double animationValue;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  CircularTimelinePainter({
    required this.experiences,
    required this.animationValue,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;
    final strokeWidth = 20.0;

    // Draw background circle with tick marks
    _drawBackgroundCircle(canvas, center, radius, strokeWidth);
    _drawTickMarks(canvas, center, radius, strokeWidth);

    // Calculate total duration and draw experience arcs
    final totalYears = _calculateTotalDuration();
    double currentAngle = -math.pi / 2; // Start at top

    for (int i = 0; i < experiences.length; i++) {
      final experience = experiences[i];
      final duration = _getExperienceDuration(experience);
      final sweepAngle = (duration / totalYears) * 2 * math.pi * animationValue;
      
      _drawExperienceArc(
        canvas,
        center,
        radius,
        strokeWidth,
        currentAngle,
        sweepAngle,
        _getExperienceColor(i),
        experience,
      );
      
      currentAngle += sweepAngle / animationValue.clamp(0.01, 1.0);
    }
  }

  void _drawBackgroundCircle(Canvas canvas, Offset center, double radius, double strokeWidth) {
    final paint = Paint()
      ..color = colorScheme.outline.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, paint);
  }

  void _drawTickMarks(Canvas canvas, Offset center, double radius, double strokeWidth) {
    final paint = Paint()
      ..color = colorScheme.outline.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw major tick marks every 90 degrees (quarters)
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2 - math.pi / 2;
      final innerRadius = radius - strokeWidth / 2 - 5;
      final outerRadius = radius + strokeWidth / 2 + 5;
      
      final startPoint = Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );
      final endPoint = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );
      
      canvas.drawLine(startPoint, endPoint, paint);
    }

    // Draw minor tick marks
    for (int i = 0; i < 12; i++) {
      final angle = i * math.pi / 6 - math.pi / 2;
      if (i % 3 != 0) { // Skip major ticks
        final innerRadius = radius - strokeWidth / 2 - 2;
        final outerRadius = radius + strokeWidth / 2 + 2;
        
        final startPoint = Offset(
          center.dx + innerRadius * math.cos(angle),
          center.dy + innerRadius * math.sin(angle),
        );
        final endPoint = Offset(
          center.dx + outerRadius * math.cos(angle),
          center.dy + outerRadius * math.sin(angle),
        );
        
        canvas.drawLine(startPoint, endPoint, paint..strokeWidth = 0.5);
      }
    }
  }

  void _drawExperienceArc(
    Canvas canvas,
    Offset center,
    double radius,
    double strokeWidth,
    double startAngle,
    double sweepAngle,
    Color color,
    Experience experience,
  ) {
    // Draw the arc
    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

    // Draw company label if arc is large enough
    if (sweepAngle > 0.3 && animationValue > 0.5) {
      _drawCompanyLabel(canvas, center, radius, startAngle, sweepAngle, experience.company);
    }
  }

  void _drawCompanyLabel(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    String company,
  ) {
    final labelAngle = startAngle + sweepAngle / 2;
    final labelRadius = radius - 35;
    
    final labelCenter = Offset(
      center.dx + labelRadius * math.cos(labelAngle),
      center.dy + labelRadius * math.sin(labelAngle),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: company.length > 10 ? '${company.substring(0, 10)}...' : company,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    // Rotate text to follow the arc
    canvas.save();
    canvas.translate(labelCenter.dx, labelCenter.dy);
    if (labelAngle > math.pi / 2 && labelAngle < 3 * math.pi / 2) {
      canvas.rotate(labelAngle + math.pi);
    } else {
      canvas.rotate(labelAngle);
    }
    
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
  }

  Color _getExperienceColor(int index) {
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      Colors.teal,
      Colors.orange,
      Colors.purple,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }

  double _calculateTotalDuration() {
    double total = 0;
    for (final experience in experiences) {
      total += _getExperienceDuration(experience);
    }
    return total;
  }

  double _getExperienceDuration(Experience experience) {
    // Parse duration like "Sept 2024 - Current" or "May 2023 - Sept 2024"
    final duration = experience.duration;
    final parts = duration.split(' - ');
    if (parts.length != 2) return 1.0; // Default to 1 year if can't parse
    
    try {
      final startYear = _extractYear(parts[0]);
      final startMonth = _extractMonth(parts[0]);
      final startDate = DateTime(startYear, startMonth);
      
      final endDate = parts[1].toLowerCase().contains('current') 
          ? DateTime.now()
          : DateTime(_extractYear(parts[1]), _extractMonth(parts[1]));
      
      return endDate.difference(startDate).inDays / 365.25;
    } catch (e) {
      return 1.0; // Default to 1 year if parsing fails
    }
  }

  int _extractYear(String dateStr) {
    final regex = RegExp(r'\b(20\d{2})\b');
    final match = regex.firstMatch(dateStr);
    return match != null ? int.parse(match.group(1)!) : DateTime.now().year;
  }

  int _extractMonth(String dateStr) {
    const months = {
      'jan': 1, 'january': 1,
      'feb': 2, 'february': 2,
      'mar': 3, 'march': 3,
      'apr': 4, 'april': 4,
      'may': 5,
      'jun': 6, 'june': 6,
      'jul': 7, 'july': 7,
      'aug': 8, 'august': 8,
      'sep': 9, 'sept': 9, 'september': 9,
      'oct': 10, 'october': 10,
      'nov': 11, 'november': 11,
      'dec': 12, 'december': 12,
    };
    
    final lowerStr = dateStr.toLowerCase();
    for (final entry in months.entries) {
      if (lowerStr.contains(entry.key)) {
        return entry.value;
      }
    }
    return 1; // Default to January
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}