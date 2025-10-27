import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Used for chart data

// --- 1. Navigation Models ---

enum NavItem {
  dashboard,
  students,
  teachers,
  attendance,
  fees,
  academics,
  communication,
  administration,
  settings,
}

class NavItemData {
  final NavItem item;
  final String label;
  final IconData icon;

  const NavItemData(this.item, this.label, this.icon);
}

const List<NavItemData> navItems = [
  NavItemData(NavItem.dashboard, 'Dashboard', Icons.dashboard_outlined),
  NavItemData(NavItem.students, 'Students', Icons.school_outlined),
  NavItemData(NavItem.teachers, 'Teachers', Icons.group_outlined),
  NavItemData(NavItem.attendance, 'Attendance', Icons.calendar_today_outlined),
  NavItemData(NavItem.fees, 'Fees', Icons.payments_outlined),
  NavItemData(NavItem.academics, 'Academics', Icons.book_outlined),
  NavItemData(NavItem.communication, 'Communication', Icons.forum_outlined),
  NavItemData(
      NavItem.administration, 'Admin', Icons.settings_applications_outlined),
  NavItemData(NavItem.settings, 'Settings', Icons.settings_outlined),
];

// --- 2. Summary Card Model ---

class SummaryCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

final List<SummaryCardData> mockSummaryDataDashboard = [
  const SummaryCardData(
    title: 'Total Students',
    value: '1,560',
    icon: Icons.people_outline,
    color: Color(0xFF673AB7), // Deep Purple
  ),
  const SummaryCardData(
    title: 'Total Teachers',
    value: '85',
    icon: Icons.person_pin_outlined,
    color: Color(0xFF00BCD4), // Cyan
  ),
  const SummaryCardData(
    title: 'Pending Fees',
    value: '₹ 8,50,000',
    icon: Icons.monetization_on_outlined,
    color: Color(0xFFF44336), // Red
  ),
  const SummaryCardData(
    title: 'Working Days Left (2025-2026)',
    value: '125 Days',
    icon: Icons.access_time_outlined,
    color: Color(0xFF4CAF50), // Green
  ),
];

// --- 3. Chart Data Models ---

// Mock data for the Bar Chart (Attendance)
List<BarChartGroupData> getAttendanceBarGroups(ColorScheme colorScheme) {
  final List<double> monthlyAttendance = [
    85,
    90,
    92,
    88,
    95,
    96,
    91,
    89,
    93,
    97
  ];
  return monthlyAttendance.asMap().entries.map((entry) {
    return BarChartGroupData(
      x: entry.key,
      barRods: [
        BarChartRodData(
          toY: entry.value,
          color: colorScheme.tertiary,
          width: 14,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
      showingTooltipIndicators: [],
    );
  }).toList();
}

// Mock data for the Pie Chart (Fee Status)
class PieChartDataModel {
  final double value;
  final String title;
  final Color color;

  PieChartDataModel(this.value, this.title, this.color);
}

List<PieChartSectionData> getFeePieSections(ColorScheme colorScheme) {
  final List<PieChartDataModel> data = [
    PieChartDataModel(75, 'Paid', colorScheme.primary),
    PieChartDataModel(15, 'Pending', colorScheme.error),
    PieChartDataModel(10, 'Waived', colorScheme.secondary),
  ];

  return data.asMap().entries.map((entry) {
    final index = entry.key;
    final model = entry.value;

    return PieChartSectionData(
      color: model.color,
      value: model.value,
      title: '${model.title}\n${model.value.toStringAsFixed(0)}%',
      radius: 80,
      titleStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: colorScheme.onPrimary,
      ),
      // badgeWidget: index == 0 // Optional badge for highlight
      //     ? const Icon(Icons.check_circle_outline,
      //         color: Colors.white, size: 16)
      //     : null,
      badgePositionPercentageOffset: .98,
    );
  }).toList();
}

// Mock data for the Line Chart (Performance Trend)
List<FlSpot> getPerformanceLineData() {
  // Mock average class performance over 6 exams/months
  return [
    const FlSpot(0, 75),
    const FlSpot(1, 82),
    const FlSpot(2, 78),
    const FlSpot(3, 85),
    const FlSpot(4, 90),
    const FlSpot(5, 88),
  ];
}
