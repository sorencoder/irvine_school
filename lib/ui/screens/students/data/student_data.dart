// Extended Mock Data Classes
class SubjectMark {
  final String subject;
  final int score;
  final int maxMarks;
  SubjectMark(this.subject, this.score, this.maxMarks);
}

class YearPerformance {
  final String year;
  final List<SubjectMark> subjectMarks;
  YearPerformance(this.year, this.subjectMarks);

  double get averageScore {
    if (subjectMarks.isEmpty) return 0.0;
    return subjectMarks.map((m) => m.score).reduce((a, b) => a + b) /
        subjectMarks.length;
  }
}

class StudentData {
  final String name;
  final String grade;
  final String rollNumber;
  final String aadharNumber;
  final String studentId;
  final double attendancePercentage;
  final bool feeStatus;

  final String nextFeeDueDate;
  final String nextClassTime;
  final List<SubjectMark> currentYearMarks; // For the list display
  final List<YearPerformance> historicalPerformance; // For chart comparison

  StudentData()
      : name = 'Aarav Sharma',
        grade = '10th A',
        rollNumber = '10A-23',
        studentId = 'IASG2023001',
        aadharNumber = '796747373422',
        attendancePercentage = 88.5,
        feeStatus = true,
        nextFeeDueDate = 'Nov 30, 2025',
        nextClassTime = 'Maths (9:30 AM)',
        currentYearMarks = [
          SubjectMark('Mathematics', 92, 100),
          SubjectMark('Science', 85, 100),
          SubjectMark('English', 78, 100),
          SubjectMark('Computer', 95, 100),
        ],
        historicalPerformance = [
          YearPerformance('2024', [
            SubjectMark('Mathematics', 88, 100),
            SubjectMark('Science', 80, 100),
            SubjectMark('English', 75, 100),
            SubjectMark('Computer', 90, 100),
          ]),
          YearPerformance('2025', [
            // Current year data for comparison
            SubjectMark('Mathematics', 92, 100),
            SubjectMark('Science', 85, 100),
            SubjectMark('English', 78, 100),
            SubjectMark('Computer', 95, 100),
          ]),
        ];
}
