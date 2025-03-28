import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();

  @override
  void dispose() {
    _oldPass.dispose();
    _newPass.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пароль обновлён (фиктивно)')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сменить пароль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPass,
                decoration: const InputDecoration(labelText: 'Старый пароль'),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Введите пароль' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPass,
                decoration: const InputDecoration(labelText: 'Новый пароль'),
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Мин. 6 символов'
                    : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Обновить пароль'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
