import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:seafood_b2b_app/features/auth/data/user_provider.dart';
import 'package:seafood_b2b_app/core/router/app_router.dart';
// import 'firebase_options.dart'; // Если будешь подключать Firebase
// import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Если будешь подключать Firebase, раскомментируй:
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter(ref).config,
    );
  }
}
