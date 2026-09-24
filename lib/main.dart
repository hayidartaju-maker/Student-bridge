import 'package:flutter/material.dart';
import 'screens/browser_mockup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BoardingBridgeApp());
}

class BoardingBridgeApp extends StatelessWidget {
  const BoardingBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BrowserMockupScreen(),
    );
  }
}
