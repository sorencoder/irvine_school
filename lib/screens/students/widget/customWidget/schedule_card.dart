import 'package:flutter/material.dart';
import 'package:ias/screens/students/data/class_schedule.dart';
import 'package:ias/screens/students/data/student_data.dart';
import 'package:ias/screens/students/widget/customWidget/time_table.dart';

Widget scheduleCard(
    BuildContext context, StudentData student, ColorScheme colorScheme) {
  return InkWell(
    onTap: () {
      showTimeTablePopup(context, mockSchedule);
    },
    borderRadius: BorderRadius.circular(18),
    child: Card(
      elevation: 2,
      color: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.calendar_month,
                color: colorScheme.onSecondaryContainer, size: 30),
            const SizedBox(height: 8),
            Text(
              'Time Table',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'View Daily Schedule',
              style: TextStyle(
                fontSize: 18,
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
