import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ias/data/models/data_model_dashboard.dart';

// 5.3. Performance Line Chart
class PerformanceLineChart extends StatelessWidget {
  const PerformanceLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 10,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
                color: colorScheme.surfaceVariant,
                strokeWidth: 1,
                dashArray: [5, 5]);
          },
        ),
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
              interval: 1,
              getTitlesWidget: (value, meta) {
                const examLabels = [
                  '2020',
                  '2021',
                  '2022',
                  '2023',
                  '2024',
                  '2025'
                ];
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8.0,
                  child: Text(
                    examLabels[value.toInt()],
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
              reservedSize: 40,
              interval: 10,
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
        borderData: FlBorderData(
          show: true,
          border: Border.all(
              color: colorScheme.surfaceVariant.withOpacity(0.5), width: 1),
        ),
        minX: 0,
        maxX: 5,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: getPerformanceLineData(),
            isCurved: true,
            color: colorScheme.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: colorScheme.primary,
                strokeColor: colorScheme.onPrimary,
                strokeWidth: 2,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ],
        // Add LineTouchData for interactivity
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchSpot) {
              return colorScheme.inverseSurface;
            },
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  'Score: ${touchedSpot.y.toStringAsFixed(1)}',
                  TextStyle(
                      color: colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
