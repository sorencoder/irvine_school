import 'package:flutter/material.dart';
import 'package:ias/utils/data_model.dart';

class StudentManagement with ChangeNotifier {
  // Private state variables
  String _searchQuery = '';
  String? _selectedClassFilter;
  bool _showFeeDue = false;

  // Getters
  String get searchQuery => _searchQuery;
  String? get selectedClassFilter => _selectedClassFilter;
  bool get showFeeDue => _showFeeDue;

  // --- Computed Filtered List ---
  List<StudentProfile> get filteredStudents {
    List<StudentProfile> students = mockStudentList;

    // 1️⃣ Filter by Fee Status
    if (_showFeeDue) {
      students = students.where((s) => !s.feeStatus).toList();
    }

    // 2️⃣ Filter by Class
    if (_selectedClassFilter != null) {
      students =
          students.where((s) => s.className == _selectedClassFilter).toList();
    }

    // 3️⃣ Filter by Search Query
    if (_searchQuery.isNotEmpty) {
      students = students
          .where((s) =>
              s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.rollNumber.toString().contains(_searchQuery))
          .toList();
    }

    return students;
  }

  // --- State Update Methods (these call notifyListeners) ---
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setClassFilter(String? className) {
    _selectedClassFilter = className;
    notifyListeners();
  }

  void toggleFeeDueFilter(bool value) {
    _showFeeDue = value;
    notifyListeners();
  }

  // Optional: clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedClassFilter = null;
    _showFeeDue = false;
    notifyListeners();
  }
}

// // Get unique class names for the dropdown filter
// List<String> get _uniqueClasses {
//   final classes = mockStudentList.map((s) => s.className).toSet().toList()
//     ..sort();
//   return ['All Classes', ...classes];
// }
