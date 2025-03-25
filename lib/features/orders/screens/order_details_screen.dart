import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seafood_b2b_app/features/orders/data/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate = order.dateCreated != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(order.dateCreated!)
        : 'Неизвестно';

    return Scaffold(
      appBar: AppBar(title: Text('Заказ #${order.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Дата: $formattedDate'),
            const SizedBox(height: 8),
            Text('Статус: ${order.status}'),
            const SizedBox(height: 8),
            Text('Сумма: ${order.total} €'),
            const SizedBox(height: 16),
            const Text('Товары:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Количество: ${item.quantity}'),
                    trailing: Text('${item.total} €'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
