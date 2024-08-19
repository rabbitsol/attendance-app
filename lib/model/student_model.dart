class StudentModel {
  final String name;
  final int rollNo;
  final String semester;
  final String department;
  final String imageUrl;

  StudentModel({
    required this.name,
    required this.rollNo,
    required this.semester,
    required this.department,
    required this.imageUrl,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      name: map['name'] ?? '',
      rollNo: map['rollno'] ?? '',
      semester: map['semester'] ?? '',
      department: map['department'] ?? '',
      imageUrl: map['image'] ?? '',
    );
  }
}
