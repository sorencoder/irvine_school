// Root model representing a student
class Student {
  final String id; // MongoDB _id
  final String name;
  final int rollNumber;
  final String className;
  final String section;
  final String aadharNumber;
  final String parentContact;
  final String feeStatus;
  final String status;
  final List<AcademicYearRecord> academicRecords;

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.className,
    required this.section,
    required this.aadharNumber,
    required this.parentContact,
    required this.feeStatus,
    required this.status,
    required this.academicRecords,
  });

  /// Converts this Student object into a Map String, dynamic for database storage.
  Map<String, dynamic> toMap() => {
        // NOTE: The 'id' (Firestore Document ID) is usually omitted here
        // as it's set externally when writing the document.
        'name': name,
        'rollNumber': rollNumber,
        'className': className,
        'section': section,
        'aadharNumber': aadharNumber,
        'parentContact': parentContact,
        'feeStatus': feeStatus,
        'status': status,
        'academicRecords': academicRecords.map((e) => e.toMap()).toList(),
      };
// Creates a Student object from a Map<String, dynamic> retrieved from the database.
  factory Student.fromMap(Map<String, dynamic> map) => Student(
        // Safely extract the document ID (passed as 'id' or '_id' during Cubit mapping).
        id: map['id'] as String? ?? map['_id'] as String? ?? '',
        name: map['name'] as String? ?? 'N/A',
        // Safely cast numbers (Firestore returns numbers as 'num')
        rollNumber: (map['rollNumber'] as num? ?? 0).toInt(),
        className: map['className'] as String? ?? 'N/A',
        section: map['section'] as String? ?? 'N/A',
        aadharNumber: map['aadharNumber'] as String? ?? '',
        parentContact: map['parentContact'] as String? ?? '',
        feeStatus: map['feeStatus'] as String? ?? 'Pending',
        status: map['status'] as String? ?? 'Active',

        // Safely handle list parsing, calling fromMap on nested objects
        academicRecords: (map['academicRecords'] as List? ?? [])
            .map((e) => AcademicYearRecord.fromMap(e as Map<String, dynamic>))
            .toList(),
      );
  // Alias for factory constructor
  factory Student.fromJson(Map<String, dynamic> json) => Student.fromMap(json);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'rollNumber': rollNumber,
        'className': className,
        'section': section,
        'aadharNumber': aadharNumber,
        'parentContact': parentContact,
        'feeStatus': feeStatus,
        'status': status,
        'academicRecords': academicRecords.map((e) => e.toJson()).toList(),
      };

  // factory Student.fromJson(Map<String, dynamic> json) => Student(
  //       id: json['_id'] as String? ??
  //           '', // Safe casting and default for MongoDB ID
  //       name: json['name'] as String? ?? 'N/A', // Null check and default
  //       // 🛑 CRITICAL FIX: Ensure 'rollNumber' is handled safely and converted to int
  //       rollNumber: (json['rollNumber'] as num? ?? 0).toInt(),
  //       className: json['className'] as String? ?? 'N/A',
  //       section: json['section'] as String? ?? 'N/A',
  //       aadharNumber: json['aadharNumber'] as String? ?? '',
  //       parentContact: json['parentContact'] as String? ?? '',
  //       feeStatus: json['feeStatus'] as String? ?? 'Pending',
  //       status: json['status'] as String? ?? 'Active',

  //       // 🛑 CRITICAL FIX: Ensure 'academicRecords' is a List before mapping
  //       academicRecords: (json['academicRecords'] as List? ?? [])
  //           .map((e) => AcademicYearRecord.fromJson(e as Map<String, dynamic>))
  //           .toList(),
  //     );

  Student copyWith({
    String? id,
    String? name,
    int? rollNumber,
    String? className,
    String? section,
    String? aadharNumber,
    String? parentContact,
    String? feeStatus,
    String? status,
    List<AcademicYearRecord>? academicRecords,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      rollNumber: rollNumber ?? this.rollNumber,
      className: className ?? this.className,
      section: section ?? this.section,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      parentContact: parentContact ?? this.parentContact,
      feeStatus: feeStatus ?? this.feeStatus,
      status: status ?? this.status,
      academicRecords: academicRecords ?? this.academicRecords,
    );
  }
}

class AcademicYearRecord {
  final String year;
  final bool promoted;
  final Attendance attendance;
  final List<Assessment> assessments;

  AcademicYearRecord({
    required this.year,
    required this.promoted,
    required this.attendance,
    required this.assessments,
  });

