import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/router/router.dart';
import 'core/theme/theme.dart';

class ChaltaPayApp extends ConsumerWidget {
  const ChaltaPayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'ChaltaPay',
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
