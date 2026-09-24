import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_roles.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';
import 'registration_screen.dart';
import 'students_list_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final role = provider.selectedRole ?? AppRole.admin;

    final pages = <Widget>[
      HomeScreen(role: role),
      const StudentsListScreen(),
      const RegistrationScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      floatingActionButton: _index == 0 && role == AppRole.admin
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => _index = 2),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Register'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups_rounded),
            label: 'Students',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add_alt_1_outlined),
            selectedIcon: Icon(Icons.person_add_alt_1_rounded),
            label: 'Register',
          ),
        ],
      ),
      persistentFooterButtons: null,
    );
  }
}
