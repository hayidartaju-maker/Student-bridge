import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../models/result.dart';
import '../services/supabase_service.dart';

/// Admin uploads a CSV spreadsheet with columns:
///   student_name, term, subject, score, max_score, remarks
///
/// Export this straight from Excel/Google Sheets as CSV. Each row is
/// matched to a student by exact name, then all matched rows are
/// bulk-inserted into the `results` table in one go.
class AdminUploadResultsScreen extends StatefulWidget {
  const AdminUploadResultsScreen({super.key});

  @override
  State<AdminUploadResultsScreen> createState() =>
      _AdminUploadResultsScreenState();
}

class _AdminUploadResultsScreenState extends State<AdminUploadResultsScreen> {
  List<List<dynamic>>? _rows; // raw parsed CSV incl. header
  String? _fileName;
  bool _uploading = false;
  final List<String> _errors = [];

  Future<void> _pickCsv() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );
    if (picked == null || picked.files.single.bytes == null) return;

    final content = String.fromCharCodes(picked.files.single.bytes!);
    final parsed = const CsvToListConverter(eol: '\n').convert(content);

    setState(() {
      _rows = parsed;
      _fileName = picked.files.single.name;
      _errors.clear();
    });
  }

  Future<void> _upload() async {
    if (_rows == null || _rows!.length < 2) return;
    setState(() {
      _uploading = true;
      _errors.clear();
    });

    final header = _rows!.first.map((e) => e.toString().trim().toLowerCase()).toList();
    final idxName = header.indexOf('student_name');
    final idxTerm = header.indexOf('term');
    final idxSubject = header.indexOf('subject');
    final idxScore = header.indexOf('score');
    final idxMax = header.indexOf('max_score');
    final idxRemarks = header.indexOf('remarks');

    if ([idxName, idxTerm, idxSubject, idxScore].contains(-1)) {
      setState(() {
        _uploading = false;
        _errors.add(
            'CSV must have columns: student_name, term, subject, score (max_score, remarks optional).');
      });
      return;
    }

    final results = <Result>[];
    for (var i = 1; i < _rows!.length; i++) {
      final row = _rows![i];
      if (row.isEmpty || row.length <= idxName) continue;
      final name = row[idxName].toString().trim();
      if (name.isEmpty) continue;

      final student = await SupabaseService.instance.findStudentByName(name);
      if (student == null) {
        _errors.add('Row ${i + 1}: no student found named "$name" — skipped.');
        continue;
      }

      results.add(Result(
        studentId: student.id!,
        term: row[idxTerm].toString().trim(),
        subject: row[idxSubject].toString().trim(),
        score: double.tryParse(row[idxScore].toString()) ?? 0,
        maxScore: idxMax != -1 && row.length > idxMax
            ? (double.tryParse(row[idxMax].toString()) ?? 100)
            : 100,
        remarks: idxRemarks != -1 && row.length > idxRemarks
            ? row[idxRemarks].toString()
            : null,
      ));
    }

    try {
      await SupabaseService.instance.bulkInsertResults(results);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Uploaded ${results.length} result rows.'),
        backgroundColor: Colors.green,
      ));
      setState(() {
        _rows = null;
        _fileName = null;
      });
    } catch (e) {
      setState(() => _errors.add('Upload failed: $e'));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = _rows != null && _rows!.length > 1
        ? _rows!.skip(1).take(5).toList()
        : <List<dynamic>>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Results')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CSV columns required',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  const Text(
                    'student_name, term, subject, score, max_score (optional), remarks (optional)',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Export this directly from Excel or Google Sheets as CSV — student_name must exactly match the name used at registration.',
                    style: TextStyle(color: Colors.black45, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _pickCsv,
            icon: const Icon(Icons.upload_file_rounded),
            label: Text(_fileName ?? 'Choose CSV file'),
          ),
          if (preview.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Preview (first 5 rows)',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: _rows!.first
                    .map((c) => DataColumn(label: Text(c.toString())))
                    .toList(),
                rows: preview
                    .map((r) => DataRow(
                        cells: r.map((c) => DataCell(Text(c.toString()))).toList()))
                    .toList(),
              ),
            ),
          ],
          if (_errors.isNotEmpty) ...[
            const SizedBox(height: 16),
            ..._errors.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(e, style: const TextStyle(color: Colors.redAccent)),
                )),
          ],
          const SizedBox(height: 24),
          if (_rows != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _uploading ? null : _upload,
                child: _uploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.4, color: Colors.white),
                      )
                    : Text('Upload ${_rows!.length - 1} rows'),
              ),
            ),
        ],
      ),
    );
  }
}
