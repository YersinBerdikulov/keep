import 'package:dongi/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'core/constants/color_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'shared/utilities/logger/state_logger.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "hero",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      observers: [StateLogger()],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: ColorConfig.primarySwatch,
        scaffoldBackgroundColor: ColorConfig.white,
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
