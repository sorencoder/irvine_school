import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ias/data/models/data_model_dashboard.dart';

// 5.2. Fee Pie Chart
class FeePieChart extends StatelessWidget {
  const FeePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: getFeePieSections(colorScheme),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              pieTouchData: PieTouchData(enabled: true),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: getFeePieSections(colorScheme).map((section) {
            final title = section.title.split('\n')[0];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: section.color,
                  ),
                ),
                const SizedBox(width: 6),
                Text(title,
                    style: TextStyle(color: colorScheme.onSurfaceVariant)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
