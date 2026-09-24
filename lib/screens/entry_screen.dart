import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_roles.dart';
import '../providers/app_provider.dart';
import 'main_scaffold.dart';
import 'role_selection_screen.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF132A3E), Color(0xFF2E8B8B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Boarding Bridge',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'One connected place for students, parents, teachers, and administrators.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFE0F1F1), fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  if (provider.selectedRole != null)
                    _EntryButton(
                      label: 'Enter ${provider.selectedRole!.label} portal',
                      icon: Icons.login_rounded,
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScaffold()),
                      ),
                    )
                  else
                    _EntryButton(
                      label: 'Enter the portal',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                      ),
                    ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () => _showAbout(context),
                    child: const Text(
                      'About Boarding Bridge',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Boarding Bridge',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.school_rounded),
      children: const [
        Text('A school and boarding management portal built with Flutter and Supabase.'),
      ],
    );
  }
}

class _EntryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _EntryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(label),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF132A3E),
        ),
      ),
    );
  }
}
