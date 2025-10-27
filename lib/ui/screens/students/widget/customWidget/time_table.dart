import 'package:flutter/material.dart';
import 'package:ias/ui/screens/students/data/class_schedule.dart';

void showTimeTablePopup(BuildContext context, List<ClassSchedule> schedule) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        // Material 3 style: bold title, rounded shape
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(
          'Today\'s Time Table',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Sizing and Scrollable Content
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the schedule list
                ...schedule.map((classItem) {
                  return buildScheduleTile(context, classItem, colorScheme);
                }).toList(),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('CLOSE', style: TextStyle(color: colorScheme.primary)),
          ),
        ],
      );
    },
  );
}

// ------------------- Helper Widget for Schedule Item -------------------

Widget buildScheduleTile(
    BuildContext context, ClassSchedule classItem, ColorScheme colorScheme) {
  // Use primary color for subjects, secondary for breaks
  final tileColor = classItem.subject == 'Break'
      ? colorScheme.secondary.withOpacity(0.1)
      : Colors.transparent;
  final subjectStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: classItem.subject == 'Break'
          ? colorScheme.secondary
          : colorScheme.primary);

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4.0),
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
    decoration: BoxDecoration(
      color: tileColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        // Time Slot
        SizedBox(
          width: 70,
          child: Text(
            classItem.time,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Subject and Teacher Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classItem.subject,
                style: subjectStyle,
              ),
              if (classItem.teacher.isNotEmpty)
                Text(
                  '${classItem.teacher}',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
