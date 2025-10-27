import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ias/logic/cubit/student_cubit/student_states.dart';
import 'package:ias/data/models/student_data_model.dart';
import 'package:ias/repository/student_repository.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentRepository _repository;
  List<Student> _students = [];

  StudentCubit(this._repository) : super(StudentInitial());

  /// 🔹 Load students (with pagination)
  Future<void> loadStudents({bool reset = false}) async {
    if (state is StudentLoading) return;

    emit(StudentLoading());

    try {
      final newStudents = await _repository.fetchStudents(
        limit: 20,
        reset: reset,
      );

      if (reset) {
        _students = newStudents;
      } else {
        _students.addAll(newStudents);
      }

      emit(StudentLoaded(_students, _repository.hasMore));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  /// 🟢 Add a new student
  Future<void> addStudent(Student student) async {
    try {
      await _repository.addStudent(student);
      await loadStudents(reset: true); // refresh from start
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  /// 🟡 Update a student
  Future<void> updateStudent(String id, Student student) async {
    try {
      await _repository.updateStudent(id, student);
      await loadStudents(reset: true);
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  /// 🔴 Delete a student
  Future<void> deleteStudent(String id) async {
    try {
      await _repository.deleteStudent(id);
      await loadStudents(reset: true);
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }
}
