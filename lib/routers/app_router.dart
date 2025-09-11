// lib/routers/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// -------- Páginas públicas --------
import '../pages/home_page.dart';
import '../pages/login_page.dart';

// -------- Cliente (mantido intacto) --------
import '../pages/cliente/cliente_dashboard_page.dart';
import '../pages/cliente/cliente_carteiras_page.dart';
import '../pages/cliente/cliente_contas_page.dart';
import '../pages/cliente/trading_bot_page.dart';

// Widget compartilhado do cliente (menu inferior)
import '../widgets/menu_inferior.dart';

// -------- Admin (novas rotas) --------
import '../pages/admin/admin_main_app.dart';
import '../pages/admin/admin_estrategias_page.dart';
import '../pages/admin/admin_corretoras_page.dart';
import '../pages/admin/admin_ordens_page.dart';
import '../pages/admin/admin_perfil_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Página inicial
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),

    // Página de login
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),

    // =================== ROTAS DO CLIENTE (mantidas) ===================
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
          name: 'cliente.dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClienteDashboardPage(),
          ),
        ),
        GoRoute(
          path: '/cliente/carteiras',
          name: 'cliente.carteiras',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClienteCarteirasPage(),
          ),
        ),
        // Rota dinâmica para CONTAS da carteira
        GoRoute(
          path: '/cliente/contas/:id',
          name: 'cliente.contas',
          pageBuilder: (context, state) {
            final carteiraId = state.pathParameters['id']!;
            return NoTransitionPage(
              child: ClienteContasPage(carteiraId: carteiraId),
            );
          },
        ),
        // Trading Bot dentro do Shell + recebendo ID do robô
        GoRoute(
          name: 'cliente.tradingBot',
          path: '/cliente/trading-bot/:id',
          pageBuilder: (context, state) => NoTransitionPage(
            child: TradingBotPage(
              idRobo: state.pathParameters['id']!,
            ),
          ),
        ),
        // (Opcional) mantenha se você tiver essa tela específica
        GoRoute(
          path: '/cliente/estrategias',
          name: 'cliente.estrategias',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClienteDashboardPage(), // troque se houver página própria
          ),
        ),
      ],
    ),

    // =================== ROTAS DO ADMIN (novas) ===================
    GoRoute(
      path: '/admin',
      name: 'admin.home',
      builder: (context, state) => const AdminMainApp(),
    ),
    GoRoute(
      path: '/admin/estrategias',
      name: 'admin.estrategias',
      builder: (context, state) => const AdminEstrategiasPage(),
    ),
    GoRoute(
      path: '/admin/corretoras',
      name: 'admin.corretoras',
      builder: (context, state) => const AdminCorretorasPage(),
    ),
    GoRoute(
      path: '/admin/ordens',
      name: 'admin.ordens',
      builder: (context, state) => const AdminOrdensPage(),
    ),
    GoRoute(
      path: '/admin/perfil',
      name: 'admin.perfil',
      builder: (context, state) => const AdminPerfilPage(),
    ),
  ],
);