  /// Converts this object into a Map<String, dynamic>.
  Map<String, dynamic> toMap() => {
        'year': year,
        'promoted': promoted,
        'attendance': attendance.toMap(),
        'assessments': assessments.map((e) => e.toMap()).toList(),
      };

  Map<String, dynamic> toJson() => toMap(); // Alias

  /// Creates an AcademicYearRecord object from a Map<String, dynamic>.
  factory AcademicYearRecord.fromMap(Map<String, dynamic> map) =>
      AcademicYearRecord(
        year: map['year'] as String? ?? 'Unknown',
        promoted: map['promoted'] as bool? ?? false,
        attendance: Attendance.fromMap(
            map['attendance'] as Map<String, dynamic>? ?? {}),
        assessments: (map['assessments'] as List? ?? [])
            .map((e) => Assessment.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  factory AcademicYearRecord.fromJson(Map<String, dynamic> json) =>
      AcademicYearRecord.fromMap(json); // Alias

  // Map<String, dynamic> toJson() => {
  //       'year': year,
  //       'promoted': promoted,
  //       'attendance': attendance.toJson(),
  //       'assessments': assessments.map((e) => e.toJson()).toList(),
  //     };

  // factory AcademicYearRecord.fromJson(Map<String, dynamic> json) =>
  //     AcademicYearRecord(
  //       year: json['year'] as String? ?? 'Unknown',
  //       promoted: json['promoted'] as bool? ?? false, // Safe casting for bool

  //       // 🛑 CRITICAL FIX: Check if 'attendance' map exists before parsing
  //       attendance: Attendance.fromJson(
  //           json['attendance'] as Map<String, dynamic>? ?? {}),

  //       // 🛑 CRITICAL FIX: Safe list handling
  //       assessments: (json['assessments'] as List? ?? [])
  //           .map((e) => Assessment.fromJson(e as Map<String, dynamic>))
  //           .toList(),
  //     );
}

class Assessment {
  final String type; // Mid Term / Final
  final List<SubjectPerformance> subjects;

  Assessment({required this.type, required this.subjects});

  /// Converts this object into a Map<String, dynamic>.
  Map<String, dynamic> toMap() => {
        'type': type,
        'subjects': subjects.map((e) => e.toMap()).toList(),
      };

  Map<String, dynamic> toJson() => toMap(); // Alias

  /// Creates an Assessment object from a Map<String, dynamic>.
  factory Assessment.fromMap(Map<String, dynamic> map) => Assessment(
        type: map['type'] as String? ?? 'N/A',
        subjects: (map['subjects'] as List? ?? [])
            .map((e) => SubjectPerformance.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  factory Assessment.fromJson(Map<String, dynamic> json) =>
      Assessment.fromMap(json); // Alias

  // Map<String, dynamic> toJson() => {
  //       'type': type,
  //       'subjects': subjects.map((e) => e.toJson()).toList(),
  //     };

  // factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
  //       type: json['type'] as String? ?? 'N/A',
  //       subjects: (json['subjects'] as List? ?? [])
  //           .map((e) => SubjectPerformance.fromJson(e as Map<String, dynamic>))
  //           .toList(),
  //     );
}

class SubjectPerformance {
  final String subjectName;
  final double score;
  final double classAverage;
  final String grade;

  SubjectPerformance({
    required this.subjectName,
    required this.score,
    required this.classAverage,
    required this.grade,
  });

  /// Converts this object into a Map<String, dynamic>.
  Map<String, dynamic> toMap() => {
        'subjectName': subjectName,
        'score': score,
        'classAverage': classAverage,
        'grade': grade,
      };

  Map<String, dynamic> toJson() => toMap(); // Alias

  /// Creates a SubjectPerformance object from a Map<String, dynamic>.
  factory SubjectPerformance.fromMap(Map<String, dynamic> map) =>
      SubjectPerformance(
        subjectName: map['subjectName'] as String? ?? 'Unknown',
        // Safely cast from 'num'
        score: (map['score'] as num? ?? 0.0).toDouble(),
        classAverage: (map['classAverage'] as num? ?? 0.0).toDouble(),
        grade: map['grade'] as String? ?? 'U',
      );

  factory SubjectPerformance.fromJson(Map<String, dynamic> json) =>
      SubjectPerformance.fromMap(json); // Alias

  // Map<String, dynamic> toJson() => {
  //       'subjectName': subjectName,
  //       'score': score,
  //       'classAverage': classAverage,
  //       'grade': grade,
  //     };

  // factory SubjectPerformance.fromJson(Map<String, dynamic> json) =>
  //     SubjectPerformance(
  //       subjectName: json['subjectName'] as String? ?? 'Unknown',

  //       // 🛑 CRITICAL FIX: Safe casting from 'num' for doubles
  //       score: (json['score'] as num? ?? 0.0).toDouble(),
  //       classAverage: (json['classAverage'] as num? ?? 0.0).toDouble(),
  //       grade: json['grade'] as String? ?? 'U', // 'U' for ungraded
  //     );
}

class Attendance {
  final int presentDays;
  final int absentDays;

  Attendance({required this.presentDays, required this.absentDays});

  double get percentage => (presentDays + absentDays) == 0
      ? 0
      : (presentDays / (presentDays + absentDays)) * 100;

  /// Converts this object into a Map<String, dynamic>.
  Map<String, dynamic> toMap() => {
        'presentDays': presentDays,
        'absentDays': absentDays,
      };

  Map<String, dynamic> toJson() => toMap(); // Alias

  /// Creates an Attendance object from a Map<String, dynamic>.
  factory Attendance.fromMap(Map<String, dynamic> map) => Attendance(
        // Safely cast numbers
        presentDays: (map['presentDays'] as num? ?? 0).toInt(),
        absentDays: (map['absentDays'] as num? ?? 0).toInt(),
      );

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      Attendance.fromMap(json); // Alias

  // Map<String, dynamic> toJson() => {
  //       'presentDays': presentDays,
  //       'absentDays': absentDays,
  //       'percentage': percentage,
  //     };

  // factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
  //       // 🛑 CRITICAL FIX: Safely cast and default to 0
  //       presentDays: (json['presentDays'] as num? ?? 0).toInt(),
  //       absentDays: (json['absentDays'] as num? ?? 0).toInt(),
  //     );
}

//mock data

final List<Student> mockStudents = [
  Student(
    status: 'Active',
    id: 's1',
    name: 'Anya Sharma',
    rollNumber: 1001,
    className: '10',
    section: 'A',
    aadharNumber: '1234-5678-9012',
    parentContact: '9876543210',
    feeStatus: 'Paid',
    academicRecords: [
      AcademicYearRecord(
        promoted: true,
        year: '2025',
        assessments: [
          Assessment(
            type: 'Mid Term',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math', score: 92, classAverage: 78, grade: 'A'),
              SubjectPerformance(
                  subjectName: 'Physics',
                  score: 88,
                  classAverage: 75,
                  grade: 'A'),
              SubjectPerformance(
                  subjectName: 'Chemistry',
                  score: 85,
                  classAverage: 72,
                  grade: 'A-'),
            ],
          ),
          Assessment(
            type: 'Final',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math',
                  score: 95,
                  classAverage: 80,
                  grade: 'A+'),
              SubjectPerformance(
                  subjectName: 'Physics',
                  score: 90,
                  classAverage: 77,
                  grade: 'A'),
              SubjectPerformance(
                  subjectName: 'Chemistry',
                  score: 87,
                  classAverage: 74,
                  grade: 'A'),
            ],
          ),
        ],
        attendance: Attendance(
          presentDays: 180,
          absentDays: 10,
        ),
      ),
      AcademicYearRecord(
        promoted: false,
        year: '2024',
        assessments: [
          Assessment(
            type: 'Mid Term',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math', score: 88, classAverage: 76, grade: 'A'),
              SubjectPerformance(
                  subjectName: 'Physics',
                  score: 82,
                  classAverage: 74,
                  grade: 'B+'),
            ],
          ),
          Assessment(
            type: 'Final',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math', score: 90, classAverage: 78, grade: 'A'),
              SubjectPerformance(
                  subjectName: 'Physics',
                  score: 85,
                  classAverage: 75,
                  grade: 'A-'),
            ],
          ),
        ],
        attendance: Attendance(
          presentDays: 170,
          absentDays: 15,
        ),
      ),
    ],
  ),
  Student(
    status: 'Active',
    id: 's2',
    name: 'Rohan Singh',
    rollNumber: 1002,
    className: '10',
    section: 'A',
    aadharNumber: '2345-6789-0123',
    parentContact: '9876543211',
    feeStatus: 'Pending',
    academicRecords: [
      AcademicYearRecord(
        promoted: true,
        year: '2025',
        assessments: [
          Assessment(
            type: 'Mid Term',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math', score: 75, classAverage: 78, grade: 'B'),
              SubjectPerformance(
                  subjectName: 'Physics',
                  score: 70,
                  classAverage: 75,
                  grade: 'C+'),
            ],
          ),
          Assessment(
            type: 'Final',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math',
                  score: 78,
                  classAverage: 80,
                  grade: 'B+'),
              SubjectPerformance(
                  subjectName: 'Physics',
                  score: 72,
                  classAverage: 77,
                  grade: 'C+'),
            ],
          ),
        ],
        attendance: Attendance(presentDays: 160, absentDays: 30),
      ),
    ],
  ),
  Student(
    status: 'Suspended',
    id: 's3',
    name: 'Neha Gupta',
    rollNumber: 1003,
    className: '10 B',
    section: 'B',
    aadharNumber: '3456-7890-1234',
    parentContact: '9876543212',
    feeStatus: 'Paid',
    academicRecords: [
      AcademicYearRecord(
        promoted: true,
        year: '2025',
        assessments: [
          Assessment(
            type: 'Mid Term',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math', score: 88, classAverage: 79, grade: 'A'),
              SubjectPerformance(
                  subjectName: 'Biology',
                  score: 92,
                  classAverage: 85,
                  grade: 'A+'),
            ],
          ),
          Assessment(
            type: 'Final',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math', score: 90, classAverage: 81, grade: 'A'),
              SubjectPerformance(
                  subjectName: 'Biology',
                  score: 95,
                  classAverage: 87,
                  grade: 'A+'),
            ],
          ),
        ],
        attendance: Attendance(presentDays: 178, absentDays: 12),
      ),
    ],
  ),
  Student(
    status: 'Active',
    id: 's4',
    name: 'Vikram Jain',
    rollNumber: 1004,
    className: '9 A',
    section: 'A',
    aadharNumber: '4567-8901-2345',
    parentContact: '9876543213',
    feeStatus: 'Overdue',
    academicRecords: [
      AcademicYearRecord(
        promoted: false,
        year: '2025',
        assessments: [
          Assessment(
            type: 'Mid Term',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math', score: 65, classAverage: 70, grade: 'C'),
              SubjectPerformance(
                  subjectName: 'Physics',
                  score: 60,
                  classAverage: 68,
                  grade: 'C-'),
            ],
          ),
          Assessment(
            type: 'Final',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math',
                  score: 68,
                  classAverage: 72,
                  grade: 'C+'),
              SubjectPerformance(
                  subjectName: 'Physics',
                  score: 63,
                  classAverage: 70,
                  grade: 'C'),
            ],
          ),
        ],
        attendance: Attendance(presentDays: 150, absentDays: 40),
      ),
    ],
  ),
  Student(
    status: 'Active',
    id: 's5',
    name: 'Anjali Mehta',
    rollNumber: 1005,
    className: '9 B',
    section: 'B',
    aadharNumber: '5678-9012-3456',
    parentContact: '9876543214',
    feeStatus: 'Pending',
    academicRecords: [
      AcademicYearRecord(
        promoted: true,
        year: '2025',
        assessments: [
          Assessment(
            type: 'Mid Term',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Chemistry',
                  score: 78,
                  classAverage: 75,
                  grade: 'B+'),
              SubjectPerformance(
                  subjectName: 'Biology',
                  score: 82,
                  classAverage: 78,
                  grade: 'A-'),
            ],
          ),
          Assessment(
            type: 'Final',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Chemistry',
                  score: 80,
                  classAverage: 77,
                  grade: 'A-'),
              SubjectPerformance(
                  subjectName: 'Biology',
                  score: 85,
                  classAverage: 80,
                  grade: 'A'),
            ],
          ),
        ],
        attendance: Attendance(presentDays: 170, absentDays: 15),
      ),
    ],
  ),
  Student(
    status: 'Active',
    id: 's6',
    name: 'Rahul Verma',
    rollNumber: 1006,
    className: '10 C',
    section: 'C',
    aadharNumber: '6789-0123-4567',
    parentContact: '9876543215',
    feeStatus: 'Paid',
    academicRecords: [
      AcademicYearRecord(
        promoted: true,
        year: '2025',
        assessments: [
          Assessment(
            type: 'Mid Term',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math',
                  score: 72,
                  classAverage: 74,
                  grade: 'B-'),
              SubjectPerformance(
                  subjectName: 'Physics',
                  score: 70,
                  classAverage: 72,
                  grade: 'C+'),
            ],
          ),
          Assessment(
            type: 'Final',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math', score: 75, classAverage: 76, grade: 'B'),
              SubjectPerformance(
                  subjectName: 'Physics',
                  score: 73,
                  classAverage: 74,
                  grade: 'B-'),
            ],
          ),
        ],
        attendance: Attendance(
          presentDays: 160,
          absentDays: 20,
        ),
      ),
    ],
  ),
  Student(
    status: 'Active',
    id: 's7',
    name: 'Simran Kaur',
    rollNumber: 1007,
    className: '10 C',
    section: 'C',
    aadharNumber: '7890-1234-5678',
    parentContact: '9876543216',
    feeStatus: 'Overdue',
    academicRecords: [
      AcademicYearRecord(
        promoted: true,
        year: '2025',
        assessments: [
          Assessment(
            type: 'Mid Term',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math', score: 85, classAverage: 78, grade: 'A'),
              SubjectPerformance(
                  subjectName: 'English',
                  score: 88,
                  classAverage: 80,
                  grade: 'A'),
            ],
          ),
          Assessment(
            type: 'Final',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math', score: 87, classAverage: 80, grade: 'A'),
              SubjectPerformance(
                  subjectName: 'English',
                  score: 90,
                  classAverage: 82,
                  grade: 'A+'),
            ],
          ),
        ],
        attendance: Attendance(
          presentDays: 175,
          absentDays: 10,
        ),
      ),
    ],
  ),
  Student(
    status: 'Active',
    id: 's8',
    name: 'Aditya Sharma',
    rollNumber: 1008,
    className: '9 A',
    section: 'A',
    aadharNumber: '8901-2345-6789',
    parentContact: '9876543217',
    feeStatus: 'Paid',
    academicRecords: [
      AcademicYearRecord(
        promoted: true,
        year: '2025',
        assessments: [
          Assessment(
            type: 'Mid Term',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math',
                  score: 78,
                  classAverage: 74,
                  grade: 'B+'),
              SubjectPerformance(
                  subjectName: 'Science',
                  score: 80,
                  classAverage: 76,
                  grade: 'A-'),
            ],
          ),
          Assessment(
            type: 'Final',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math',
                  score: 82,
                  classAverage: 76,
                  grade: 'A-'),
              SubjectPerformance(
                  subjectName: 'Science',
                  score: 85,
                  classAverage: 78,
                  grade: 'A'),
            ],
          ),
        ],
        attendance: Attendance(
          presentDays: 168,
          absentDays: 17,
        ),
      ),
    ],
  ),
  Student(
    status: 'Suspended',
    id: 's9',
    name: 'Pooja Rani',
    rollNumber: 1009,
    className: '10 B',
    section: 'B',
    aadharNumber: '9012-3456-7890',
    parentContact: '9876543218',
    feeStatus: 'Paid',
    academicRecords: [
      AcademicYearRecord(
        promoted: false,
        year: '2025',
        assessments: [
          Assessment(
            type: 'Mid Term',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math',
                  score: 68,
                  classAverage: 70,
                  grade: 'C+'),
              SubjectPerformance(
                  subjectName: 'English',
                  score: 70,
                  classAverage: 72,
                  grade: 'B-'),
            ],
          ),
          Assessment(
            type: 'Final',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math',
                  score: 70,
                  classAverage: 72,
                  grade: 'B-'),
              SubjectPerformance(
                  subjectName: 'English',
                  score: 73,
                  classAverage: 74,
                  grade: 'B'),
            ],
          ),
        ],
        attendance: Attendance(
          presentDays: 158,
          absentDays: 22,
        ),
      ),
    ],
  ),
  Student(
    status: 'Active',
    id: 's10',
    name: 'Arjun Mishra',
    rollNumber: 1010,
    className: '9 B',
    section: 'B',
    aadharNumber: '0123-4567-8901',
    parentContact: '9876543219',
    feeStatus: 'Pending',
    academicRecords: [
      AcademicYearRecord(
        promoted: true,
        year: '2025',
        assessments: [
          Assessment(
            type: 'Mid Term',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math',
                  score: 82,
                  classAverage: 78,
                  grade: 'A-'),
              SubjectPerformance(
                  subjectName: 'Science',
                  score: 85,
                  classAverage: 80,
                  grade: 'A'),
            ],
          ),
          Assessment(
            type: 'Final',
            subjects: [
              SubjectPerformance(
                  subjectName: 'Math', score: 85, classAverage: 80, grade: 'A'),
              SubjectPerformance(
                  subjectName: 'Science',
                  score: 88,
                  classAverage: 82,
                  grade: 'A+'),
            ],
          ),
        ],
        attendance: Attendance(
          presentDays: 172,
          absentDays: 14,
        ),
      ),
    ],
  ),
];
