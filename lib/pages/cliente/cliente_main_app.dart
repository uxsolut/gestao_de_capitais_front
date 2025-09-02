import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../login_page.dart';
import 'cliente_dashboard_page.dart';
import 'cliente_carteiras_page.dart';
import 'cliente_ordens_page.dart';
import 'cliente_perfil_page.dart';
import '../../widgets/menu_inferior.dart';

class ClienteMainApp extends StatefulWidget {
  const ClienteMainApp({super.key});

  @override
  State<ClienteMainApp> createState() => _ClienteMainAppState();
}

class _ClienteMainAppState extends State<ClienteMainApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ClienteDashboardPage(),
    ClienteCarteirasPage(),
    ClientePerfilPage(),
  ];

  @override
  void initState() {
    super.initState();

    // Inicia o index com base na rota atual
    final location = GoRouterState.of(context).uri.toString();
    _currentIndex = _getIndexFromLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: MenuInferiorCliente(
        currentIndex: _currentIndex,
        onTap: (index) => _handleNavigation(context, index),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _showDashboardMenu,
      backgroundColor: const Color(0xFF4285f4),
      child: const Icon(Icons.menu),
    );
  }

  void _showDashboardMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2d2d2d),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Menu Dashboard Cliente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.account_balance,
              title: 'Contas Cliente',
              onTap: () {
                Navigator.pop(context);
                context.go('/cliente/contas');
              },
            ),
            _buildMenuOption(
              icon: Icons.receipt,
              title: 'Notas Fiscais Cliente',
              onTap: () {
                Navigator.pop(context);
                context.go('/cliente/notasfiscais');
              },
            ),
            _buildMenuOption(
              icon: Icons.person,
              title: 'Perfil Cliente',
              onTap: () {
                setState(() => _currentIndex = 3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4285f4)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      hoverColor: Colors.white10,
    );
  }

  int _getIndexFromLocation(String location) {
    if (location.contains('/cliente/carteiras')) return 1;
    if (location.contains('/cliente/estrategias')) return 2;
    if (location.contains('/cliente/perfil')) return 3;
    return 0;
  }

  void _handleNavigation(BuildContext context, int index) {
    setState(() => _currentIndex = index);
    // opcionalmente, você pode sincronizar a URL com GoRouter se quiser
  }
}
