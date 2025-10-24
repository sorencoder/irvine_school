import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ias/provider/students/student_management.dart';
import 'package:ias/utils/data_model.dart';

class StudentManagementScreen extends StatelessWidget {
  const StudentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),

      // 👇 Consumer listens to StudentManagement provider
      child: Consumer<StudentManagement>(
        builder: (context, studentProvider, _) {
          final students = studentProvider.filteredStudents;
          final selectedClass = studentProvider.selectedClassFilter;
          final showFeeDue = studentProvider.showFeeDue;

          // Collect all unique classes dynamically from the mock list
          final uniqueClasses = [
            'All Classes',
            ...{for (var s in mockStudentList) s.className}
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧱 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Student Management (${students.length} results)',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Add New Student form opened')),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Student'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 🔍 Filters & Search
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                alignment: WrapAlignment.start,
                children: [
                  // Search Field
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search by Name or Roll No.',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        isDense: true,
                      ),
                      onChanged: (value) =>
                          studentProvider.setSearchQuery(value),
                    ),
                  ),

                  // Class Filter Dropdown
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Filter by Class',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        isDense: true,
                      ),
                      value: selectedClass ?? 'All Classes',
                      onChanged: (String? newValue) {
                        studentProvider.setClassFilter(
                            newValue == 'All Classes' ? null : newValue);
                      },
                      items: uniqueClasses
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),

                  // Fee Due Toggle
                  ActionChip(
                    label:
                        Text(showFeeDue ? 'Showing Fee Due' : 'All Students'),
                    avatar: Icon(
                        showFeeDue ? Icons.warning_amber : Icons.people_alt,
                        color: showFeeDue
                            ? colorScheme.error
                            : colorScheme.primary),
                    backgroundColor: showFeeDue
                        ? colorScheme.error.withOpacity(0.1)
                        : colorScheme.surfaceVariant,
                    onPressed: () =>
                        studentProvider.toggleFeeDueFilter(!showFeeDue),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 🧾 Students Table
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          columnSpacing: 30,
                          horizontalMargin: 15,
                          headingRowColor: MaterialStateProperty.resolveWith(
                              (states) => colorScheme.surfaceVariant),
                          columns: const [
                            DataColumn(label: Text('ROLL NO.')),
                            DataColumn(label: Text('NAME')),
                            DataColumn(label: Text('CLASS')),
                            DataColumn(
                                label: Text('AVG. SCORE',
                                    textAlign: TextAlign.right),
                                numeric: true),
                            DataColumn(label: Text('FEE STATUS')),
                            DataColumn(label: Text('ACTIONS')),
                            DataColumn(label: Text('DELETE')),
                          ],
                          rows: students.map((student) {
                            return DataRow(cells: [
                              DataCell(Text(student.rollNumber.toString())),
                              DataCell(Text(student.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                              DataCell(Text(student.className)),
                              DataCell(Text(
                                  student.averageScore.toStringAsFixed(1),
                                  textAlign: TextAlign.right)),
                              DataCell(
                                Chip(
                                  label: Text(
                                      student.feeStatus ? 'Paid' : 'Due',
                                      style: TextStyle(
                                          color: colorScheme.onPrimary)),
                                  backgroundColor: student.feeStatus
                                      ? colorScheme.primary
                                      : colorScheme.error,
                                ),
                              ),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 20),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Viewing ${student.name}')));
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 20),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Editing ${student.name}')));
                                    },
                                  ),
                                ],
                              )),
                              DataCell(IconButton(
                                icon: Icon(Icons.delete_outline,
                                    size: 20, color: colorScheme.error),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Deleting ${student.name}')),
                                  );
                                },
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
