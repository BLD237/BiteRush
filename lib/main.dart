import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/core/providers/app_startup_provider.dart';
import 'package:food_delivery/core/routes/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStartupProvider()..initialize(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'BiteRush',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
