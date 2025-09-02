import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importação das páginas
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/cliente/cliente_dashboard_page.dart';
import '../pages/cliente/cliente_carteiras_page.dart';
import '../pages/cliente/cliente_contas_page.dart';
import '../pages/cliente/trading_bot_page.dart';

// Widget compartilhado
import '../widgets/menu_inferior.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Página inicial
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),

    // Página de login
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    // Rotas do cliente com Shell (menu inferior fixo)
    ShellRoute(
      builder: (context, state, child) {
        final location = state.uri.toString();
        int currentIndex = 0;

        if (location.startsWith('/cliente/carteiras') || location.startsWith('/cliente/contas')) {
          currentIndex = 1;
        } else if (location.startsWith('/cliente/estrategias')) {
          currentIndex = 2;
        }
        // Para /cliente/trading-bot, deixamos o índice 0 (Dashboard) por padrão.

        return Scaffold(
          backgroundColor: const Color(0xFF1a1a1a),
          body: child,
          bottomNavigationBar: MenuInferiorCliente(
            currentIndex: currentIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/cliente/dashboard');
                  break;
                case 1:
                  context.go('/cliente/carteiras');
                  break;
                case 2:
                  context.go('/cliente/estrategias');
                  break;
              }
            },
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/cliente/dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClienteDashboardPage(),
          ),
        ),
        GoRoute(
          path: '/cliente/carteiras',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClienteCarteirasPage(),
          ),
        ),
        // Rota dinâmica para CONTAS da carteira
        GoRoute(
          path: '/cliente/contas/:id',
          pageBuilder: (context, state) {
            final carteiraId = state.pathParameters['id']!;
            return NoTransitionPage(
              child: ClienteContasPage(carteiraId: carteiraId),
            );
          },
        ),
        // ✅ Trading Bot dentro do Shell + recebendo ID do robô
        GoRoute(
          name: 'tradingBot',
          path: '/cliente/trading-bot/:id',
          pageBuilder: (context, state) => NoTransitionPage(
            child: TradingBotPage(
              idRobo: state.pathParameters['id']!, // <-- pega o ID da URL
            ),
          ),
        ),
      ],
    ),
  ],
);
