import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../payment/data/services/ussd_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ussdService = ref.watch(ussdServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChaltaPay'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                ussdService.dialUssd('*99#');
              },
              child: const Text('Test *99# USSD'),
            ),
            const SizedBox(height: 20),
            StreamBuilder<String>(
              stream: ussdService.ussdMessages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  );
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const Text('Waiting for USSD response...');
              },
            ),
          ],
        ),
      ),
    );
  }
}
