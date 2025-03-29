import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seafood_b2b_app/features/cart/data/cart_provider.dart';
import 'package:seafood_b2b_app/features/orders/data/order_repository.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  static const _keyFullName = 'user_full_name';
  static const _keyEmail = 'user_email';

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadSavedUserData();
  }

  Future<void> _loadSavedUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString(_keyFullName) ?? '';
    _emailController.text = prefs.getString(_keyEmail) ?? '';
  }

  Future<void> _saveUserData(String fullName, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFullName, fullName);
    await prefs.setString(_keyEmail, email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    final total = cart.fold<double>(
      0,
      (sum, item) => sum + item.quantity * item.product.price,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Оформление заказа')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              const Text(
                'Контактные данные',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Имя и фамилия'),
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Введите имя и фамилию'
                    : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите email';
                  }
                  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Неверный формат email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Телефон'),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.telephoneNumber],
                validator: (value) {
                  final phoneRegex = RegExp(r'^\+?\d{8,15}$');
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите номер телефона';
                  }
                  if (!phoneRegex.hasMatch(value.trim())) {
                    return 'Введите корректный номер (8–15 цифр)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Итого: ${total.toStringAsFixed(2)} €',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() => _isSubmitting = true);

                        final fullName = _nameController.text.trim();
                        final email = _emailController.text.trim();
                        final phone = _phoneController.text.trim();

                        final parts = fullName.split(' ');
                        final firstName = parts.isNotEmpty ? parts.first : '';
                        final lastName =
                            parts.length > 1 ? parts.sublist(1).join(' ') : '';

                        await _saveUserData(fullName, email);

                        try {
                          final order = await OrderRepository().createOrder(
                            cart,
                            billing: {
                              'first_name': firstName,
                              'last_name': lastName,
                              'email': email,
                              'phone': phone,
                            },
                          );

                          cartNotifier.clearCart();

                          if (!mounted) return;

                          /// 👇 Переход на Главную с очисткой стека
                          context.go('/home');
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Ошибка при заказе: ${e.toString()}'),
                            ),
                          );
                        } finally {
                          if (mounted) {
                            setState(() => _isSubmitting = false);
                          }
                        }
                      },
                child: const Text('Подтвердить заказ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
