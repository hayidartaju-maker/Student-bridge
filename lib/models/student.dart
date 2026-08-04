class Student {
  final String? id;
  final String fullName;
  final DateTime dateOfBirth;
  final String gradeLevel;
  final String gender;
  final String roomNumber;
  final String photoUrl; // public URL in student_photos bucket
  final String parentId; // FK -> parents.id
  final DateTime createdAt;

  Student({
    this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.gradeLevel,
    required this.gender,
    required this.roomNumber,
    required this.photoUrl,
    required this.parentId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'full_name': fullName,
        'date_of_birth': dateOfBirth.toIso8601String(),
        'grade_level': gradeLevel,
        'gender': gender,
        'room_number': roomNumber,
        'photo_url': photoUrl,
        'parent_id': parentId,
      };

  factory Student.fromMap(Map<String, dynamic> map) => Student(
        id: map['id']?.toString(),
        fullName: map['full_name'] ?? '',
        dateOfBirth: DateTime.tryParse(map['date_of_birth'] ?? '') ?? DateTime.now(),
        gradeLevel: map['grade_level'] ?? '',
        gender: map['gender'] ?? '',
        roomNumber: map['room_number'] ?? '',
        photoUrl: map['photo_url'] ?? '',
        parentId: map['parent_id']?.toString() ?? '',
        createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      );
}
