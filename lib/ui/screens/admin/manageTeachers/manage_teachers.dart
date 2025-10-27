// import 'package:flutter/material.dart';
// import 'package:ias/models/teacher_data_model.dart';
// import 'package:ias/provider/teacher/teacher_management.dart';
// import 'package:provider/provider.dart';
// // Note: Assuming these are the correct paths in your project

// class TeacherManagementScreen extends StatelessWidget {
//   const TeacherManagementScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         // Consumer listens to TeacherManagement provider
//         child: Consumer<TeacherProvider>(
//           builder: (context, teacherProvider, _) {
//             final teachers = teacherProvider.teachers;

//             // Dynamic filter options
//             final uniqueDepartments = [
//               'All Departments',
//               ...{for (var t in teachers) t.department}.toList()
//             ];
//             // final experienceRanges = ['0–5 yrs', '6–10 yrs', '10+ yrs'];
//             // final employmentTypes = ['Full-Time', 'Part-Time', 'Contract'];
//             final statuses = ['All Statuses', 'Active', 'On Leave', 'Resigned'];

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // 🧱 Header & Quick Actions
//                 _buildHeader(context, colorScheme, teachers),
//                 const SizedBox(height: 24),

//                 // 📊 Analytics / Insights Cards
//                 _buildAnalyticsCards(context, colorScheme, teachers),
//                 const SizedBox(height: 32),

//                 // 🔍 Filters & Search Controls
//                 _buildFilterControls(
//                     context,
//                     teacherProvider,
//                     uniqueDepartments,
//                     statuses),

//                 const SizedBox(height: 26),

//                 // 🧾 Teacher Data Table (Main Content)
//                 _buildDataTable(context, colorScheme, teachers),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // --- Widget Builders ---

//   Widget _buildHeader(
//       BuildContext context, ColorScheme colorScheme, List teachers) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Teacher Management 🎓',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.w800,
//                 color: colorScheme.onSurface,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '${teachers.length} Active Teachers',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: colorScheme.secondary,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),

//         // Quick Buttons
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Export Data Button
//             OutlinedButton.icon(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Exporting Teachers Data...')),
//                 );
//               },
//               icon: const Icon(Icons.download_outlined),
//               label: const Text('Export'),
//               style: OutlinedButton.styleFrom(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//             const SizedBox(width: 12),
//             // Add New Teacher Button
//             ElevatedButton.icon(
//               onPressed: () => _showAddEditTeacherDialog(context, teachers),
//               icon: const Icon(Icons.add),
//               label: const Text('Add Teacher'),
//               style: ElevatedButton.styleFrom(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAnalyticsCards(
//       BuildContext context, ColorScheme colorScheme, List teachers) {
//     final cardData = [
//       {
//         'title': 'Total Teachers',
//         'value': teachers.length.toString(),
//         'icon': Icons.people_alt,
//         'color': colorScheme.primary
//       },
//       {
//         'title': 'On Leave',
//         'value': teachers.onLeaveCount.toString(),
//         'icon': Icons.time_to_leave,
//         'color': colorScheme.error
//       },
//       {
//         'title': 'Departments',
//         'value': teachers.department.toString(),
//         'icon': Icons.business,
//         'color': colorScheme.secondary
//       },
//     ];

