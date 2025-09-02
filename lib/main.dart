import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/dashboard_controller.dart' as cliente;
import 'controllers/login_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/cliente_carteiras_controller.dart';

import 'themes/theme.dart';
import 'routers/app_router.dart'; // ÚNICA fonte do appRouter

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<cliente.DashboardController>(
          create: (_) => cliente.DashboardController(),
        ),
        ChangeNotifierProvider<LoginController>(
          create: (_) {
            final login = LoginController();
            login.initialize();
            return login;
          },
        ),
        ChangeNotifierProvider<HomeController>(
          create: (_) => HomeController(),
        ),
        ChangeNotifierProvider<ThemeController>(
          create: (_) => ThemeController(),
        ),
        ChangeNotifierProvider<ClienteCarteirasController>(
          create: (_) => ClienteCarteirasController(),
        ),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp.router(
            title: 'Trading Dashboard',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            routerConfig: appRouter, // GoRouter por URL
          );
        },
      ),
    );
  }
}
