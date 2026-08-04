import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants.dart';
import '../models/student.dart';
import '../models/parent.dart';
import '../models/result.dart';

/// Single access point for everything backend-related (auth, database,
/// storage). Keeping it in one service makes it easy to swap providers
/// later and keeps UI code free of Supabase-specific calls.
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  SupabaseClient get _client => Supabase.instance.client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  // ── Auth ────────────────────────────────────────────────────────────
  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  Future<AuthResponse> signIn(String email, String password) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password) {
    return _client.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() => _client.auth.signOut();

  // ── Photo upload ────────────────────────────────────────────────────
  /// Uploads [file] to [bucket] under a unique path and returns the
  /// public URL to store alongside the record.
  Future<String> uploadPhoto({
    required File file,
    required String bucket,
  }) async {
    final ext = file.path.split('.').last;
    final path = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    await _client.storage.from(bucket).upload(path, file);
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  // ── Parents ─────────────────────────────────────────────────────────
  Future<Parent> createParent(Parent parent) async {
    final row = await _client
        .from('parents')
        .insert(parent.toMap())
        .select()
        .single();
    return Parent.fromMap(row);
  }

  Future<List<Parent>> fetchParents() async {
    final rows = await _client
        .from('parents')
        .select()
        .order('created_at', ascending: false);
    return (rows as List).map((r) => Parent.fromMap(r)).toList();
  }

  // ── Students ────────────────────────────────────────────────────────
  Future<Student> createStudent(Student student) async {
    final row = await _client
        .from('students')
        .insert(student.toMap())
        .select()
        .single();
    return Student.fromMap(row);
  }

  Future<List<Student>> fetchStudents() async {
    final rows = await _client
        .from('students')
        .select()
        .order('created_at', ascending: false);
    return (rows as List).map((r) => Student.fromMap(r)).toList();
  }

  /// Fetches a student together with its linked parent record in one call.
  Future<Map<String, dynamic>> fetchStudentWithParent(String studentId) async {
    final row = await _client
        .from('students')
        .select('*, parents(*)')
        .eq('id', studentId)
        .single();
    return row;
  }

  /// Registers a family in one transaction-like sequence:
  /// upload both photos → create parent → create student linked to parent.
  /// Throws if any step fails, so partial records are easy to spot in logs.
  Future<Student> registerFamily({
    required File studentPhotoFile,
    required File parentPhotoFile,
    required Map<String, dynamic> studentFields,
    required Map<String, dynamic> parentFields,
  }) async {
    final studentPhotoUrl = await uploadPhoto(
      file: studentPhotoFile,
      bucket: SupabaseConfig.studentPhotosBucket,
    );
    final parentPhotoUrl = await uploadPhoto(
      file: parentPhotoFile,
      bucket: SupabaseConfig.parentPhotosBucket,
    );

    final parent = await createParent(Parent(
      fullName: parentFields['fullName'],
      relationship: parentFields['relationship'],
      phone: parentFields['phone'],
      email: parentFields['email'],
      address: parentFields['address'],
      photoUrl: parentPhotoUrl,
    ));

    final student = await createStudent(Student(
      fullName: studentFields['fullName'],
      dateOfBirth: studentFields['dateOfBirth'],
      gradeLevel: studentFields['gradeLevel'],
      gender: studentFields['gender'],
      roomNumber: studentFields['roomNumber'],
      photoUrl: studentPhotoUrl,
      parentId: parent.id!,
    ));

    return student;
  }

  // ── Results ─────────────────────────────────────────────────────────
  /// Inserts many rows at once — used by the admin CSV/spreadsheet import.
  Future<void> bulkInsertResults(List<Result> results) async {
    if (results.isEmpty) return;
    await _client.from('results').insert(results.map((r) => r.toMap()).toList());
  }

  Future<List<Result>> fetchResultsForStudent(String studentId) async {
    final rows = await _client
        .from('results')
        .select()
        .eq('student_id', studentId)
        .order('term', ascending: false);
    return (rows as List).map((r) => Result.fromMap(r)).toList();
  }

  /// Looks a student up by exact full name — used to match spreadsheet
  /// rows (which reference students by name) to a student_id.
  Future<Student?> findStudentByName(String fullName) async {
    final rows = await _client
        .from('students')
        .select()
        .ilike('full_name', fullName.trim())
        .limit(1);
    final list = rows as List;
    if (list.isEmpty) return null;
    return Student.fromMap(list.first);
  }
}
