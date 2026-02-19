import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'core/security/app_security.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Secure the screen immediately after initialization
    await AppSecurity.secureScreen();
  } catch (e) {
    debugPrint("Initialization failed: $e");
    // In a real app, we might want to show an error screen here
  }

  runApp(
    const ProviderScope(
      child: ChaltaPayApp(),
    ),
  );
}
