import 'package:flutter/material.dart';
import 'package:ias/screens/students/data/student_data.dart';
import 'package:ias/screens/students/widget/chart/marks_performance.dart';

Widget marksSection(
    BuildContext context, StudentData student, ColorScheme colorScheme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
        child: Text(
          'Latest Exam Performance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      // 💡 Make the Card tappable
      InkWell(
        onTap: () {
          // 🚀 CALL THE POP-UP FUNCTION ON TAP
          showMarksDetails(context, student);
        },
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: student.currentYearMarks.map((mark) {
              // Use currentYearMarks here
              final double percentage = (mark.score / mark.maxMarks);
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.secondary.withOpacity(0.1),
                  child: Text('${(percentage * 100).round()}',
                      style: TextStyle(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.bold)),
                ),
                title: Text(mark.subject),
                subtitle: Text('Score: ${mark.score} / ${mark.maxMarks}'),
                trailing: SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: colorScheme.surfaceVariant,
                    color:
                        percentage > 0.85 ? Colors.green : colorScheme.primary,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    ],
  );
}
