import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants.dart';
import '../models/announcement.dart';
import '../models/student.dart';
import '../models/parent.dart';
import '../models/result.dart';

class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();
  SupabaseClient get _client => Supabase.instance.client;

  static Future<void> init() async {
    await Supabase.initialize(url: SupabaseConfig.url, anonKey: SupabaseConfig.anonKey);
  }

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  Future<AuthResponse> signIn(String email, String password) =>
      _client.auth.signInWithPassword(email: email, password: password);
  Future<AuthResponse> signUp(String email, String password) =>
      _client.auth.signUp(email: email, password: password);
  Future<void> signOut() => _client.auth.signOut();

  Future<String> uploadPhoto({required File file, required String bucket}) async {
    final ext = file.path.split('.').last.toLowerCase();
    final path = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    await _client.storage.from(bucket).upload(path, file);
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  Future<Parent> createParent(Parent parent) async {
    final row = await _client.from('parents').insert(parent.toMap()).select().single();
    return Parent.fromMap(row);
  }

  Future<List<Parent>> fetchParents() async {
    final rows = await _client.from('parents').select().order('created_at', ascending: false);
    return (rows as List).map((row) => Parent.fromMap(row)).toList();
  }

  Future<Student> createStudent(Student student) async {
    final row = await _client.from('students').insert(student.toMap()).select().single();
    return Student.fromMap(row);
  }

  Future<List<Student>> fetchStudents() async {
    final rows = await _client.from('students').select().order('created_at', ascending: false);
    return (rows as List).map((row) => Student.fromMap(row)).toList();
  }

  Future<Map<String, dynamic>> fetchStudentWithParent(String studentId) async {
    return await _client.from('students').select('*, parents(*)').eq('id', studentId).single();
  }

  Future<Student> registerFamily({
    required File studentPhotoFile,
    required File parentPhotoFile,
    required Map<String, dynamic> studentFields,
    required Map<String, dynamic> parentFields,
  }) async {
    final studentPhotoUrl = await uploadPhoto(file: studentPhotoFile, bucket: SupabaseConfig.studentPhotosBucket);
    final parentPhotoUrl = await uploadPhoto(file: parentPhotoFile, bucket: SupabaseConfig.parentPhotosBucket);
    final parent = await createParent(Parent(
      fullName: parentFields['fullName'] as String,
      relationship: parentFields['relationship'] as String,
      phone: parentFields['phone'] as String,
      email: parentFields['email'] as String,
      address: parentFields['address'] as String,
      photoUrl: parentPhotoUrl,
    ));
    return createStudent(Student(
      fullName: studentFields['fullName'] as String,
      dateOfBirth: studentFields['dateOfBirth'] as DateTime,
      gradeLevel: studentFields['gradeLevel'] as String,
      gender: studentFields['gender'] as String,
      roomNumber: studentFields['roomNumber'] as String,
      photoUrl: studentPhotoUrl,
      parentId: parent.id!,
    ));
  }

  Future<void> bulkInsertResults(List<Result> results) async {
    if (results.isEmpty) return;
    await _client.from('results').insert(results.map((result) => result.toMap()).toList());
  }

  Future<List<Result>> fetchResultsForStudent(String studentId) async {
    final rows = await _client.from('results').select().eq('student_id', studentId).order('term', ascending: false);
    return (rows as List).map((row) => Result.fromMap(row)).toList();
  }

  Future<Student?> findStudentByName(String fullName) async {
    final rows = await _client.from('students').select().ilike('full_name', fullName.trim()).limit(1);
    final list = rows as List;
    return list.isEmpty ? null : Student.fromMap(list.first);
  }

  Future<List<Announcement>> fetchAnnouncements() async {
    final rows = await _client.from('announcements').select().eq('is_published', true).order('created_at', ascending: false).limit(20);
    return (rows as List).map((row) => Announcement.fromMap(row)).toList();
  }

  Future<Announcement> createAnnouncement({required String title, required String body}) async {
    final row = await _client.from('announcements').insert(
      Announcement(title: title, body: body, createdAt: DateTime.now()).toMap(userId: currentUser?.id),
    ).select().single();
    return Announcement.fromMap(row);
  }

  Future<void> deleteAnnouncement(String id) async {
    await _client.from('announcements').delete().eq('id', id);
  }
}
