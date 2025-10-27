import 'package:flutter/material.dart';
import 'package:ias/ui/screens/students/data/student_data.dart';
import 'package:ias/ui/screens/students/widget/customWidget/view_attendance.dart';

// Modify the build method to make the card tappable

Widget attendanceCard(
    BuildContext context, StudentData student, ColorScheme colorScheme) {
  final bool isAttendanceGood = student.attendancePercentage >= 85.0;
  final Color cardColor = isAttendanceGood
      ? colorScheme.tertiaryContainer
      : colorScheme.errorContainer;
  final Color iconColor = isAttendanceGood
      ? colorScheme.onTertiaryContainer
      : colorScheme.onErrorContainer;

  return InkWell(
    // 💡 Use InkWell to make the card tappable with ripple effect
    onTap: () {
      // 🚀 CALL THE POP-UP FUNCTION ON TAP
      showAttendanceCalendar(context, mockAttendedDates);
    },
    borderRadius: BorderRadius.circular(16), // Match the card's border radius
    child: Card(
      elevation: 2,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // ... (rest of the card content remains the same)
          children: [
            Icon(Icons.check_circle_outline, color: iconColor, size: 30),
            const SizedBox(height: 8),
            Text(
              'Attendance',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${student.attendancePercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
