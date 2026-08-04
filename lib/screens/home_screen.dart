import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'students_list_screen.dart';
import 'admin_upload_results_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ActionCard(
            icon: Icons.person_add_alt_1_rounded,
            title: 'New Registration',
            subtitle: 'Enroll a student with parent details & photos',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RegistrationScreen())),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.groups_rounded,
            title: 'Students & Parents',
            subtitle: 'View all registered records • tap a student for results',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const StudentsListScreen())),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.upload_file_rounded,
            title: 'Upload Results',
            subtitle: 'Admin: bulk-import a results spreadsheet (CSV)',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminUploadResultsScreen())),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(color: Colors.black.withOpacity(0.55))),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
