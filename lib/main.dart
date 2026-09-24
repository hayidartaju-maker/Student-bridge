import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/app_provider.dart';
import 'services/storage_service.dart';
import 'services/supabase_service.dart';
import 'screens/splash_screen.dart';
import 'screens/main_scaffold.dart';
import 'screens/role_selection_screen.dart';
import 'screens/entry_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();
  Object? startupError;
  try {
    await SupabaseService.init();
  } catch (error) {
    startupError = error;
  }
  runApp(BoardingBridgeApp(startupError: startupError));
}

class BoardingBridgeApp extends StatelessWidget {
  final Object? startupError;
  const BoardingBridgeApp({super.key, this.startupError});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..loadTheme()..loadSession()..loadRole(),
      child: Consumer<AppProvider>(
        builder: (context, provider, _) => MaterialApp(
          title: 'Boarding Bridge',
          debugShowCheckedModeBanner: false,
          themeMode: provider.themeMode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: startupError == null ? const _AppEntry() : StartupErrorScreen(error: startupError!),
        ),
      ),
    );
  }
}

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
    return const EntryScreen();
  }
}

class StartupErrorScreen extends StatelessWidget {
  final Object error;
  const StartupErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_rounded, size: 56),
                const SizedBox(height: 16),
                const Text('Unable to start Boarding Bridge', textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('$error', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
}
