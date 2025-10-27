import 'package:flutter/material.dart';

// Mock data for attended days in a month
// In a real application, this data would come from an API
final Set<DateTime> mockAttendedDates = {
  // October 2025: 1st, 2nd, 3rd, 6th, 7th, 8th, 9th, 10th, 13th, 14th, 15th, 16th, 17th, 20th, 21st, 22nd, 23rd
  DateTime(2025, 10, 1),
  DateTime(2025, 10, 2),
  DateTime(2025, 10, 3),
  DateTime(2025, 10, 6),
  DateTime(2025, 10, 7),
  DateTime(2025, 10, 8),
  DateTime(2025, 10, 9),
  DateTime(2025, 10, 10),
  DateTime(2025, 10, 13),
  DateTime(2025, 10, 14),
  DateTime(2025, 10, 15),
  DateTime(2025, 10, 16),
  DateTime(2025, 10, 17),
  DateTime(2025, 10, 20),
  DateTime(2025, 10, 21),
  DateTime(2025, 10, 22),
  DateTime(2025, 10, 23),
};

// Assume the mockAttendedDates Set is defined globally or passed in.

void showAttendanceCalendar(BuildContext context, Set<DateTime> attendedDates) {
  final colorScheme = Theme.of(context).colorScheme;

  // UX Principle: Find the earliest date in the set to determine the starting month
  final DateTime initialMonth = attendedDates.isEmpty
      ? DateTime.now()
      : DateTime(attendedDates.first.year, attendedDates.first.month, 1);

  // For demonstration, we'll hardcode October 2025
  final DateTime displayMonth = DateTime(2025, 10, 1);
  final int daysInMonth =
      DateTime(displayMonth.year, displayMonth.month + 1, 0).day;
  final int firstDayWeekday = displayMonth.weekday; // 1 (Monday) - 7 (Sunday)

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        // M3 Style: Rounded corners and elevated dialog
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(
          'Attendance Details',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: SizedBox(
          width:
              MediaQuery.of(context).size.width * 0.5, // Dialog expands nicely
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Month Title & Navigation (Basic Simulation)
                Text(
                  '${_getMonthName(displayMonth.month)} ${displayMonth.year}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary),
                ),
                const SizedBox(height: 12),

                // Day of Week Headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                      .map((day) => Text(day,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.secondary)))
                      .toList(),
                ),
                const Divider(),

                // Calendar Grid View
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount:
                      daysInMonth + firstDayWeekday - 1, // Total cells needed
                  itemBuilder: (context, index) {
                    final dayOfMonth =
                        index - firstDayWeekday + 2; // Day calculation

                    // Cells before the first day of the month are empty
                    if (dayOfMonth <= 0 || dayOfMonth > daysInMonth) {
                      return const SizedBox.shrink();
                    }

                    final currentDate = DateTime(
                        displayMonth.year, displayMonth.month, dayOfMonth);
                    // Check if the student attended on this date
                    final bool isAttended = attendedDates.any((date) =>
                        date.year == currentDate.year &&
                        date.month == currentDate.month &&
                        date.day == currentDate.day);

                    return Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isAttended
                              ? colorScheme.primaryContainer
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: isAttended
                              ? null
                              : Border.all(color: colorScheme.outlineVariant),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          dayOfMonth.toString(),
                          style: TextStyle(
                            color: isAttended
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                            fontWeight: isAttended
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // UX Principle: Legend for Clarity
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       width: 12,
                //       height: 12,
                //       decoration: BoxDecoration(
                //         color: colorScheme.primaryContainer,
                //         shape: BoxShape.circle,
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     const Text('Attended Day'),
                //     const SizedBox(width: 16),
                //     Container(
                //       width: 12,
                //       height: 12,
                //       decoration: BoxDecoration(
                //         border: Border.all(color: colorScheme.outlineVariant),
                //         shape: BoxShape.circle,
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     const Text('Absent Day'),
                //   ],
                // ),
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

// Helper function to get the month name
String _getMonthName(int month) {
  const List<String> monthNames = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return monthNames[month];
}
