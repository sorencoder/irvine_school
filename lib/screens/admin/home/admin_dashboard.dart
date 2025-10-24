import 'package:flutter/material.dart';
import 'package:ias/screens/admin/home/widgets/chart/attendance_bar_chart.dart';
import 'package:ias/screens/admin/home/widgets/chart/fee_pie_chart.dart';
import 'package:ias/screens/admin/home/widgets/chart/performance_line_chart.dart';
import 'package:ias/screens/admin/manageStudent/student_management_screen.dart';
import 'package:ias/screens/admin/home/widgets/customWidgets/chart_card.dart';
import 'package:ias/screens/admin/home/widgets/customWidgets/summary_card.dart';
import 'package:ias/screens/admin/manageTeachers/manage_teachers.dart';
import 'package:ias/utils/data_model.dart'; // Import the data models and mock data

void main() {
  runApp(const SchoolAdminDashboard());
}

// --- 1. Main Application Widget ---

class SchoolAdminDashboard extends StatelessWidget {
  const SchoolAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Material 3 Theme Configuration
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF673AB7), // Deep Purple, primary color
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter', // Default font
      ),
      home: const AdminDashboardShell(),
    );
  }
}

// --- 2. Shell with Navigation Rail (Responsive Layout) ---

class AdminDashboardShell extends StatefulWidget {
  const AdminDashboardShell({super.key});

  @override
  State<AdminDashboardShell> createState() => _AdminDashboardShellState();
}

class _AdminDashboardShellState extends State<AdminDashboardShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Use a LayoutBuilder to determine if we should show NavigationRail or Drawer
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: <Widget>[
          // Navigation Rail (Desktop/Tablet View)
          NavigationRail(
            backgroundColor: colorScheme.surfaceVariant.withOpacity(0.2),
            selectedIndex: _selectedIndex,
            groupAlignment: -1.0,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
              child: Text(
                'IAS Admin',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                ),
              ),
            ),
            destinations: navItems
                .map((item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.icon, color: colorScheme.primary),
                      label: Text(item.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(width: 1),
          // Main Content Area
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                DashboardHome(),
                StudentManagementScreen(),
                TeacherManagementScreen(),
                PlaceholderScreen(title: 'Attendance System'),
                PlaceholderScreen(title: 'Fee Management'),
                PlaceholderScreen(title: 'Academics'),
                PlaceholderScreen(title: 'Communication'),
                PlaceholderScreen(title: 'School Administration'),
                PlaceholderScreen(title: 'Settings'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- 3. Dashboard Home Screen ---

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, Admin!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),

          // 3.1. Summary Cards (Analytics Overview)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockSummaryData.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 350,
              childAspectRatio: 3 / 1.5,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Viewing ${mockSummaryData[index]} details')),
                    );
                  },
                  child: SummaryCard(data: mockSummaryData[index]));
            },
          ),
          const SizedBox(height: 32),

          Text(
            'Operational Insights',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // 3.2. Charts Section (Attendance, Fee, Performance)
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 24, // Horizontal gap
                runSpacing: 24, // Vertical gap
                children: [
                  // Chart 1: Attendance Chart (Bar Chart)
                  SizedBox(
                    width: constraints.maxWidth > 700
                        ? constraints.maxWidth * 0.45
                        : constraints.maxWidth,
                    height: 400,
                    child: ChartCard(
                      title: 'Monthly Attendance Trend (Last 10 Months)',
                      child: AttendanceBarChart(),
                    ),
                  ),

                  // Chart 2: Fee Collection Status (Pie Chart)
                  SizedBox(
                    width: constraints.maxWidth > 700
                        ? constraints.maxWidth * 0.45
                        : constraints.maxWidth,
                    height: 400,
                    child: ChartCard(
                      title: 'Fee Collection Status',
                      child: FeePieChart(),
                    ),
                  ),

                  // Chart 3: Class Performance Trend (Line Chart)
                  SizedBox(
                    width: constraints.maxWidth > 700
                        ? constraints.maxWidth * 0.95
                        : constraints.maxWidth,
                    height: 400,
                    child: ChartCard(
                      title: 'Average 10 Class Performance Trend',
                      child: PerformanceLineChart(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- 4. Custom Widgets ---
//Moved to a folder(customWidget)

// --- 5. Chart Implementations (using fl_chart) ---
//Moved to a folder (chart)

// Placeholder Screen for non-dashboard sections
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title - Implementation Pending',
        style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