//     return Wrap(
//       spacing: 16.0,
//       runSpacing: 16.0,
//       children: cardData
//           .map((data) => SizedBox(
//                 width: 250, // Fixed width for desktop layout
//                 child: Card(
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(data['title'] as String,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: colorScheme.onSurfaceVariant,
//                                 )),
//                             Icon(data['icon'] as IconData,
//                                 color: data['color'] as Color, size: 24),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Text(
//                           data['value'] as String,
//                           style: TextStyle(
//                             fontSize: 32,
//                             fontWeight: FontWeight.w900,
//                             color: colorScheme.onSurface,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ))
//           .toList(),
//     );
//   }

//   Widget _buildFilterControls(
//       BuildContext context,
//       TeacherProvider filterprovider,
//       List<String> departments,
//       List<String> statuses) {
//     return Wrap(
//       spacing: 16.0,
//       runSpacing: 16.0,
//       alignment: WrapAlignment.start,
//       children: [
//         // Search Field
//         SizedBox(
//           width: 310,
//           child: TextField(
//             decoration: InputDecoration(
//               labelText: 'Search by Name, ID, or Subject',
//               prefixIcon: const Icon(Icons.search),
//               border:
//                   OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//               isDense: true,
//             ),
//             onChanged: (value) => filterprovider.setSearchQuery(value),
//           ),
//         ),

//         // Department Filter Dropdown
//         SizedBox(
//           width: 200,
//           child: DropdownButtonFormField<String>(
//             decoration: _dropdownDecoration(labelText: 'Department/Subject'),
//             value: filterprovider.selectedDepartment ?? 'All Departments',
//             onChanged: (String? newValue) {
//               filterprovider.filterByDepartment(
//                   newValue == 'All Departments' ? null : newValue);
//             },
//             items: departments.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(value: value, child: Text(value));
//             }).toList(),
//           ),
//         ),

//         // Status Filter Dropdown
//         SizedBox(
//           width: 150,
//           child: DropdownButtonFormField<String>(
//             decoration: _dropdownDecoration(labelText: 'Status'),
//             value: filterprovider.selectedStatus ?? 'All Statuses',
//             onChanged: (String? newValue) {
//               filterprovider.setStatusFilter(
//                   newValue == 'All Statuses' ? null : newValue);
//             },
//             items: statuses.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(value: value, child: Text(value));
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   InputDecoration _dropdownDecoration({required String labelText}) {
//     return InputDecoration(
//       labelText: labelText,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       isDense: true,
//     );
//   }

//   Widget _buildDataTable(
//     BuildContext context,
//     ColorScheme colorScheme,
//     List teachers,
//   ) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           final isCompact = constraints.maxWidth < 800;
//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: SizedBox(
//               width: constraints.maxWidth < 900 ? 900 : constraints.maxWidth,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: DataTable(
//                   columnSpacing: 30,
//                   horizontalMargin: 15,
//                   headingRowColor: MaterialStateProperty.resolveWith(
//                     (states) => colorScheme.surfaceVariant,
//                   ),
//                   columns: const [
//                     DataColumn(label: Text('ID')),
//                     DataColumn(label: Text('NAME')),
//                     DataColumn(label: Text('SUBJECT / DEPT.')),
//                     DataColumn(label: Text('EXPERIENCE (YRS)'), numeric: true),
//                     DataColumn(label: Text('RATING'), numeric: true),
//                     DataColumn(label: Text('STATUS')),
//                     DataColumn(label: Text('ACTIONS')),
//                   ],
//                   rows: teachers.map((teacher) {
//                     return DataRow(
//                       cells: [
//                         DataCell(Text(teacher.id)),
//                         DataCell(Text(teacher.name,
//                             style:
//                                 const TextStyle(fontWeight: FontWeight.bold))),
//                         DataCell(
//                             Text('${teacher.subject} / ${teacher.department}')),
//                         DataCell(_buildStatusChip(colorScheme, teacher.status)),
//                         DataCell(Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.remove_red_eye_outlined,
//                                   size: 20),
//                               onPressed: () =>
//                                   _showViewTeacherDialog(context, teacher),
//                               tooltip: 'View Profile',
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.edit_outlined, size: 20),
//                               onPressed: () => _showAddEditTeacherDialog(
//                                   context, teacher,
//                                   existingTeacher: teacher),
//                               tooltip: 'Edit Info',
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.delete_outline,
//                                   size: 20, color: colorScheme.error),
//                               onPressed: () => _showDeleteConfirmationDialog(
//                                   context, teacher),
//                               tooltip: 'Delete Teacher',
//                             ),
//                           ],
//                         )),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatusChip(ColorScheme colorScheme, String status) {
//     Color chipColor;
//     Color textColor = Colors.white;

//     switch (status) {
//       case 'Active':
//         chipColor = Colors.green.shade600;
//         break;
//       case 'On Leave':
//         chipColor = Colors.orange.shade700;
//         break;
//       case 'Resigned':
//         chipColor = Colors.red.shade700;
//         break;
//       default:
//         chipColor = colorScheme.surfaceVariant;
//         textColor = colorScheme.onSurface;
//     }

//     return Chip(
//       label: Text(status),
//       backgroundColor: chipColor,
//       labelStyle: TextStyle(
//           color: textColor, fontWeight: FontWeight.bold, fontSize: 10),
//       visualDensity: VisualDensity.compact,
//     );
//   }

//   // --- Dialogs and Modals ---

//   void _showViewTeacherDialog(BuildContext context, Teacher teacher) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('${teacher.name}\'s Profile'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('ID: ${teacher.id}'),
//                 Text('Department: ${teacher.department} (${teacher.subject})'),
//                 Text('Status: ${teacher.status}'),
//                 Text('Contact: ${teacher.contactInfo}'),
//                 Text('Salary: ₹${teacher.salary.toStringAsFixed(0)}'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Close'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showDeleteConfirmationDialog(BuildContext context, Teacher teacher) {
//     final colorScheme = Theme.of(context).colorScheme;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Deletion'),
//           content: Text(
//               'Are you sure you want to delete the record for ${teacher.name} (${teacher.id})? This action cannot be undone.'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             FilledButton(
//               style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
//               child:
//                   const Text('Delete', style: TextStyle(color: Colors.white)),
//               onPressed: () {
//                 Provider.of<TeacherProvider>(context).deleteTeacher(teacher.id);

//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Teacher ${teacher.name} deleted.')),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showAddEditTeacherDialog(BuildContext context, List teacher,
//       {Teacher? existingTeacher}) {
//     final bool isEditing = existingTeacher != null;
//     final formKey = GlobalKey<FormState>();

//     // Initial values for the form
//     String name = existingTeacher?.name ?? '';
//     String id = existingTeacher?.id ??
//         'TCH${(teacher.id.length + 1).toString().padLeft(4, '0')}';
//     String subject = existingTeacher?.subject ?? '';
//     String department = existingTeacher?.department ?? 'Science';
//     String status = existingTeacher?.status ?? 'Active';
//     String contact = existingTeacher?.contactInfo ?? '';
//     double salary = existingTeacher?.salary ?? 0.0;

//     final departments = ['Science', 'Mathematics', 'English', 'Humanities'];
//     // final employmentTypes = ['Full-Time', 'Part-Time', 'Contract'];
//     final statuses = ['Active', 'On Leave', 'Resigned'];

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(isEditing
//               ? 'Edit Teacher: ${existingTeacher.name}'
//               : 'Add New Teacher'),
//           content: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     initialValue: name,
//                     decoration: const InputDecoration(labelText: 'Name'),
//                     onSaved: (v) => name = v!,
//                     validator: (v) => v!.isEmpty ? 'Name is required' : null,
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     initialValue: id,
//                     readOnly: isEditing,
//                     decoration: const InputDecoration(
//                         labelText: 'Employee ID (Read Only)'),
//                     onSaved: (v) => id = v!,
//                   ),
//                   const SizedBox(height: 16),
//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(labelText: 'Department'),
//                     value: department,
//                     items: departments
//                         .map((d) => DropdownMenuItem(value: d, child: Text(d)))
//                         .toList(),
//                     onChanged: (v) => department = v!,
//                     onSaved: (v) => department = v!,
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     initialValue: subject,
//                     decoration: const InputDecoration(labelText: 'Subject'),
//                     onSaved: (v) => subject = v!,
//                     validator: (v) => v!.isEmpty ? 'Subject is required' : null,
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     initialValue: salary.toStringAsFixed(0),
//                     decoration: const InputDecoration(labelText: 'Salary (₹)'),
//                     keyboardType: TextInputType.number,
//                     onSaved: (v) => salary = double.tryParse(v!) ?? 0.0,
//                     validator: (v) =>
//                         double.tryParse(v!) == null ? 'Must be a number' : null,
//                   ),
//                   const SizedBox(height: 16),
//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(labelText: 'Status'),
//                     value: status,
//                     items: statuses
//                         .map((s) => DropdownMenuItem(value: s, child: Text(s)))
//                         .toList(),
//                     onChanged: (v) => status = v!,
//                     onSaved: (v) => status = v!,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             FilledButton(
//               child: Text(isEditing ? 'Save Changes' : 'Add Teacher'),
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   formKey.currentState!.save();

//                   final newTeacher = Teacher(
//                     id: id,
//                     name: name,
//                     subject: subject,
//                     department: department,
//                     status: status,
//                     contactInfo:
//                         contact, // Note: Contact field not added to form for brevity
//                     salary: salary,
//                   );

//                   Provider.of<TeacherProvider>(context).addTeacher(newTeacher);
//                   Navigator.of(context).pop();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text(
//                             '${newTeacher.name} ${isEditing ? 'updated' : 'added'} successfully!')),
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
