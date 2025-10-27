import 'package:flutter/material.dart';
import 'package:ias/ui/screens/students/widget/customWidget/attendance_card.dart';
import 'package:ias/ui/screens/students/widget/customWidget/fees_card.dart';
import 'package:ias/ui/screens/students/widget/customWidget/header_card.dart';
import 'package:ias/ui/screens/students/widget/customWidget/marks_section.dart';
import 'package:ias/ui/screens/students/widget/customWidget/schedule_card.dart';
import 'package:ias/ui/screens/students/widget/customWidget/upcoming_event.dart';
import 'package:ias/ui/screens/students/data/student_data.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final student = StudentData();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // 📚 Modern Material 3 App Bar
      appBar: AppBar(
        title: const Text('My Dashboard'),
        backgroundColor: colorScheme.primaryContainer,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {/* Go to notifications */},
            color: colorScheme.onPrimaryContainer,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // 1. 👋 Header & Student Details Card
          headerCard(student, colorScheme),
          const SizedBox(height: 20),

          // 2. ⚡ Quick Glance / Action Cards
          Row(
            children: [
              Expanded(child: attendanceCard(context, student, colorScheme)),
              const SizedBox(width: 16),
              Expanded(child: scheduleCard(context, student, colorScheme)),
            ],
          ),
          const SizedBox(height: 20),

          // 3. 💰 Financial Status (Fees)
          feesCard(context, student, colorScheme),
          const SizedBox(height: 20),

          // 4. 📊 Academic Performance (Marks/Grades)
          marksSection(context, student, colorScheme),
          const SizedBox(height: 20),

          // 5. 🗓️ Upcoming Events/Holiday (Bonus Feature)
          upcomingEventsCard(colorScheme),
        ],
      ),
    );
  }
}
