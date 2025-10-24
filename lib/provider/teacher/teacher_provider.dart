import 'package:flutter/material.dart';
import 'package:ias/screens/teachers/data/mock_data.dart'; // Using the new model file

class TeacherManagement extends ChangeNotifier {
  List<Teacher> _teachers = mockTeacherList; // Source of truth
  String _searchQuery = '';
  String? _selectedDepartment;
  String? _selectedExperienceRange;
  String? _selectedEmploymentType;
  String? _selectedStatus;

  // --- Getters for Filters ---
  String get searchQuery => _searchQuery;
  String? get selectedDepartment => _selectedDepartment;
  String? get selectedExperienceRange => _selectedExperienceRange;
  String? get selectedEmploymentType => _selectedEmploymentType;
  String? get selectedStatus => _selectedStatus;

  // --- Derived State (Filtered List) ---

  List<Teacher> get filteredTeachers {
    // Start with the full list
    List<Teacher> list = _teachers;

    // 1. Apply Search Filter
    if (_searchQuery.isNotEmpty) {
      list = list.where((t) {
        final query = _searchQuery.toLowerCase();
        return t.name.toLowerCase().contains(query) ||
            t.id.toLowerCase().contains(query) ||
            t.subject.toLowerCase().contains(query);
      }).toList();
    }

    // 2. Apply Department Filter
    if (_selectedDepartment != null &&
        _selectedDepartment != 'All Departments') {
      list = list.where((t) => t.department == _selectedDepartment).toList();
    }

    // 3. Apply Experience Filter
    if (_selectedExperienceRange != null) {
      list = list.where((t) {
        final exp = t.yearsOfExperience;
        if (_selectedExperienceRange == '0–5 yrs') {
          return exp >= 0 && exp <= 5;
        } else if (_selectedExperienceRange == '6–10 yrs') {
          return exp >= 6 && exp <= 10;
        } else if (_selectedExperienceRange == '10+ yrs') {
          return exp > 10;
        }
        return true; // Should not happen
      }).toList();
    }

    // 4. Apply Employment Type Filter
    if (_selectedEmploymentType != null) {
      list = list
          .where((t) => t.employmentType == _selectedEmploymentType)
          .toList();
    }

    // 5. Apply Status Filter
    if (_selectedStatus != null && _selectedStatus != 'All Statuses') {
      list = list.where((t) => t.status == _selectedStatus).toList();
    }

    return list;
  }

  // --- Analytics Getters ---
  double get averageExperience {
    if (_teachers.isEmpty) return 0.0;
    final totalExp =
        _teachers.fold<int>(0, (sum, t) => sum + t.yearsOfExperience);
    return totalExp / _teachers.length;
  }

  int get onLeaveCount => _teachers.where((t) => t.status == 'On Leave').length;

  int get activeTeacherCount =>
      _teachers.where((t) => t.status == 'Active').length;

  int get departmentCount => {for (var t in _teachers) t.department}.length;

  // --- Setters and Mutators (Triggers notifyListeners) ---

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setDepartmentFilter(String? department) {
    _selectedDepartment = department;
    notifyListeners();
  }

  void setExperienceFilter(String? range) {
    _selectedExperienceRange = range;
    notifyListeners();
  }

  void setEmploymentTypeFilter(String? type) {
    _selectedEmploymentType = type;
    notifyListeners();
  }

  void setStatusFilter(String? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void addOrUpdateTeacher(Teacher newTeacher) {
    final index = _teachers.indexWhere((t) => t.id == newTeacher.id);
    if (index >= 0) {
      // Update existing teacher
      _teachers[index] = newTeacher;
    } else {
      // Add new teacher
      _teachers.add(newTeacher);
    }
    notifyListeners();
  }

  void deleteTeacher(String id) {
    _teachers.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
