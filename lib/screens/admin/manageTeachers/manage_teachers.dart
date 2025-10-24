import 'package:flutter/material.dart';
import 'package:ias/provider/teacher/teacher_provider.dart';
import 'package:ias/screens/teachers/data/mock_data.dart';
import 'package:provider/provider.dart';
// Note: Assuming these are the correct paths in your project

class TeacherManagementScreen extends StatelessWidget {
  const TeacherManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        // Consumer listens to TeacherManagement provider
        child: Consumer<TeacherManagement>(
          builder: (context, teacherProvider, _) {
            final teachers = teacherProvider.filteredTeachers;

            // Dynamic filter options
            final uniqueDepartments = [
              'All Departments',
              ...{for (var t in mockTeacherList) t.department}.toList()
            ];
            final experienceRanges = ['0–5 yrs', '6–10 yrs', '10+ yrs'];
            final employmentTypes = ['Full-Time', 'Part-Time', 'Contract'];
            final statuses = ['All Statuses', 'Active', 'On Leave', 'Resigned'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧱 Header & Quick Actions
                _buildHeader(context, colorScheme, teacherProvider),
                const SizedBox(height: 24),

                // 📊 Analytics / Insights Cards
                _buildAnalyticsCards(context, colorScheme, teacherProvider),
                const SizedBox(height: 32),

                // 🔍 Filters & Search Controls
                _buildFilterControls(
                    context,
                    teacherProvider,
                    uniqueDepartments,
                    experienceRanges,
                    employmentTypes,
                    statuses),
                const SizedBox(height: 26),

                // 🧾 Teacher Data Table (Main Content)
                _buildDataTable(
                    context, colorScheme, teachers, teacherProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme,
      TeacherManagement teacherProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teacher Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${teacherProvider.activeTeacherCount} Active Teachers',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        // Quick Buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Export Data Button
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting Teacher Data...')),
                );
              },
              icon: const Icon(Icons.download_outlined),
              label: const Text('Export'),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(width: 12),
            // Add New Teacher Button
            ElevatedButton.icon(
              onPressed: () =>
                  _showAddEditTeacherDialog(context, teacherProvider),
              icon: const Icon(Icons.add),
              label: const Text('Add Teacher'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalyticsCards(BuildContext context, ColorScheme colorScheme,
      TeacherManagement teacherProvider) {
    final cardData = [
      {
        'title': 'Total Teachers',
        'value': mockTeacherList.length.toString(),
        'icon': Icons.people_alt,
        'color': colorScheme.primary
      },
      {
        'title': 'Avg. Experience',
        'value': '${teacherProvider.averageExperience.toStringAsFixed(1)} yrs',
        'icon': Icons.trending_up,
        'color': colorScheme.tertiary
      },
      {
        'title': 'On Leave',
        'value': teacherProvider.onLeaveCount.toString(),
        'icon': Icons.time_to_leave,
        'color': colorScheme.error
      },
      {
        'title': 'Departments',
        'value': teacherProvider.departmentCount.toString(),
        'icon': Icons.business,
        'color': colorScheme.secondary
      },
    ];

    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: cardData
          .map((data) => SizedBox(
                width: 250, // Fixed width for desktop layout
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(data['title'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurfaceVariant,
                                )),
                            Icon(data['icon'] as IconData,
                                color: data['color'] as Color, size: 24),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data['value'] as String,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildFilterControls(
      BuildContext context,
      TeacherManagement teacherProvider,
      List<String> departments,
      List<String> experienceRanges,
      List<String> employmentTypes,
      List<String> statuses) {
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      alignment: WrapAlignment.start,
      children: [
        // Search Field
        SizedBox(
          width: 310,
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search by Name, ID, or Subject',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              isDense: true,
            ),
            onChanged: (value) => teacherProvider.setSearchQuery(value),
          ),
        ),

        // Department Filter Dropdown
        SizedBox(
          width: 200,
          child: DropdownButtonFormField<String>(
            decoration: _dropdownDecoration(labelText: 'Department/Subject'),
            value: teacherProvider.selectedDepartment ?? 'All Departments',
            onChanged: (String? newValue) {
              teacherProvider.setDepartmentFilter(
                  newValue == 'All Departments' ? null : newValue);
            },
            items: departments.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ),

        // Employment Type Filter (ChoiceChip style for quick toggle)
        // SizedBox(
        //   width: 200,
        //   child: DropdownButtonFormField<String>(
        //     decoration: _dropdownDecoration(labelText: 'Employment Type'),
        //     value: teacherProvider.selectedEmploymentType,
        //     hint: const Text('All Types'),
        //     onChanged: (String? newValue) {
        //       teacherProvider.setEmploymentTypeFilter(newValue);
        //     },
        //     items:
        //         employmentTypes.map<DropdownMenuItem<String>>((String value) {
        //       return DropdownMenuItem<String>(value: value, child: Text(value));
        //     }).toList(),
        //   ),
        // ),

        // Experience Filter Dropdown
        // SizedBox(
        //   width: 150,
        //   child: DropdownButtonFormField<String>(
        //     decoration: _dropdownDecoration(labelText: 'Experience'),
        //     value: teacherProvider.selectedExperienceRange,
        //     hint: const Text('All Experience'),
        //     onChanged: (String? newValue) {
        //       teacherProvider.setExperienceFilter(newValue);
        //     },
        //     items:
        //         experienceRanges.map<DropdownMenuItem<String>>((String value) {
        //       return DropdownMenuItem<String>(value: value, child: Text(value));
        //     }).toList(),
        //   ),
        // ),

        // Status Filter Dropdown
        SizedBox(
          width: 150,
          child: DropdownButtonFormField<String>(
            decoration: _dropdownDecoration(labelText: 'Status'),
            value: teacherProvider.selectedStatus ?? 'All Statuses',
            onChanged: (String? newValue) {
              teacherProvider.setStatusFilter(
                  newValue == 'All Statuses' ? null : newValue);
            },
            items: statuses.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      isDense: true,
    );
  }

  Widget _buildDataTable(
    BuildContext context,
    ColorScheme colorScheme,
    List<Teacher> teachers,
    TeacherManagement teacherProvider,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 800;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: constraints.maxWidth < 900 ? 900 : constraints.maxWidth,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 30,
                  horizontalMargin: 15,
                  headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => colorScheme.surfaceVariant,
                  ),
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('NAME')),
                    DataColumn(label: Text('SUBJECT / DEPT.')),
                    DataColumn(label: Text('EXPERIENCE (YRS)'), numeric: true),
                    DataColumn(label: Text('RATING'), numeric: true),
                    DataColumn(label: Text('STATUS')),
                    DataColumn(label: Text('ACTIONS')),
                  ],
                  rows: teachers.map((teacher) {
                    return DataRow(
                      cells: [
                        DataCell(Text(teacher.id)),
                        DataCell(Text(teacher.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(
                            Text('${teacher.subject} / ${teacher.department}')),
                        DataCell(Text(
                          teacher.yearsOfExperience.toString(),
                          textAlign: TextAlign.right,
                        )),
                        DataCell(Text(
                          teacher.rating.toStringAsFixed(1),
                          textAlign: TextAlign.right,
                        )),
                        DataCell(_buildStatusChip(colorScheme, teacher.status)),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_red_eye_outlined,
                                  size: 20),
                              onPressed: () =>
                                  _showViewTeacherDialog(context, teacher),
                              tooltip: 'View Profile',
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () => _showAddEditTeacherDialog(
                                  context, teacherProvider,
                                  existingTeacher: teacher),
                              tooltip: 'Edit Info',
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline,
                                  size: 20, color: colorScheme.error),
                              onPressed: () => _showDeleteConfirmationDialog(
                                  context, teacherProvider, teacher),
                              tooltip: 'Delete Teacher',
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(ColorScheme colorScheme, String status) {
    Color chipColor;
    Color textColor = Colors.white;

    switch (status) {
      case 'Active':
        chipColor = Colors.green.shade600;
        break;
      case 'On Leave':
        chipColor = Colors.orange.shade700;
        break;
      case 'Resigned':
        chipColor = Colors.red.shade700;
        break;
      default:
        chipColor = colorScheme.surfaceVariant;
        textColor = colorScheme.onSurface;
    }

    return Chip(
      label: Text(status),
      backgroundColor: chipColor,
      labelStyle: TextStyle(
          color: textColor, fontWeight: FontWeight.bold, fontSize: 10),
      visualDensity: VisualDensity.compact,
    );
  }

  // --- Dialogs and Modals ---

  void _showViewTeacherDialog(BuildContext context, Teacher teacher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${teacher.name}\'s Profile'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ID: ${teacher.id}'),
                Text('Department: ${teacher.department} (${teacher.subject})'),
                Text('Experience: ${teacher.yearsOfExperience} years'),
                Text('Rating: ${teacher.rating.toStringAsFixed(1)} / 5.0'),
                Text('Employment: ${teacher.employmentType}'),
                Text('Status: ${teacher.status}'),
                Text('Contact: ${teacher.contactInfo}'),
                Text('Salary: ₹${teacher.salary.toStringAsFixed(0)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, TeacherManagement provider, Teacher teacher) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete the record for ${teacher.name} (${teacher.id})? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                provider.deleteTeacher(teacher.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Teacher ${teacher.name} deleted.')),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddEditTeacherDialog(
      BuildContext context, TeacherManagement provider,
      {Teacher? existingTeacher}) {
    final bool isEditing = existingTeacher != null;
    final formKey = GlobalKey<FormState>();

    // Initial values for the form
    String name = existingTeacher?.name ?? '';
    String id = existingTeacher?.id ??
        'TCH${(mockTeacherList.length + 1).toString().padLeft(4, '0')}';
    String subject = existingTeacher?.subject ?? '';
    String department = existingTeacher?.department ?? 'Science';
    int experience = existingTeacher?.yearsOfExperience ?? 0;
    String employmentType = existingTeacher?.employmentType ?? 'Full-Time';
    String status = existingTeacher?.status ?? 'Active';
    String contact = existingTeacher?.contactInfo ?? '';
    double salary = existingTeacher?.salary ?? 0.0;
    double rating = existingTeacher?.rating ?? 4.0;

    final departments = ['Science', 'Mathematics', 'English', 'Humanities'];
    // final employmentTypes = ['Full-Time', 'Part-Time', 'Contract'];
    final statuses = ['Active', 'On Leave', 'Resigned'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEditing
              ? 'Edit Teacher: ${existingTeacher.name}'
              : 'Add New Teacher'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onSaved: (v) => name = v!,
                    validator: (v) => v!.isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: id,
                    readOnly: isEditing,
                    decoration: const InputDecoration(
                        labelText: 'Employee ID (Read Only)'),
                    onSaved: (v) => id = v!,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Department'),
                    value: department,
                    items: departments
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (v) => department = v!,
                    onSaved: (v) => department = v!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: subject,
                    decoration: const InputDecoration(labelText: 'Subject'),
                    onSaved: (v) => subject = v!,
                    validator: (v) => v!.isEmpty ? 'Subject is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: experience.toString(),
                    decoration:
                        const InputDecoration(labelText: 'Years of Experience'),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => experience = int.tryParse(v!) ?? 0,
                    validator: (v) =>
                        int.tryParse(v!) == null ? 'Must be a number' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: salary.toStringAsFixed(0),
                    decoration: const InputDecoration(labelText: 'Salary (₹)'),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => salary = double.tryParse(v!) ?? 0.0,
                    validator: (v) =>
                        double.tryParse(v!) == null ? 'Must be a number' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: rating.toStringAsFixed(1),
                    decoration: const InputDecoration(
                        labelText: 'Performance Rating (Max 5.0)'),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => rating = double.tryParse(v!) ?? 4.0,
                    validator: (v) {
                      final val = double.tryParse(v!);
                      if (val == null || val < 0 || val > 5) {
                        return 'Rating must be between 0 and 5.0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // DropdownButtonFormField<String>(
                  //   decoration:
                  //       const InputDecoration(labelText: 'Employment Type'),
                  //   value: employmentType,
                  //   items: employmentTypes
                  //       .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  //       .toList(),
                  //   onChanged: (v) => employmentType = v!,
                  //   onSaved: (v) => employmentType = v!,
                  // ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Status'),
                    value: status,
                    items: statuses
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => status = v!,
                    onSaved: (v) => status = v!,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              child: Text(isEditing ? 'Save Changes' : 'Add Teacher'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  final newTeacher = Teacher(
                    id: id,
                    name: name,
                    subject: subject,
                    department: department,
                    yearsOfExperience: experience,
                    rating: rating,
                    employmentType: employmentType,
                    status: status,
                    contactInfo:
                        contact, // Note: Contact field not added to form for brevity
                    salary: salary,
                  );

                  provider.addOrUpdateTeacher(newTeacher);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '${newTeacher.name} ${isEditing ? 'updated' : 'added'} successfully!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
