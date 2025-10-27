import 'package:flutter/material.dart';
import 'package:ias/data/models/student_data_model.dart'; // adjust import to your structure

class StudentFilterProvider extends ChangeNotifier {
  // 🔹 All data (from Firestore or Cubit)
  List<Student> _allStudents = [];

  // 🔹 Filtered data for UI
  List<Student> _filteredStudents = [];
  List<Student> get students => _filteredStudents;
  List<Student> get allStudents => _allStudents;

  // 🔹 Active filters
  // String _selectedClass = 'All Classes';
  String _selectedFeeStatus = 'All';
  String _selectedStatus = 'All'; // Active / Suspended / All
  String _searchQuery = '';

  // 🔹 Getters
  // String get selectedClass => _selectedClass;
  String get selectedFeeStatus => _selectedFeeStatus;
  String get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;

  // ====================================================
  // 🔹 Update full student list (called from Cubit)
  // ====================================================
  void updateStudents(List<Student> newList) {
    _allStudents = newList;
    _applyFilters();
  }

  // ====================================================
  // 🔹 Private filtering logic (core)
  // ====================================================
  void _applyFilters() {
    List<Student> temp = List.from(_allStudents);

    // // 1️⃣ Filter by class
    // if (_selectedClass != 'All Classes') {
    //   temp = temp.where((s) => s.className == _selectedClass).toList();
    // }

    // 2️⃣ Filter by fee status
    if (_selectedFeeStatus != 'All') {
      temp = temp.where((s) => s.feeStatus == _selectedFeeStatus).toList();
    }

    // 3️⃣ Filter by student status
    if (_selectedStatus != 'All') {
      temp = temp.where((s) => s.status == _selectedStatus).toList();
    }

    // 4️⃣ Search filter (by name or roll number)
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      temp = temp.where((s) {
        final matchesName = s.name.toLowerCase().contains(query);
        final matchesRoll = s.rollNumber.toString().contains(query);
        return matchesName || matchesRoll;
      }).toList();
    }

    _filteredStudents = temp;
    notifyListeners();
  }

  // ====================================================
  // 🔹 Filter control methods
  // ====================================================
  // void changeClass(String value) {
  //   _selectedClass = value;
  //   _applyFilters();
  // }

  void changeFeeStatus(String value) {
    _selectedFeeStatus = value;
    _applyFilters();
  }

  void changeStatus(String value) {
    _selectedStatus = value;
    _applyFilters();
  }

  void updateSearchQuery(String value) {
    _searchQuery = value;
    _applyFilters();
  }

  // ====================================================
  // 🔹 Utility
  // ====================================================
  void clearAllFilters() {
    // _selectedClass = 'All Classes';
    _selectedFeeStatus = 'All';
    _selectedStatus = 'All';
    _searchQuery = '';
    _applyFilters();
  }
}
