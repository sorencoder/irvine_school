import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ias/provider/students/student_management.dart';
import 'package:ias/provider/teacher/teacher_provider.dart';
import 'package:ias/screens/admin/home/admin_dashboard.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => StudentManagement()),
    ChangeNotifierProvider(create: (_) => TeacherManagement())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SchoolAdminDashboard(),
    );
  }
}
