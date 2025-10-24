import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ias/screens/students/data/student_data.dart';

// (NOTE: Assuming your StudentData, YearPerformance, and SubjectMark classes are defined elsewhere)

void showMarksDetails(BuildContext context, StudentData student) {
  final colorScheme = Theme.of(context).colorScheme;

  // Prepare data for the Bar Chart
  final currentYearPerformance = student.historicalPerformance.firstWhere(
    (perf) => perf.year == '2025', // Assuming '2025' is current year for mock
    orElse: () => YearPerformance('2025', []),
  );
  final previousYearPerformance = student.historicalPerformance.firstWhere(
    (perf) => perf.year == '2024',
    orElse: () => YearPerformance('2024', []),
  );

  // Map subjects to a consistent order for the chart
  final List<String> subjects = [
    'Mathematics',
    'Science',
    'English',
    'Computer'
  ]; // Consistent order

  List<BarChartGroupData> getBarGroups() {
    return subjects.asMap().entries.map((entry) {
      int index = entry.key;
      String subject = entry.value;

      final currentMark = currentYearPerformance.subjectMarks
          .firstWhere((m) => m.subject == subject,
              orElse: () => SubjectMark(subject, 0, 100))
          .score
          .toDouble();
      final previousMark = previousYearPerformance.subjectMarks
          .firstWhere((m) => m.subject == subject,
              orElse: () => SubjectMark(subject, 0, 100))
          .score
          .toDouble();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: previousMark,
            color:
                colorScheme.secondary.withOpacity(0.6), // Previous year color
            width: 16,
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: currentMark,
            color: colorScheme.primary, // Current year color
            width: 16,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
        // showingTooltipIndicators: const [
        //   0,
        //   1
        // ], // Show tooltips for both bars in the group
      );
    }).toList();
  }

  // Bar Chart Title (X-axis)
  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = subjects[0];
        break;
      case 1:
        text = subjects[1];
        break;
      case 2:
        text = subjects[2];
        break;
      case 3:
        text = subjects[3];
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text('Academic Performance',
            style: TextStyle(color: colorScheme.onSurface)),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Current Year Subject Marks List
                Text(
                  'Current Year Marks (${currentYearPerformance.year})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                ...student.currentYearMarks.map((mark) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(mark.subject,
                                  style: TextStyle(
                                      color: colorScheme.onSurfaceVariant))),
                          Text('${mark.score}/${mark.maxMarks}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface)),
                        ],
                      ),
                    )),
                const Divider(height: 30),

                // 2. Performance Comparison Chart (Bar Chart)
                Text(
                  'Year-on-Year Comparison',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200, // Height for the chart
                  child: BarChart(
                    BarChartData(
                      barGroups: getBarGroups(),
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 100, // Max score
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: getTitles,
                            reservedSize: 30,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval:
                                25, // Show intervals at 0, 25, 50, 75, 100
                            getTitlesWidget: (value, meta) {
                              return Text(value.toInt().toString(),
                                  style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 10));
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: colorScheme.outlineVariant.withOpacity(0.5),
                          strokeWidth: 0.5,
                          dashArray: [5, 5],
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false, // Hide outer border
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          // FIX 1: getTooltipColor is a function that returns Color
                          getTooltipColor: (touchSpot) {
                            return colorScheme.inverseSurface;
                          },
                          tooltipBorder: BorderSide(color: colorScheme.outline),
                          // FIX 2: Use tooltipBorderRadius instead of tooltipRoundedRadius (deprecated)
                          tooltipRoundedRadius: 8.0,

                          // tooltipBorderRadius: BorderRadius.circular(8),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String year = rodIndex == 0
                                ? previousYearPerformance.year
                                : currentYearPerformance.year;
                            return BarTooltipItem(
                              '$year\n',
                              TextStyle(
                                  color: colorScheme.onInverseSurface,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: '${rod.toY.toInt()}',
                                  style: TextStyle(
                                      color: colorScheme.onInverseSurface,
                                      fontSize: 14),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Chart Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      // FIX 3: Use BoxDecoration for both color and borderRadius
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(previousYearPerformance.year,
                        style: TextStyle(color: colorScheme.onSurfaceVariant)),
                    const SizedBox(width: 16),
                    Container(
                      width: 16,
                      height: 16,
                      // FIX 3: Use BoxDecoration for both color and borderRadius
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(currentYearPerformance.year,
                        style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
                const Divider(height: 30),

                // 3. Overall Averages (Bonus)
                Text(
                  'Overall Averages',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Current Year (${currentYearPerformance.year}):',
                        style: TextStyle(color: colorScheme.onSurfaceVariant)),
                    Text(
                        '${currentYearPerformance.averageScore.toStringAsFixed(1)}%',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Previous Year (${previousYearPerformance.year}):',
                        style: TextStyle(color: colorScheme.onSurfaceVariant)),
                    Text(
                        '${previousYearPerformance.averageScore.toStringAsFixed(1)}%',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.secondary)),
                  ],
                ),
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
