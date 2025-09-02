/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/navegacao_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../home_page.dart';
import '../login_page.dart';
import 'admin_estrategias_page.dart';
import 'admin_ordens_page.dart';
import 'admin_perfil_page.dart';
import 'admin_corretoras_page.dart';

class AdminMainApp extends StatefulWidget {
  const AdminMainApp({super.key});

  @override
  State<AdminMainApp> createState() => _AdminMainAppState();
}

class _AdminMainAppState extends State<AdminMainApp> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
    
    // Garantir que sempre inicie na primeira aba (usuários) após login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = Provider.of<NavegacaoController>(context, listen: false);
      navController.mudarPara(EstadoNavegacao.dashboard);
      final dashController = Provider.of<DashboardController>(context, listen: false);
      dashController.navegarPara(ViewDashboard.usuarios);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavegacaoController, DashboardController>(
      builder: (context, navController, dashController, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1a1a1a),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildCurrentPage(navController, dashController),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(navController, dashController),
          floatingActionButton: _buildFloatingActionButton(navController, dashController),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  Widget _buildCurrentPage(NavegacaoController navController, DashboardController dashController) {
    // Se estiver na tela de login, não mostrar o menu inferior
    if (navController.estado == EstadoNavegacao.login) {
      return const LoginPage();
    }

    // Se estiver no dashboard, usar o controller do dashboard para navegação interna
    if (navController.estado == EstadoNavegacao.dashboard) {
      return _buildDashboardContent(dashController);
    }

    // Para outras telas principais
    switch (navController.estado) {
      case EstadoNavegacao.home:
        return const HomePage();
      case EstadoNavegacao.equipe:
        return _buildPlaceholderPage('Equipe Admin', Icons.group);
      case EstadoNavegacao.contratar:
        return _buildPlaceholderPage('Contratar Admin', Icons.shopping_cart);
      case EstadoNavegacao.contato:
        return _buildPlaceholderPage('Contato Admin', Icons.contact_mail);
      default:
        return const HomePage();
    }
  }
  
  Widget _buildDashboardContent(DashboardController dashController) {
    switch (dashController.currentView) {
      case ViewDashboard.usuarios:
        return _buildPlaceholderPage('Usuários Admin', Icons.people);
      case ViewDashboard.atendimentos:
        return _buildPlaceholderPage('Atendimentos Admin', Icons.support_agent);
      case ViewDashboard.estrategias:
        return const AdminEstrategiasPage();
      case ViewDashboard.corretoras:
        return const AdminCorretorasPage();
      case ViewDashboard.dashboard:
        return const AdminOrdensPage();
      case ViewDashboard.ordens:
        return const AdminOrdensPage();
      case ViewDashboard.perfil:
        return const AdminPerfilPage();
      case ViewDashboard.contas:
        return _buildPlaceholderPage('Contas Admin', Icons.account_balance);
      case ViewDashboard.noticias:
        return _buildPlaceholderPage('Notícias Admin', Icons.newspaper);
      default:
        return const AdminOrdensPage();
    }
  }

  Widget _buildPlaceholderPage(String title, IconData icon) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF2d2d2d),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: const Color(0xFF4285f4),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Área Administrativa - Em desenvolvimento...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildBottomNavigationBar(NavegacaoController navController, DashboardController dashController) {
    // Não mostrar menu inferior na tela de login
    if (navController.estado == EstadoNavegacao.login) {
      return null;
    }

    // Se estiver no dashboard, mostrar menu específico do dashboard
    if (navController.estado == EstadoNavegacao.dashboard) {
      return _buildDashboardBottomNav(dashController);
    }

    // Menu principal para outras telas
    return _buildMainBottomNav(navController);
  }

  Widget _buildMainBottomNav(NavegacaoController navController) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2d2d2d),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4285f4),
        unselectedItemColor: Colors.white54,
        currentIndex: _getMainNavIndex(navController.estado),
        onTap: (index) => _onMainNavTap(index, navController),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Equipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Contratar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Contato',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardBottomNav(DashboardController dashController) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2d2d2d),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4285f4),
        unselectedItemColor: Colors.white54,
        currentIndex: _getDashboardNavIndex(dashController.currentView),
        onTap: (index) => _onDashboardNavTap(index, dashController),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Usuários',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Atendimentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Estratégias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Corretoras',
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton(NavegacaoController navController, DashboardController dashController) {
    // Não mostrar FAB na tela de login
    if (navController.estado == EstadoNavegacao.login) {
      return null;
    }

    // Se estiver no dashboard, mostrar FAB específico
    if (navController.estado == EstadoNavegacao.dashboard) {
      return FloatingActionButton(
        onPressed: () => _showDashboardMenu(dashController),
        backgroundColor: const Color(0xFF4285f4),
        child: const Icon(Icons.menu),
      );
    }

    // FAB para outras telas
    return FloatingActionButton(
      onPressed: () => _showMainMenu(navController),
      backgroundColor: const Color(0xFF4285f4),
      child: const Icon(Icons.menu),
    );
  }

  int _getMainNavIndex(EstadoNavegacao estado) {
    switch (estado) {
      case EstadoNavegacao.home:
        return 0;
      case EstadoNavegacao.dashboard:
        return 1;
      case EstadoNavegacao.equipe:
        return 2;
      case EstadoNavegacao.contratar:
        return 3;
      case EstadoNavegacao.contato:
        return 4;
      default:
        return 0;
    }
  }

  int _getDashboardNavIndex(ViewDashboard view) {
    switch (view) {
      case ViewDashboard.usuarios:
        return 0;
      case ViewDashboard.atendimentos:
        return 1;
      case ViewDashboard.estrategias:
        return 2;
      case ViewDashboard.corretoras:
        return 3;
      default:
        return 0;
    }
  }

  void _onMainNavTap(int index, NavegacaoController navController) {
    switch (index) {
      case 0:
        navController.mudarPara(EstadoNavegacao.home);
        break;
      case 1:
        navController.mudarPara(EstadoNavegacao.dashboard);
        break;
      case 2:
        navController.mudarPara(EstadoNavegacao.equipe);
        break;
      case 3:
        navController.mudarPara(EstadoNavegacao.contratar);
        break;
      case 4:
        navController.mudarPara(EstadoNavegacao.contato);
        break;
    }
  }

  void _onDashboardNavTap(int index, DashboardController dashController) {
    switch (index) {
      case 0:
        dashController.navegarPara(ViewDashboard.usuarios);
        break;
      case 1:
        dashController.navegarPara(ViewDashboard.atendimentos);
        break;
      case 2:
        dashController.navegarPara(ViewDashboard.estrategias);
        break;
      case 3:
        dashController.navegarPara(ViewDashboard.corretoras);
        break;
    }
  }

  void _showMainMenu(NavegacaoController navController) {
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
              'Menu Admin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.login,
              title: 'Login',
              onTap: () {
                Navigator.pop(context);
                navController.mudarPara(EstadoNavegacao.login);
              },
            ),
            _buildMenuOption(
              icon: Icons.settings,
              title: 'Configurações Admin',
              onTap: () {
                Navigator.pop(context);
                // Implementar configurações admin
              },
            ),
            _buildMenuOption(
              icon: Icons.help,
              title: 'Ajuda Admin',
              onTap: () {
                Navigator.pop(context);
                // Implementar ajuda admin
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDashboardMenu(DashboardController dashController) {
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
              'Menu Dashboard Admin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.list_alt,
              title: 'Logs',
              onTap: () {
                Navigator.pop(context);
                // Implementar navegação para logs
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
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: Colors.white10,
    );
  }
}

*/