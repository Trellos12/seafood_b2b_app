import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seafood_b2b_app/features/auth/data/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Добро пожаловать!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (user.email != null)
              Text(
                '📧 Email: ${user.email}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.lock_reset),
              title: const Text('Сменить пароль'),
              onTap: () {
                context.push('/change-password');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Выйти'),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
