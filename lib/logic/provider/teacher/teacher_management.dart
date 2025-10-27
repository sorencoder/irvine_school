import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/data/models/teacher_data_model.dart';

class TeacherProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Teacher> _teachers = [];
  bool _isLoading = false;

  List<Teacher> get teachers => _teachers;
  bool get isLoading => _isLoading;

  // ---------------- READ ----------------
  Future<void> fetchTeachers() async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore.collection('teachers').get();
      _teachers = snapshot.docs
          .map((doc) => Teacher.fromJson({
                ...doc.data(),
                '_id': doc.id,
              }))
          .toList();
    } catch (e) {
      debugPrint("Error fetching teachers: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- CREATE ----------------
  Future<void> addTeacher(Teacher teacher) async {
    try {
      final docRef =
          await _firestore.collection('teachers').add(teacher.toJson());
      _teachers.add(teacher.copyWith(id: docRef.id));
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding teacher: $e");
    }
  }

  // ---------------- UPDATE ----------------
  Future<void> updateTeacher(String id, Teacher updatedTeacher) async {
    try {
      await _firestore
          .collection('teachers')
          .doc(id)
          .update(updatedTeacher.toJson());
      final index = _teachers.indexWhere((t) => t.id == id);
      if (index != -1) {
        _teachers[index] = updatedTeacher.copyWith(id: id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error updating teacher: $e");
    }
  }

  // ---------------- DELETE ----------------
  Future<void> deleteTeacher(String id) async {
    try {
      await _firestore.collection('teachers').doc(id).delete();
      _teachers.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting teacher: $e");
    }
  }

  // 🔍 Filter by department
  List<Teacher> filterByDepartment(String department) {
    if (department.isEmpty || department == 'All Departments') return _teachers;
    return _teachers.where((t) => t.department == department).toList();
  }

  // 🔤 Filter by status
  List<Teacher> filterByStatus(String status) {
    if (status.isEmpty || status == 'All Statuses') return _teachers;
    return _teachers.where((t) => t.status == status).toList();
  }

  // 🔍 Filter by name query (partial match)
  List<Teacher> filterByName(String query) {
    if (query.isEmpty) return _teachers;
    return _teachers
        .where((t) => t.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // 🔤 Filter by subject
  List<Teacher> filterBySubject(String subject) {
    if (subject.isEmpty || subject == 'All Subjects') return _teachers;
    return _teachers.where((t) => t.subject == subject).toList();
  }

  // 🔄 Combine multiple filters dynamically
  List<Teacher> filterTeachers({
    String? department,
    String? status,
    String? nameQuery,
    String? subject,
  }) {
    Iterable<Teacher> filtered = _teachers;

    if (department != null &&
        department.isNotEmpty &&
        department != 'All Departments') {
      filtered = filtered.where((t) => t.department == department);
    }

    if (status != null && status.isNotEmpty && status != 'All Statuses') {
      filtered = filtered.where((t) => t.status == status);
    }

    if (nameQuery != null && nameQuery.isNotEmpty) {
      filtered = filtered
          .where((t) => t.name.toLowerCase().contains(nameQuery.toLowerCase()));
    }

    if (subject != null && subject.isNotEmpty && subject != 'All Subjects') {
      filtered = filtered.where((t) => t.subject == subject);
    }

    return filtered.toList();
  }

  // 🧹 Clear filters (optional)
  void clearFilters() {
    notifyListeners();
  }
}
