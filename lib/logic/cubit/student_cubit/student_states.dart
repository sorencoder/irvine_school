import 'package:ias/data/models/student_data_model.dart';

abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> students;
  final bool hasMore;

  StudentLoaded(this.students, this.hasMore);
}

class StudentError extends StudentState {
  final String message;
  StudentError(this.message);
}
