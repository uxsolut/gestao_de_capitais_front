import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';
import 'login_page.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _heroAnimationController;
  late AnimationController _statsAnimationController;
  late AnimationController _menuAnimationController;
  late Animation<double> _heroFadeAnimation;
  late Animation<double> _heroSlideAnimation;
  late Animation<double> _statsAnimation;
  late Animation<double> _menuRotationAnimation;
  late Animation<double> _menuSlideAnimation;
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();

    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _statsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _menuAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heroFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _heroSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _statsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _statsAnimationController,
      curve: Curves.elasticOut,
    ));

    _menuRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeInOut,
    ));

    _menuSlideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _heroAnimationController.forward();

    Timer(const Duration(milliseconds: 600), () {
      _statsAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    _statsAnimationController.dispose();
    _menuAnimationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });

    if (_isMenuOpen) {
      _menuAnimationController.forward();
    } else {
      _menuAnimationController.reverse();
    }

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMobileHeroSection(),
            _buildAnimatedStatsSection(),
            _buildMobileFeaturesSection(),
            _buildMobileHowItWorksSection(),
            _buildMobileAdvantagesSection(),
            _buildMobilePricingSection(),
            _buildMobileTestimonialsSection(),
            _buildMobileBlogSection(),
            _buildMobileContactSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeroSection() {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
            Color(0xFF0F0F0F),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                // Background particles
                ...List.generate(20, (index) => Positioned(
                  left: (index * 50.0) % MediaQuery.of(context).size.width,
                  top: (index * 80.0) % MediaQuery.of(context).size.height,
                  child: Container(
                    width: 2,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                )),

                // Main content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),

                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.trending_up,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'GESTOR DE CAPITAIS',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          AnimatedBuilder(
                            animation: _menuRotationAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _menuRotationAnimation.value * 2 * math.pi,
                                child: IconButton(
                                  onPressed: _toggleMenu,
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      // Menu Dropdown Animado
                      AnimatedBuilder(
                        animation: _menuSlideAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _menuSlideAnimation.value * 100),
                            child: Opacity(
                              opacity: _menuAnimationController.value,
                              child: _isMenuOpen ? Container(
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 0.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildMenuItem('Acessar', Icons.login),
                                    const SizedBox(height: 12),
                                    _buildMenuItem('Equipe', Icons.group),
                                    const SizedBox(height: 12),
                                    _buildMenuItem('Contratar', Icons.business_center),
                                    const SizedBox(height: 12),
                                    _buildMenuItem('Contato', Icons.contact_mail),
                                  ],
                                ),
                              ) : const SizedBox.shrink(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 80),

                      AnimatedBuilder(
                        animation: _heroAnimationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _heroFadeAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, _heroSlideAnimation.value),
                              child: Column(
                                children: [
                                  // Floating badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4F46E5).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.auto_awesome,
                                          color: Color(0xFF4F46E5),
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'IA de Nova Geração',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF4F46E5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 32),

                                  // Main title
                                  const Text(
                                    'GESTOR DE\nCAPITAIS',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.white,
                                      height: 1.1,
                                      letterSpacing: -1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 16),

                                  // Subtitle
                                  const Text(
                                    'IA de Gestão de Ativos',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF888888),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 24),

                                  // Description
                                  const Text(
                                    'Controle e transforme seus investimentos\ncom inteligência artificial avançada',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFCCCCCC),
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 40),

                                  // CTA Button
                                  Container(
                                    width: double.infinity,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        HapticFeedback.lightImpact();
                                        context.go('/login');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: const Text(
                                        'Começar Agora',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Secondary CTA
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Assistir Demo',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 60),

                                  // Floating dashboard preview
                                  _buildFloatingDashboard(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingDashboard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Performance Dashboard',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Mini chart
          Container(
            height: 180,
            width: double.infinity,
            child: CustomPaint(
              painter: MiniChartPainter(),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat('R\$ 2.4M', 'Capital', const Color(0xFF4F46E5)),
              _buildMiniStat('+18.5%', 'Retorno', const Color(0xFF10B981)),
              _buildMiniStat('127', 'Robôs', const Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF888888),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedStatsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      color: const Color(0xFF0F0F0F),
      child: AnimatedBuilder(
        animation: _statsAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.8 + (_statsAnimation.value * 0.2),
            child: Opacity(
              opacity: _statsAnimation.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAnimatedStatCard('R\$ 2.8B', 'Capital Gerenciado', const Color(0xFF4F46E5)),
                  _buildAnimatedStatCard('99.7%', 'Uptime', const Color(0xFF10B981)),
                  _buildAnimatedStatCard('15K+', 'Usuários Ativos', const Color(0xFFF59E0B)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 0.3,
              ),
            ),
            child: Icon(
              color == const Color(0xFF4F46E5) ? Icons.account_balance_wallet :
              color == const Color(0xFF10B981) ? Icons.verified :
              Icons.people,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF888888),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFeaturesSection() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
    color: const Color(0xFF0A0A0A),
    child: Column(
      children: [
        const Text(
          'Funcionalidades Avançadas',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 50),

        _buildMobileFeatureCard(
          'Gestão Global',
          'Globalize seus investimentos! Disponível em mais de 195 países.',
          Icons.public,
          const Color(0xFF4F46E5),
        ),

        const SizedBox(height: 24),

        _buildMobileFeatureCard(
          'Gestão Centralizada',
          'Em uma única central monitore e gerencie seus investimentos ao redor do mundo.',
          Icons.hub,
          const Color(0xFF10B981),
        ),

        const SizedBox(height: 24),

        _buildMobileFeatureCard(
          'Notícias em tempo real',
          'Central de chat e notícias ao vivo.',
          Icons.newspaper,
          const Color(0xFFF59E0B),
        ),
      ],
    ),
  );
}

  Widget _buildMobileFeatureCard(String title, String description, IconData icon, Color color) {
  return SizedBox(
    width: double.infinity,
    height: 220,
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 0.2,
              ),
            ),
            child: Icon(icon, color: color, size: 32),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF888888),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

  Widget _buildMobileHowItWorksSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      color: const Color(0xFF0F0F0F),
      child: Column(
        children: [
          const Text(
            'Como Funciona',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 50),
          
          _buildMobileStepCard(1, 'Conecte suas Contas', 'Integre suas corretoras e exchanges de forma segura.', Icons.link),
          _buildMobileStepCard(2, 'Configure Estratégias', 'Defina parâmetros e objetivos para seus robôs de IA.', Icons.settings),
          _buildMobileStepCard(3, 'Monitore Resultados', 'Acompanhe performance e ajuste estratégias em tempo real.', Icons.trending_up),
        ],
      ),
    );
  }

  Widget _buildMobileStepCard(int step, String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF888888),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAdvantagesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      color: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          const Text(
            'Vantagens Competitivas',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 50),
          
          _buildMobileAdvantageItem(
            'Estratégias Validadas',
            'Estratégias cuidadosamente desenvolvidas e validadas individualmente para cada ativo, considerando seu comportamento e características específicas.',
            Icons.psychology,
          ),
          _buildMobileAdvantageItem(
            'Ensaio de Robustez',
            'Simulações com variações extremas de mercado para testar resiliência da estratégia diante de condições adversas e cenários imprevisíveis.',
            Icons.flash_on,
          ),
          _buildMobileAdvantageItem(
            'Capital Protegido',
            'Seu patrimônio permanece seguro e inacessível, sem qualquer exposição ou risco de manuseio por terceiros.',
            Icons.shield,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAdvantageItem(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF4F46E5), size: 24),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF888888),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePricingSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      color: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          const Text(
            'Plano Profissional',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Solução completa para gestão profissional de ativos',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF888888),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 50),
          
          // Card único do Plano Profissional
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF4F46E5).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Badge "Recomendado"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'RECOMENDADO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Título do plano
                const Text(
                  'Profissional',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Preço
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'R\$',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                    const Text(
                      ' 1.500',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      '/mês',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Features
                Column(
                  children: [
                    _buildFeatureItem('+250 robôs ativos', Icons.smart_toy),
                    _buildFeatureItem('Plataforma de controle personalizada', Icons.dashboard_customize),
                    _buildFeatureItem('Alertas e monitoramento da carteira', Icons.notifications_active),
                    _buildFeatureItem('Suporte prioritário 24/7', Icons.support_agent),
                    _buildFeatureItem('API completa para integração', Icons.api),
                    _buildFeatureItem('Relatórios avançados em tempo real', Icons.analytics),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.go('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Começar Agora',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  'Sem compromisso • Cancele quando quiser',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF888888),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: const Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTestimonialsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      color: const Color(0xFF0F0F0F),
      child: Column(
        children: [
          const Text(
            'Casos de Sucesso',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 50),
          
          _buildMobileTestimonialCard(
            'Marina Silva',
            'Head of Trading, Quantum Capital',
            'O Gestor de Capitais transformou nossa operação. Aumentamos nossa eficiência em 340% e reduzimos riscos significativamente.',
            '+340% eficiência',
            const Color(0xFF10B981),
          ),
          
          const SizedBox(height: 24),
          
          _buildMobileTestimonialCard(
            'Carlos Mendes',
            'CTO, InvestTech Solutions',
            'A integração foi perfeita e os resultados superaram todas as expectativas. ROI de 280% no primeiro trimestre.',
            '+280% ROI',
            const Color(0xFF4F46E5),
          ),
          
          const SizedBox(height: 24),
          
          _buildMobileTestimonialCard(
            'Ana Costa',
            'Portfolio Manager, Alpha Funds',
            'Nunca vi uma plataforma tão intuitiva e poderosa. Nossos clientes estão extremamente satisfeitos com os resultados.',
            '99.2% satisfação',
            const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTestimonialCard(String name, String role, String testimonial, String metric, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Métrica em destaque
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              metric,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Depoimento
          Text(
            '"$testimonial"',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Nome e cargo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                role,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBlogSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      color: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          const Text(
            'Conteúdos Educativos',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 50),
          
          _buildMobileBlogCard(
            'Estratégias de Trading Automatizado',
            'Descubra as melhores práticas para maximizar seus resultados com robôs de investimento.',
            '5 min de leitura',
            const Color(0xFF4F46E5),
          ),
          
          const SizedBox(height: 24),
          
          _buildMobileBlogCard(
            'Gestão de Risco em IA Financeira',
            'Como implementar controles eficazes para proteger seu capital em operações automatizadas.',
            '8 min de leitura',
            const Color(0xFF10B981),
          ),
          
          const SizedBox(height: 24),
          
          _buildMobileBlogCard(
            'Tendências do Mercado 2024',
            'Análise completa das oportunidades e desafios para investidores que usam IA.',
            '12 min de leitura',
            const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBlogCard(String title, String description, String readTime, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              readTime,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF888888),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileContactSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      color: const Color(0xFF0F0F0F),
      child: Column(
        children: [
          const Text(
            'Entre em Contato',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 50),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.2)),
            ),
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Seu nome',
                    hintStyle: const TextStyle(color: Color(0xFF888888)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Seu email',
                    hintStyle: const TextStyle(color: Color(0xFF888888)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                TextField(
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Sua mensagem',
                    hintStyle: const TextStyle(color: Color(0xFF888888)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Enviar Mensagem',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _toggleMenu(); // Fecha o menu ao clicar
              _navigateToPage(title);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white.withOpacity(0.9),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isHovered ? Colors.white : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToPage(String pageName) {
    // Navegação implementada
    switch (pageName) {
      case 'Acessar':
        context.go('/login');
        break;
      case 'Começar Agora':
        context.go('/login');
        break;
      case 'Equipe':
        context.go('/login');
        break;
      case 'Contratar':
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ContractPage()));
        break;
      case 'Contato':
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage()));
        break;
    }
  }
}

class MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4F46E5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Simple upward trending line
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.7),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width, size.height * 0.2),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
