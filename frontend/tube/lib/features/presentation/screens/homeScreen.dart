import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tube/features/auth/data/authSessions/auth_sessions_provider.dart';

class Homescreen extends ConsumerWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authSessionsProvider.notifier).logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.push('/product/123');
          },
          child: Text('open product 123'),
        ),
      ),
    );
  }
}
