class Parent {
  final String? id;
  final String fullName;
  final String relationship; // Father / Mother / Guardian
  final String phone;
  final String email;
  final String address;
  final String photoUrl; // public URL in parent_photos bucket
  final DateTime createdAt;

  Parent({
    this.id,
    required this.fullName,
    required this.relationship,
    required this.phone,
    required this.email,
    required this.address,
    required this.photoUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'full_name': fullName,
        'relationship': relationship,
        'phone': phone,
        'email': email,
        'address': address,
        'photo_url': photoUrl,
      };

  factory Parent.fromMap(Map<String, dynamic> map) => Parent(
        id: map['id']?.toString(),
        fullName: map['full_name'] ?? '',
        relationship: map['relationship'] ?? '',
        phone: map['phone'] ?? '',
        email: map['email'] ?? '',
        address: map['address'] ?? '',
        photoUrl: map['photo_url'] ?? '',
        createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      );
}
