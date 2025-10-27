class Teacher {
  final String id; // Firestore document ID
  final String name;
  final String subject;
  final String department; // e.g. Science, Literature, Mathematics
  final String status; // "Active", "On Leave", "Resigned"
  final String contactInfo; // phone or email
  final double salary;
  final List<String> classIds;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.department,
    required this.status,
    required this.contactInfo,
    required this.salary,
    required this.classIds,
  });

  // ---------------- JSON Serialization ----------------
  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'subject': subject,
        'department': department,
        'status': status,
        'contactInfo': contactInfo,
        'salary': salary,
        'classIds': classIds,
      };

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json['_id'] ?? '',
        name: json['name'],
        subject: json['subject'],
        department: json['department'],
        status: json['status'],
        contactInfo: json['contactInfo'],
        salary: (json['salary'] as num).toDouble(),
        classIds: List<String>.from(json['classIds'] as List? ?? []),
      );

  // ---------------- copyWith (for updates) ----------------
  Teacher copyWith({
    String? id,
    String? name,
    String? subject,
    String? department,
    String? status,
    String? contactInfo,
    double? salary,
    List<String>? classIds,
  }) {
    return Teacher(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      department: department ?? this.department,
      status: status ?? this.status,
      contactInfo: contactInfo ?? this.contactInfo,
      salary: salary ?? this.salary,
      classIds: classIds ?? this.classIds,
    );
  }
}

// mock data

final List<Teacher> mockTeachers = [
  Teacher(
    id: 't1',
    name: 'Amit Kumar',
    subject: 'Physics',
    department: 'Science',
    status: 'Active',
    contactInfo: '9876543210',
    salary: 55000,
    classIds: ['9th_A', '10th_B', '11th_Science_Batch_1'],
  ),
  Teacher(
    id: 't2',
    name: 'Sonal Verma',
    subject: 'Chemistry',
    department: 'Science',
    status: 'Active',
    contactInfo: '9876543211',
    salary: 53000,
    classIds: ['6th_C', '7th_A'],
  ),
  Teacher(
    id: 't3',
    name: 'Rajesh Singh',
    subject: 'Mathematics',
    department: 'Science',
    status: 'On Leave',
    contactInfo: '9876543212',
    salary: 50000,
    classIds: ['9th_A', '10th_B', '11th_Science_Batch_1'],
  ),
  Teacher(
    id: 't4',
    name: 'Neha Sharma',
    subject: 'Biology',
    department: 'Science',
    status: 'Active',
    contactInfo: '9876543213',
    salary: 52000,
    classIds: ['6th_C', '7th_A'],
  ),
  Teacher(
    id: 't5',
    name: 'Vikram Patel',
    subject: 'English',
    department: 'Literature',
    status: 'Resigned',
    contactInfo: '9876543214',
    salary: 48000,
    classIds: ['9th_A', '10th_B', '11th_Science_Batch_1'],
  ),
  Teacher(
    id: 't6',
    name: 'Priya Desai',
    subject: 'History',
    department: 'Social Studies',
    status: 'Active',
    contactInfo: '9876543215',
    salary: 51000,
    classIds: ['6th_C', '7th_A'],
  ),
  Teacher(
    id: 't7',
    name: 'Manoj Tiwari',
    subject: 'Geography',
    department: 'Social Studies',
    status: 'On Leave',
    contactInfo: '9876543216',
    salary: 50000,
    classIds: ['6th_C', '7th_A'],
  ),
  Teacher(
    id: 't8',
    name: 'Anjali Gupta',
    subject: 'Computer Science',
    department: 'Technology',
    status: 'Active',
    contactInfo: '9876543217',
    salary: 60000,
    classIds: ['9th_A', '10th_B', '11th_Science_Batch_1'],
  ),
  Teacher(
    id: 't9',
    name: 'Rohit Mehra',
    subject: 'Economics',
    department: 'Commerce',
    status: 'Active',
    contactInfo: '9876543218',
    salary: 52000,
    classIds: ['6th_C', '7th_A'],
  ),
  Teacher(
    id: 't10',
    name: 'Shweta Rao',
    subject: 'Political Science',
    department: 'Social Studies',
    status: 'Resigned',
    contactInfo: '9876543219',
    salary: 50000,
    classIds: ['9th_A', '10th_B', '11th_Science_Batch_1'],
  ),
];
