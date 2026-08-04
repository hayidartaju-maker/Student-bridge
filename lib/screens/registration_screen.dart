import 'dart:io';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../widgets/photo_picker_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Student fields
  final _studentName = TextEditingController();
  final _studentGrade = TextEditingController();
  final _studentRoom = TextEditingController();
  DateTime? _studentDob;
  String _studentGender = 'Male';
  File? _studentPhoto;

  // Parent fields
  final _parentName = TextEditingController();
  final _parentPhone = TextEditingController();
  final _parentEmail = TextEditingController();
  final _parentAddress = TextEditingController();
  String _relationship = 'Father';
  File? _parentPhoto;

  bool _submitting = false;

  bool get _photosComplete => _studentPhoto != null && _parentPhoto != null;

  @override
  void dispose() {
    for (final c in [
      _studentName,
      _studentGrade,
      _studentRoom,
      _parentName,
      _parentPhone,
      _parentEmail,
      _parentAddress,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 10),
      firstDate: DateTime(now.year - 25),
      lastDate: now,
    );
    if (picked != null) setState(() => _studentDob = picked);
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState?.validate() ?? false;

    if (!formValid || !_photosComplete || _studentDob == null) {
      setState(() {}); // refresh photo "required" hints
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill every field and add both photos before continuing.'),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    setState(() => _submitting = true);
    try {
      await SupabaseService.instance.registerFamily(
        studentPhotoFile: _studentPhoto!,
        parentPhotoFile: _parentPhoto!,
        studentFields: {
          'fullName': _studentName.text.trim(),
          'dateOfBirth': _studentDob,
          'gradeLevel': _studentGrade.text.trim(),
          'gender': _studentGender,
          'roomNumber': _studentRoom.text.trim(),
        },
        parentFields: {
          'fullName': _parentName.text.trim(),
          'relationship': _relationship,
          'phone': _parentPhone.text.trim(),
          'email': _parentEmail.text.trim(),
          'address': _parentAddress.text.trim(),
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Registration complete.'),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration failed: $e'),
        backgroundColor: Colors.redAccent,
      ));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Registration')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionCard(
              title: 'Student',
              children: [
                Center(
                  child: PhotoPickerField(
                    label: 'Student photo',
                    file: _studentPhoto,
                    onChanged: (f) => setState(() => _studentPhoto = f),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _studentName,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: _req,
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _pickDob,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date of birth',
                      errorText: _studentDob == null && _submitting == false
                          ? null
                          : null,
                    ),
                    child: Text(
                      _studentDob == null
                          ? 'Tap to select'
                          : '${_studentDob!.year}-${_studentDob!.month.toString().padLeft(2, '0')}-${_studentDob!.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _studentGrade,
                  decoration: const InputDecoration(labelText: 'Grade / Class'),
                  validator: _req,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _studentRoom,
                  decoration: const InputDecoration(labelText: 'Room number'),
                  validator: _req,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _studentGender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const ['Male', 'Female']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _studentGender = v!),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Parent / Guardian',
              children: [
                Center(
                  child: PhotoPickerField(
                    label: 'Parent photo',
                    file: _parentPhoto,
                    onChanged: (f) => setState(() => _parentPhoto = f),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _parentName,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: _req,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _relationship,
                  decoration: const InputDecoration(labelText: 'Relationship'),
                  items: const ['Father', 'Mother', 'Guardian']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _relationship = v!),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _parentPhone,
                  decoration: const InputDecoration(labelText: 'Phone number'),
                  keyboardType: TextInputType.phone,
                  validator: _req,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _parentEmail,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _parentAddress,
                  decoration: const InputDecoration(labelText: 'Address'),
                  maxLines: 2,
                  validator: _req,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.4, color: Colors.white),
                      )
                    : const Text('Complete Registration'),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'All fields and both photos are required to submit.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black45, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
