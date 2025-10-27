import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ias/logic/cubit/student_cubit/student_cubit.dart';
import 'package:ias/logic/provider/students/student_filters_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// 🧩 Providers & Cubits
import 'package:ias/logic/provider/teacher/teacher_management.dart';
import 'package:ias/repository/student_repository.dart';

// 🖥️ Screens
import 'package:ias/ui/screens/admin/manageStudent/student_management_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase safely
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Initialize repository before running app
  final studentRepository = StudentRepository();

  runApp(MyApp(studentRepository: studentRepository));
}

class MyApp extends StatelessWidget {
  final StudentRepository studentRepository;
  const MyApp({super.key, required this.studentRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 🧠 Cubit for business logic
        BlocProvider(
          create: (_) => StudentCubit(studentRepository),
        ),
      ],
      child: MultiProvider(
        providers: [
          // 👨‍🏫 Teacher management provider
          ChangeNotifierProvider(create: (_) => TeacherProvider()),

          // 🎓 Student UI state provider
          ChangeNotifierProvider(create: (_) => StudentFilterProvider()),
        ],
        child: MaterialApp(
          title: 'Institute Admin System',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.grey[50],
          ),
          home: const StudentManagementScreen(),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'dart:math';
// import 'package:ias/firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await uploadMockStudents(); // ✅ Uploads mock data once
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         body: Center(child: Text('✅ Mock students uploaded to Firestore')),
//       ),
//     );
//   }
// }

// /// Uploads 50 mock student documents to Firestore
// Future<void> uploadMockStudents() async {
//   final firestore = FirebaseFirestore.instance;
//   final List<Map<String, dynamic>> mockStudents = generateMockStudents(50);

//   print('🚀 Uploading ${mockStudents.length} mock students...');

//   for (final student in mockStudents) {
//     await firestore.collection('students').add(student);
//   }

//   print('✅ Successfully uploaded ${mockStudents.length} students');
// }

// /// Generates mock student data
// List<Map<String, dynamic>> generateMockStudents(int count) {
//   final random = Random();
//   final classNames = ['6', '7', '8', '9', '10', '11', '12'];
//   final sections = ['A', 'B', 'C'];
//   final subjects = ['Math', 'Science', 'English', 'History', 'Computer'];

//   return List.generate(count, (index) {
//     final className = classNames[index % classNames.length];
//     final section = sections[index % sections.length];

//     final attendance = {
//       'presentDays': 180 - (index % 15),
//       'absentDays': index % 15,
//     };

//     final subjectPerformances = subjects.map((subj) {
//       final score = 60 + (index * 3 + subj.length) % 40;
//       return {
//         'subjectName': subj,
//         'score': score.toDouble(),
//         'classAverage': 70 + (index % 10),
//         'grade': score >= 90
//             ? 'A+'
//             : score >= 80
//                 ? 'A'
//                 : score >= 70
//                     ? 'B'
//                     : score >= 60
//                         ? 'C'
//                         : 'D',
//       };
//     }).toList();

//     final assessments = [
//       {
//         'type': 'Final Exam',
//         'subjects': subjectPerformances,
//       },
//     ];

//     final academicRecord = [
//       {
//         'year': '2024-2025',
//         'promoted': (index % 5 != 0), // Some not promoted
//         'attendance': attendance,
//         'assessments': assessments,
//       }
//     ];

//     return {
//       'name': 'Student ${index + 1}',
//       'rollNumber': 1000 + index,
//       'className': className,
//       'section': section,
//       'aadharNumber': '9999888877${(1000 + index).toString().substring(2)}',
//       'parentContact': '+91${9000000000 + index}',
//       'feeStatus': (index % 4 == 0) ? 'Pending' : 'Paid',
//       'status': (index % 7 == 0) ? 'Suspended' : 'Active',
//       'academicRecords': academicRecord,
//     };
//   });
// }
