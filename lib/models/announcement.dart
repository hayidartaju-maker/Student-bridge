class Announcement {
  final String? id;
  final String title;
  final String body;
  final String? createdBy;
  final DateTime createdAt;
  final bool isPublished;

  const Announcement({
    this.id,
    required this.title,
    required this.body,
    this.createdBy,
    required this.createdAt,
    this.isPublished = true,
  });

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id']?.toString(),
      title: map['title']?.toString() ?? '',
      body: map['body']?.toString() ?? '',
      createdBy: map['created_by']?.toString(),
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now(),
      isPublished: map['is_published'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap({String? userId}) => {
        'title': title.trim(),
        'body': body.trim(),
        'created_by': userId,
        'is_published': isPublished,
      };
}
