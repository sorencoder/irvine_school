// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ias/cubit/student_cubit/student_cubit.dart';
// import 'package:ias/cubit/student_cubit/student_states.dart';
// import 'package:ias/provider/students/student_provider.dart' as student_filter;

// /// This widget wraps the main application and uses BlocListener to synchronize
// /// state changes from StudentCubit (Source of Truth) into StudentFilterProvider
// /// (View Model/Filter Layer).
// class TopLevelSyncWrapper extends StatelessWidget {
//   final Widget child;

//   const TopLevelSyncWrapper({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     // We listen to the Cubit's state here.
//     return BlocListener<StudentCubit, StudentState>(
//       // Listen for all state changes (including initial load and subsequent CRUD)
//       listener: (context, state) {
//         // 1. Check if the state is successfully loaded or modified
//         if (state.errorMessage == null && state.students.isNotEmpty) {
//           try {
//             // 2. Safely read the StudentFilterProvider
//             final filterProvider =
//                 context.read<student_filter.StudentFilterProvider>();

//             // 3. Update the Provider's master list
//             filterProvider.setMasterStudents(state.students);

//             debugPrint(
//                 '✅ BlocListener synchronized ${state.students.length} students to Provider.');
//           } catch (e) {
//             // This catch block handles the original dependency error if it somehow
//             // still occurs, preventing a crash.
//             debugPrint(
//                 '❌ Sync Error in BlocListener: Failed to read Provider. $e');
//           }
//         }
//       },
//       child: child,
//     );
//   }
// }
