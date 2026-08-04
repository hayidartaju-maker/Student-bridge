import 'package:flutter/material.dart';
import '../models/result.dart';
import '../models/student.dart';
import '../services/supabase_service.dart';

class StudentResultsScreen extends StatefulWidget {
  final Student student;
  const StudentResultsScreen({super.key, required this.student});

  @override
  State<StudentResultsScreen> createState() => _StudentResultsScreenState();
}

class _StudentResultsScreenState extends State<StudentResultsScreen> {
  late Future<List<Result>> _future;

  @override
  void initState() {
    super.initState();
    _future = SupabaseService.instance.fetchResultsForStudent(widget.student.id!);
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.deepOrange;
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.student.fullName} — Results')),
      body: FutureBuilder<List<Result>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Could not load results: ${snapshot.error}'));
          }
          final results = snapshot.data ?? [];
          if (results.isEmpty) {
            return const Center(child: Text('No results uploaded yet.'));
          }

          // Group by term
          final byTerm = <String, List<Result>>{};
          for (final r in results) {
            byTerm.putIfAbsent(r.term, () => []).add(r);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: widget.student.photoUrl.isNotEmpty
                            ? NetworkImage(widget.student.photoUrl)
                            : null,
                        child: widget.student.photoUrl.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.student.fullName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 16)),
                            Text(
                                '${widget.student.gradeLevel} • Room ${widget.student.roomNumber}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              for (final term in byTerm.keys) ...[
                Text(term,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: byTerm[term]!
                        .map((r) => ListTile(
                              title: Text(r.subject,
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: r.remarks != null && r.remarks!.isNotEmpty
                                  ? Text(r.remarks!)
                                  : null,
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${r.score.toStringAsFixed(0)}/${r.maxScore.toStringAsFixed(0)}'),
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _gradeColor(r.grade).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      r.grade,
                                      style: TextStyle(
                                        color: _gradeColor(r.grade),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          );
        },
      ),
    );
  }
}
