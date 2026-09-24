import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_roles.dart';
import '../providers/app_provider.dart';
import '../services/supabase_service.dart';
import '../widgets/announcements_panel.dart';
import 'admin_upload_results_screen.dart';
import 'registration_screen.dart';
import 'students_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppRole role;

  const HomeScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${role.label} Dashboard'),
        actions: [
          IconButton(
            onPressed: () async => context.read<AppProvider>().toggleTheme(),
            icon: const Icon(Icons.brightness_6_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnnouncementsPanel(role: role),
          const SizedBox(height: 16),
          ..._cardsForRole(context),
        ],
      ),
    );
  }

  List<Widget> _cardsForRole(BuildContext context) {
    switch (role) {
      case AppRole.admin:
        return [
          _ActionCard(
            icon: Icons.person_add_alt_1_rounded,
            title: 'New Registration',
            subtitle: 'Enroll a student with parent details & photos',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrationScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.groups_rounded,
            title: 'Students & Parents',
            subtitle: 'View all registered records and results',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentsListScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.upload_file_rounded,
            title: 'Upload Results',
            subtitle: 'Bulk-import a results spreadsheet (CSV)',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminUploadResultsScreen()),
            ),
          ),
        ];
      case AppRole.teacher:
        return [
          _ActionCard(
            icon: Icons.school_rounded,
            title: 'Student Records',
            subtitle: 'Review student records and academic progress',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentsListScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.bar_chart_rounded,
            title: 'Results Review',
            subtitle: 'Inspect results by term',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentsListScreen()),
            ),
          ),
        ];
      case AppRole.parent:
        return [
          _ActionCard(
            icon: Icons.person_rounded,
            title: 'My Child',
            subtitle: 'View your linked child profile and results',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentsListScreen()),
            ),
          ),
        ];
      case AppRole.student:
        return [
          _ActionCard(
            icon: Icons.grade_rounded,
            title: 'My Results',
            subtitle: 'View term-by-term grades and remarks',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StudentsListScreen()),
            ),
          ),
        ];
    }
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
