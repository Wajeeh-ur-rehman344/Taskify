import 'package:flutter/material.dart';
import 'dart:math';

class DonutChartPainter extends CustomPainter {
  final double completed;  // Representing 5% of tasks completed
  final double total;      // Total tasks, used to calculate percentage (100%)
  
  DonutChartPainter({
    required this.completed,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) * 0.8; // 80% of available space
    final strokeWidth = radius * 0.3; // Responsive stroke width

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final totalAngle = 2 * pi; // Full circle
    final completedAngle = (completed / total) * totalAngle; // Calculate completed portion

    // Draw the grey background for incomplete tasks
    paint.color = Colors.grey.withOpacity(0.3);  // Light grey background
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, totalAngle, false, paint);

    // Draw the green portion for the completed tasks (5%)
    paint.color =  const Color.fromARGB(255, 39, 94, 233);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, completedAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
