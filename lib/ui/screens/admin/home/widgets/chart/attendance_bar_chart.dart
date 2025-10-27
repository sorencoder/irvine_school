import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ias/data/models/data_model_dashboard.dart';

// 5.1. Attendance Bar Chart
class AttendanceBarChart extends StatelessWidget {
  const AttendanceBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: getAttendanceBarGroups(colorScheme),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
            show: true, drawVerticalLine: false, horizontalInterval: 10),
        titlesData: FlTitlesData(
          show: true,
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const monthLabels = [
                  'January',
                  'February',
                  'March',
                  'April',
                  'May',
                  'June',
                  'July',
                  'August',
                  'September',
                  'October'
                ];
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(
                    monthLabels[
                        value.toInt() % 10], // Use modulo for safe indexing
                    style: TextStyle(
                        color: colorScheme.onSurfaceVariant, fontSize: 10),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                      color: colorScheme.onSurfaceVariant, fontSize: 10),
                );
              },
            ),
          ),
        ),
        // Add BarTouchData for interactivity
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (touchSpot) {
              return colorScheme.inverseSurface;
            },
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(1)}%',
                TextStyle(
                    color: colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ),
    );
  }
}
