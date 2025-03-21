import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'data/user_model.dart';
import 'data/user_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Пароль'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Простой фейковый вход
                final email = emailController.text;
                final isB2B = email.contains('b2b');
                final role = isB2B ? UserRole.b2b : UserRole.b2c;

                final user = UserModel(email: email, role: role);
                ref.read(userProvider.notifier).state = user;

                context.go('/home');
              },
              child: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
