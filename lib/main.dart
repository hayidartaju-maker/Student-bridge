import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/app_provider.dart';
import 'services/storage_service.dart';
import 'services/supabase_service.dart';
import 'screens/splash_screen.dart';
import 'screens/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();
  await SupabaseService.init(); // reads lib/core/constants.dart
  runApp(const BoardingBridgeApp());
}

class BoardingBridgeApp extends StatelessWidget {
  const BoardingBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()
        ..loadTheme()
        ..loadSession(),
      child: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'Boarding Bridge',
            debugShowCheckedModeBanner: false,
            themeMode: provider.themeMode,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: const _AppEntry(),
          );
        },
      ),
    );
  }
}

// ── Entry point — shows splash then main scaffold ─────────────────────────
class _AppEntry extends StatefulWidget {
  const _AppEntry();

  @override
  State<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<_AppEntry> {
  bool _splashDone = false;

  @override
  Widget build(BuildContext context) {
    if (!_splashDone) {
      return SplashScreen(onEnter: () => setState(() => _splashDone = true));
    }
    return const MainScaffold();
  }
}
