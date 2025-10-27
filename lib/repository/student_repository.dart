import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ias/data/models/student_data_model.dart';

class StudentRepository {
  final CollectionReference _studentsCollection =
      FirebaseFirestore.instance.collection('students');

  DocumentSnapshot? _lastDocument;
  bool hasMore = true;

  Future<List<Student>> fetchStudents(
      {int limit = 20, bool reset = false}) async {
    try {
      if (reset) {
        _lastDocument = null;
        hasMore = true;
      }

      if (!hasMore) return [];

      Query query = _studentsCollection.orderBy('rollNumber').limit(limit);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      } else {
        hasMore = false;
      }

      final students = snapshot.docs
          .map((doc) => Student.fromMap({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();

      if (snapshot.docs.length < limit) hasMore = false;

      return students;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addStudent(Student student) async {
    await _studentsCollection.add(student.toMap());
  }

  Future<void> updateStudent(String id, Student student) async {
    await _studentsCollection.doc(id).update(student.toMap());
  }

  Future<void> deleteStudent(String id) async {
    await _studentsCollection.doc(id).delete();
  }
}
