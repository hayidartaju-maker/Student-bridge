import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_roles.dart';
import '../providers/app_provider.dart';
import 'main_scaffold.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const roles = AppRole.values;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E7),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 32),
            const Text(
              'Boarding Bridge',
              style: TextStyle(
                color: Color(0xFF132A3E),
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose your role to continue.',
              style: TextStyle(color: Color(0xFF5B6B78), fontSize: 16),
            ),
            const SizedBox(height: 28),
            ...roles.map(
              (role) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF2E8B8B).withOpacity(.12),
                      child: Icon(_iconFor(role), color: const Color(0xFF2E8B8B)),
                    ),
                    title: Text(role.label),
                    subtitle: Text(_descriptionFor(role)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () async {
                      await context.read<AppProvider>().setRole(role);
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScaffold()),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(AppRole role) => switch (role) {
        AppRole.admin => Icons.admin_panel_settings_rounded,
        AppRole.teacher => Icons.school_rounded,
        AppRole.parent => Icons.family_restroom_rounded,
        AppRole.student => Icons.person_rounded,
      };

  String _descriptionFor(AppRole role) => switch (role) {
        AppRole.admin => 'Manage registrations, students, and results.',
        AppRole.teacher => 'Review students and academic progress.',
        AppRole.parent => 'View linked children and results.',
        AppRole.student => 'View your profile and released results.',
      };
}
