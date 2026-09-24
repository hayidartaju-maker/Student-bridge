import 'package:flutter/material.dart';
import '../core/app_roles.dart';
import '../providers/app_provider.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = [
      AppRole.admin,
      AppRole.teacher,
      AppRole.parent,
      AppRole.student,
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Boarding Bridge',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your role to continue.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: roles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final role = roles[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(_roleIcon(role)),
                        title: Text(role.label),
                        subtitle: Text(_roleDescription(role)),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () async {
                          final provider = context.read<AppProvider>();
                          await provider.setRole(role);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _roleIcon(AppRole role) {
    switch (role) {
      case AppRole.admin:
        return Icons.admin_panel_settings_rounded;
      case AppRole.teacher:
        return Icons.school_rounded;
      case AppRole.parent:
        return Icons.family_restroom_rounded;
      case AppRole.student:
        return Icons.person_rounded;
    }
  }

  String _roleDescription(AppRole role) {
    switch (role) {
      case AppRole.admin:
        return 'Manage registrations, students, and results.';
      case AppRole.teacher:
        return 'Review academic records and monitor student performance.';
      case AppRole.parent:
        return 'View your child\'s profile and academic results.';
      case AppRole.student:
        return 'See your personal results and school information.';
    }
  }
}
