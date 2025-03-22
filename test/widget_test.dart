import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seafood_b2b_app/app.dart'; // Импортируем MyApp

void main() {
  testWidgets('Тест: отображение экрана входа', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(), // Используем MyApp, как в app.dart
      ),
    );

    // Проверяем наличие текстов на экране входа
    expect(find.text('Вход'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Пароль'), findsOneWidget);
    expect(find.text('Войти'), findsOneWidget);
  });
}
