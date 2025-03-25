import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:seafood_b2b_app/features/auth/data/user_provider.dart';
import 'package:seafood_b2b_app/features/orders/data/order_provider.dart';
import 'package:seafood_b2b_app/features/orders/screens/order_details_screen.dart'; // 👈 импорт экрана

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Пользователь не авторизован')),
      );
    }

    final ordersAsync = ref.watch(orderListProvider(user.email));

    return Scaffold(
      appBar: AppBar(title: const Text('Мои заказы')),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('Нет заказов'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final formattedDate = order.dateCreated != null
                  ? DateFormat('dd.MM.yyyy').format(order.dateCreated!)
                  : 'Неизвестно';

              return ListTile(
                title: Text('Заказ #${order.id}'),
                subtitle:
                    Text('Статус: ${order.status}\nСумма: ${order.total} €'),
                trailing: Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsScreen(order: order),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
