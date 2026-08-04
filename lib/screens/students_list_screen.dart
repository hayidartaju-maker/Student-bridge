import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/supabase_service.dart';
import 'student_results_screen.dart';

class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({super.key});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  late Future<List<Student>> _future;

  @override
  void initState() {
    super.initState();
    _future = SupabaseService.instance.fetchStudents();
  }

  Future<void> _refresh() async {
    setState(() => _future = SupabaseService.instance.fetchStudents());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Student>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Could not load students: ${snapshot.error}'),
                ),
              ]);
            }
            final students = snapshot.data ?? [];
            if (students.isEmpty) {
              return ListView(children: const [
                Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('No students registered yet.')),
                ),
              ]);
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final s = students[i];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundImage:
                          s.photoUrl.isNotEmpty ? NetworkImage(s.photoUrl) : null,
                      child: s.photoUrl.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    title: Text(s.fullName,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${s.gradeLevel} • Room ${s.roomNumber}'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => StudentResultsScreen(student: s)),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
