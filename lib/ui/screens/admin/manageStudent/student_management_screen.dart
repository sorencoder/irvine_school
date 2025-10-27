import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ias/logic/cubit/student_cubit/student_cubit.dart';
import 'package:ias/logic/cubit/student_cubit/student_states.dart';
import 'package:ias/data/models/student_data_model.dart';
import 'package:ias/logic/provider/students/student_filters_provider.dart';
import 'package:provider/provider.dart';
// ------------------------------------------------------------------
// --- STUDENT MANAGEMENT SCREEN (The main page logic) ---
// ------------------------------------------------------------------

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  @override
  void initState() {
    super.initState();
    // 🔹 Trigger initial data load from Firestore via Cubit
    context.read<StudentCubit>().loadStudents(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final provider = context.watch<StudentFilterProvider>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocListener<StudentCubit, StudentState>(
            listener: (context, state) {
              if (state is StudentLoaded) {
                provider.updateStudents(state.students);
              } else if (state is StudentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')));
              }
            },
            //BlocBuilder listens for Cubit loading/error states
            child: BlocBuilder<StudentCubit, StudentState>(
                builder: (context, state) {
              if (state is StudentError) {
                return Center(
                  child: Text(
                    'Failed to load student',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🧱 Header & Quick Actions
                  _buildHeader(context, colorScheme, provider.allStudents),
                  const SizedBox(height: 10),

                  // 📊 Analytics / Insights Cards
                  _buildAnalyticsCards(
                      context, colorScheme, provider.allStudents),
                  const SizedBox(height: 10),

                  // 🔍 Filters & Search Controls
                  _buildFilterControls(context, provider),

                  const SizedBox(height: 10),

                  // 🧾 Student Data Table (Main Content)
                  Expanded(child: _buildDataTable(context, colorScheme, state)),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  Widget _buildHeader(BuildContext context, ColorScheme colorScheme,
      List<Student> allStudents) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Management 🎓',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${allStudents.where((student) => student.status == 'Active').length} Active Students enrolled',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting Student Data...')),
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
            ElevatedButton.icon(
              onPressed: () => _showAddEditStudentDialog(context),
              icon: const Icon(Icons.person_add),
              label: const Text('Enroll Student'),
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
      List<Student> allStudents) {
    final onSuspensionCount =
        allStudents.where((s) => s.status == 'Suspended').length;
    final overdueFeesCount =
        allStudents.where((s) => s.feeStatus == 'Overdue').length;

    final cardData = [
      {
        'title': 'Total Students',
        'value': allStudents.length.toString(),
        'icon': Icons.school,
        'color': colorScheme.primary
      },
      {
        'title': 'Overdue Fees',
        'value': overdueFeesCount.toString(),
        'icon': Icons.payment,
        'color': colorScheme.error
      },
      {
        'title': 'On Suspension',
        'value': onSuspensionCount.toString(),
        'icon': Icons.gavel,
        'color': colorScheme.tertiary
      },
    ];

    return Wrap(
      spacing: 8.0, // less horizontal spacing
      runSpacing: 8.0, // less vertical spacing
      children: cardData
          .map((data) => SizedBox(
                width: 140, // smaller card width
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0), // reduced padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['title'] as String,
                              style: TextStyle(
                                fontSize: 12, // smaller font
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Icon(
                              data['icon'] as IconData,
                              color: data['color'] as Color,
                              size: 20, // smaller icon
                            ),
                          ],
                        ),
                        const SizedBox(height: 8), // reduced spacing
                        Text(
                          data['value'] as String,
                          style: TextStyle(
                            fontSize: 24, // smaller number
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
      BuildContext context, StudentFilterProvider provider) {
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
              labelText: 'Search by Name or Enroll No',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              isDense: true,
            ),
            onChanged: (value) {
              provider.updateSearchQuery(value);
            },
          ),
        ),

        // Status Filter Dropdown
        // CompactStatusDropdown(
        //   selectedStatus: provider.selectedStatus,
        //   onChanged: (val) => provider.changeStatus(val),
        // ),

        // SizedBox(
        //   width: 160,
        //   child: DropdownButtonFormField<String>(
        //     value: provider.selectedStatus,
        //     isDense: true, // ✅ makes the dropdown smaller vertically
        //     decoration: InputDecoration(
        //       labelText: 'Status',
        //       border:
        //           OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        //       contentPadding: const EdgeInsets.symmetric(
        //           horizontal: 10, vertical: 6), // ✅ smaller padding
        //     ),
        //     style: const TextStyle(fontSize: 14), // ✅ smaller text if needed
        //     items: const [
        //       DropdownMenuItem(value: 'All', child: Text('All')),
        //       DropdownMenuItem(value: 'Active', child: Text('Active')),
        //       DropdownMenuItem(value: 'Suspended', child: Text('Suspended')),
        //     ],
        //     onChanged: (value) {
        //       if (value != null) {
        //         provider.changeStatus(value);
        //       }
        //     },
        //   ),
        // ),

        // Fee Status Filter Dropdown
        // SizedBox(
        //   width: 160,
        //   child: DropdownButtonFormField<String>(
        //     value: provider.selectedFeeStatus,
        //     decoration: InputDecoration(
        //       labelText: 'Fee Status',
        //       border:
        //           OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        //       contentPadding:
        //           const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        //     ),
        //     items: const [
        //       DropdownMenuItem(value: 'All', child: Text('All')),
        //       DropdownMenuItem(value: 'Paid', child: Text('Paid')),
        //       DropdownMenuItem(value: 'Pending', child: Text('Pending')),
        //     ],
        //     onChanged: (value) {
        //       if (value != null) {
        //         provider.changeFeeStatus(value);
        //       }
        //     },
        //   ),
        // ),
      ],
    );
  }

  // InputDecoration _dropdownDecoration({required String labelText}) {
  //   return InputDecoration(
  //     labelText: labelText,
  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //     isDense: true,
  //   );
  // }

  Widget _buildDataTable(
      BuildContext context, ColorScheme colorScheme, StudentState state) {
    final studentCubit = context.read<StudentCubit>();
    final provider = context.watch<StudentFilterProvider>();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(12),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrolInfo) {
          if (scrolInfo.metrics.pixels >
                  scrolInfo.metrics.maxScrollExtent - 150 &&
              scrolInfo is ScrollUpdateNotification) {
            final state = studentCubit.state;
            if (state is StudentLoaded && state.hasMore) {
              studentCubit.loadStudents();
            }
          }
          return false;
        },
        child: Consumer<StudentFilterProvider>(
          builder: (context, provider, child) {
            final students = provider.students;
            if (state is StudentLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (students.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(child: Text('No student found!')),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth, // full parent width
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // horizontal scroll
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical, // vertical scroll
                            child: DataTable(
                              columnSpacing: 30,
                              horizontalMargin: 15,
                              headingRowColor:
                                  MaterialStateProperty.resolveWith(
                                (states) => colorScheme.surfaceVariant,
                              ),
                              columns: const [
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('NAME')),
                                DataColumn(label: Text('CLASS')),
                                DataColumn(
                                    label: Text('ATTENDANCE (%)'),
                                    numeric: true),
                                DataColumn(label: Text('FEE STATUS')),
                                DataColumn(label: Text('STATUS')),
                                DataColumn(label: Text('ACTIONS')),
                              ],
                              rows: students.map((student) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                        Text(student.rollNumber.toString())),
                                    DataCell(Text(
                                      student.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataCell(Text(
                                        '${student.className} ${student.section}')),
                                    DataCell(Text(student.academicRecords.first
                                        .attendance.percentage
                                        .toStringAsFixed(2))),
                                    DataCell(_buildFeeStatusChip(
                                        colorScheme, student.feeStatus)),
                                    DataCell(_buildStatusChip(
                                        colorScheme, student.status)),
                                    DataCell(Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_red_eye_outlined,
                                              size: 20),
                                          onPressed: () =>
                                              _showViewStudentDialog(
                                                  context, student),
                                          tooltip: 'View Profile',
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined,
                                              size: 20),
                                          onPressed: () =>
                                              _showAddEditStudentDialog(context,
                                                  existingStudent: student),
                                          tooltip: 'Edit Info',
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete_outline,
                                              size: 20,
                                              color: colorScheme.error),
                                          onPressed: () =>
                                              _showDeleteConfirmationDialog(
                                                  context, student),
                                          tooltip: 'Delete Student',
                                        ),
                                      ],
                                    )),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
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
      case 'Suspended':
        chipColor = Colors.orange.shade700;
        break;
      case 'Graduated':
        chipColor = Colors.blueGrey.shade500;
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

  Widget _buildFeeStatusChip(ColorScheme colorScheme, String feeStatus) {
    Color chipColor;
    Color textColor = Colors.white;

    switch (feeStatus) {
      case 'Paid':
        chipColor = Colors.indigo.shade600;
        break;
      case 'Pending':
        chipColor = Colors.amber.shade700;
        textColor = Colors.black;
        break;
      case 'Overdue':
        chipColor = Colors.red.shade700;
        break;
      default:
        chipColor = colorScheme.surfaceVariant;
        textColor = colorScheme.onSurface;
    }

    return Chip(
      label: Text(feeStatus),
      backgroundColor: chipColor,
      labelStyle: TextStyle(
          color: textColor, fontWeight: FontWeight.bold, fontSize: 10),
      visualDensity: VisualDensity.compact,
    );
  }

  // ------------------------------------------------------------------
  void _showViewStudentDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(student.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ID: ${student.rollNumber}'),
                Text('Class: ${student.className} ${student.section}'),
                Text('Aadhar: ${student.aadharNumber}'),
                Text('Parent 📞: ${student.parentContact}'),
                Text('Status: ${student.status}'),
                Text('Fee Status: ${student.feeStatus}'),
                Text(
                    'Attendance: ${student.academicRecords.first.attendance.percentage.toStringAsFixed(2)}%'),
                const Divider(),
                Text("📘 Academic Performance:"),
                ...student.academicRecords.first.assessments
                    .map((exam) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('📄 ${exam.type} (marks/grade'),
                            ...exam.subjects.map((sub) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(sub.subjectName)),
                                      Text(
                                        '${sub.score} ${sub.grade}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        )),
                ListTile()
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Student student) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete the record for ${student.name} (${student.rollNumber})? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Student ${student.name} deleted.')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows a full-featured Material 3 dialog for adding or editing a student.
  void _showAddEditStudentDialog(BuildContext context,
      {Student? existingStudent}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Student (Dialog)"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  // controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  // controller: rollController,
                  decoration: const InputDecoration(labelText: 'Roll Number'),
                ),
                Row(
                  children: [
                    const Text("Fee Paid"),
                    Switch(
                      value: true,
                      onChanged: (val) {
                        setState(() {
                          // feeStatus = val;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    // setState(() {
                    //   student.name = nameController.text;
                    //   student.roll = rollController.text;
                    //   student.feePaid = feeStatus;
                    // });
                    Navigator.pop(context);
                  },
                  child: const Text("Save")),
            ],
          );
        });
  }
}

class CompactStatusDropdown extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onChanged;

  const CompactStatusDropdown({
    super.key,
    required this.selectedStatus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButton<String>(
        value: selectedStatus,
        underline: const SizedBox(), // removes the default underline
        isDense: true, // compact vertical height
        style: TextStyle(fontSize: 13, color: colorScheme.onSurface),
        dropdownColor: colorScheme.surface,
        items: const [
          DropdownMenuItem(value: 'All', child: Text('All')),
          DropdownMenuItem(value: 'Active', child: Text('Active')),
          DropdownMenuItem(value: 'Suspended', child: Text('Suspended')),
        ],
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}
