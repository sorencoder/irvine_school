import 'package:flutter/material.dart';
import 'package:ias/ui/screens/admin/home/widgets/chart/attendance_bar_chart.dart';
import 'package:ias/ui/screens/admin/home/widgets/chart/fee_pie_chart.dart';
import 'package:ias/ui/screens/admin/home/widgets/chart/performance_line_chart.dart';
import 'package:ias/ui/screens/admin/manageStudent/student_management_screen.dart';
import 'package:ias/ui/screens/admin/home/widgets/customWidgets/chart_card.dart';
import 'package:ias/ui/screens/admin/home/widgets/customWidgets/summary_card.dart';
import 'package:ias/ui/screens/admin/manageTeachers/manage_teachers.dart';
import 'package:ias/data/models/data_model_dashboard.dart';

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
  // Added state to control if the rail is extended, making it easier to manage the layout.
  bool _isExtended = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Determine the current screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    // Based on the size, automatically extend or collapse the rail
    // Or you can add a button to toggle _isExtended if desired
    _isExtended = isDesktop;

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
          // 🛠️ FIX: Wrap the NavigationRail content in a SingleChildScrollView
          // to prevent vertical overflow when the list of items is long.
          SizedBox(
            width: _isExtended ? 200 : null,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Ensure the NavigationRail always takes up the full available height
                  // without causing overflow (since SingleChildScrollView handles the overflow)
                  minHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top,
                ),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    extended: _isExtended, // Use the state variable
                    backgroundColor:
                        colorScheme.surfaceVariant.withOpacity(0.2),
                    selectedIndex: _selectedIndex,
                    groupAlignment: -1.0,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: _isExtended
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.all,
                    leading: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, bottom: 24.0, left: 16.0, right: 16.0),
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
                              selectedIcon:
                                  Icon(item.icon, color: colorScheme.primary),
                              label: Text(item.label),
                            ))
                        .toList(),
                    // Add a trailing section here if needed (e.g., Logout Button)
                    // If you have a trailing widget, ensure it doesn't cause overflow either.
                    trailing: const SizedBox(
                        height: 16), // A small buffer at the bottom
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          // Main Content Area
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                DashboardHome(),
                StudentManagementScreen(),
                // TeacherManagementScreen(),
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
            itemCount: mockSummaryDataDashboard.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              childAspectRatio: 3 / 1.5,
              crossAxisSpacing: 20,
              mainAxisSpacing: 2,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Viewing ${mockSummaryDataDashboard[index].title} details')), // Fixed interpolation
                    );
                  },
                  child: SummaryCard(data: mockSummaryDataDashboard[index]));
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
                        ? constraints.maxWidth * 0.6
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
                        ? constraints.maxWidth * 0.3
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
                        ? constraints.maxWidth * 0.99
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
