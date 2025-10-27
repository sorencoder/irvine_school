import 'package:flutter/material.dart';
import 'package:ias/ui/screens/students/data/student_data.dart';

Widget headerCard(StudentData student, ColorScheme colorScheme) {
  return Card(
    elevation: 4,
    color: colorScheme.primary, // Use primary color for a distinct header
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, ${student.name.split(' ')[0]}!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: colorScheme.tertiaryContainer,
              child: Icon(Icons.person,
                  size: 30, color: colorScheme.onTertiaryContainer),
            ),
            title: Text(
              student.name,
              style: TextStyle(
                  color: colorScheme.onPrimary, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Class: ${student.grade} | Roll No: ${student.rollNumber} | Aadhar No: ${student.aadharNumber}',
              style: TextStyle(color: colorScheme.onPrimary.withOpacity(0.8)),
            ),
          ),
        ],
      ),
    ),
  );
}
