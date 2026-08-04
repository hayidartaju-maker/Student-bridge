class Result {
  final String? id;
  final String studentId;
  final String term;
  final String subject;
  final double score;
  final double maxScore;
  final String? remarks;

  Result({
    this.id,
    required this.studentId,
    required this.term,
    required this.subject,
    required this.score,
    required this.maxScore,
    this.remarks,
  });

  double get percentage => maxScore == 0 ? 0 : (score / maxScore) * 100;

  String get grade {
    final p = percentage;
    if (p >= 90) return 'A+';
    if (p >= 80) return 'A';
    if (p >= 70) return 'B';
    if (p >= 60) return 'C';
    if (p >= 50) return 'D';
    return 'F';
  }

  Map<String, dynamic> toMap() => {
        'student_id': studentId,
        'term': term,
        'subject': subject,
        'score': score,
        'max_score': maxScore,
        'remarks': remarks,
      };

  factory Result.fromMap(Map<String, dynamic> map) => Result(
        id: map['id']?.toString(),
        studentId: map['student_id']?.toString() ?? '',
        term: map['term'] ?? '',
        subject: map['subject'] ?? '',
        score: (map['score'] as num?)?.toDouble() ?? 0,
        maxScore: (map['max_score'] as num?)?.toDouble() ?? 100,
        remarks: map['remarks'],
      );
}
