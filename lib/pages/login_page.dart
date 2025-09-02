import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_request_models.dart';
import '../models/login_response_models.dart';
import '../services/login_service.dart';
import '../controllers/login_controller.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'package:go_router/go_router.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    
  );

  final _loginService = LoginService();
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeOut,
    ));
    
    _fadeAnimationController.forward();

    if (kIsWeb) {
    html.window.addEventListener('google-signin', (event) {
      final credential = (event as html.CustomEvent).detail;
      _showSnackBar('Login Google Web JWT recebido!');
      // Aqui você pode enviar o credential para o backend ou salvar no storage
      print("Google JWT: $credential");
    });
  }
}

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        
                        // Header com botão voltar
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                context.go('/');
                                HapticFeedback.lightImpact();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const Spacer(),
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
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'GESTOR DE CAPITAIS',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 60),
                        
                        // Título da página
                        const Text(
                          'Bem-vindo de volta',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        const Text(
                          'Acesse sua conta para continuar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF888888),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 50),
                        
                        // Formulário de login
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Campo Email
                              const Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'seu@email.com',
                                  hintStyle: const TextStyle(color: Color(0xFF666666)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.08),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4F46E5),
                                      width: 1,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 20,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Campo Senha
                              const Text(
                                'Senha',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: const TextStyle(color: Color(0xFF666666)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.08),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF4F46E5),
                                      width: 1,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 20,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                      HapticFeedback.lightImpact();
                                    },
                                    icon: Icon(
                                      _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: Colors.white.withOpacity(0.7),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Esqueci minha senha
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    // TODO: Implementar recuperação de senha
                                  },
                                  child: const Text(
                                    'Esqueci minha senha',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4F46E5),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Botão Entrar
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4F46E5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Entrar',
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
                        
                        const SizedBox(height: 32),
                        
                        // Divisor
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 0.5,
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'ou continue com',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF888888),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 0.5,
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Botões de login social
                        Row(
  children: [
    // Google
    Expanded(
      child: kIsWeb
        ? const SizedBox(
            height: 50,
            child: HtmlElementView(viewType: 'google-signin-button'),
          )
        : _buildSocialButton(
            'Google',
            Icons.g_mobiledata,
            _handleGoogleSignIn,
          ),
    ),
    const SizedBox(width: 16),
    // Apple
    Expanded(
      child: _buildSocialButton(
        'Apple',
        Icons.apple,
        () => _handleSocialLogin('Apple'),
      ),
    ),
  ],
),

                        
                        const SizedBox(height: 40),
                        
                        // Link para cadastro
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Não tem uma conta? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF888888),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                // TODO: Navegar para tela de cadastro
                              },
                              child: const Text(
                                'Cadastre-se',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4F46E5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, VoidCallback onPressed) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _showSnackBar('Bem-vindo, ${account.displayName ?? account.email}');
        // Aqui você pode fazer um POST para seu backend, se desejar
      }
    } catch (error) {
      _showSnackBar('Erro ao logar com Google');
    }
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final senha = _passwordController.text;

    if (email.isEmpty || senha.isEmpty) {
      return _showSnackBar('Por favor, preencha todos os campos');
    }

    setState(() => _isLoading = true);

    try {
      // Usar o LoginController em vez de chamar o service diretamente
      final loginController = Provider.of<LoginController>(context, listen: false);
      final success = await loginController.login(email, senha);

      if (success && loginController.currentUser != null) {
        _showSnackBar('Login bem-sucedido, bem-vindo ${loginController.currentUser!.user.nome}!');

        // Navegar após um breve delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        
        // Verificar tipo de usuário e redirecionar para a área correta
        final tipoDeUser = loginController.currentUser?.user.tipoDeUser?.toLowerCase();
        
        if (tipoDeUser == 'admin') {
  context.go('/admin');
} else if (tipoDeUser == 'cliente') {
  context.go('/cliente/dashboard');
}

      } else {
        _showSnackBar(loginController.errorMessage ?? 'Erro desconhecido');
      }
    } catch (e) {
      _showSnackBar('Falha ao autenticar: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleSocialLogin(String provider) {
    HapticFeedback.lightImpact();
    _showSnackBar('Login com $provider em desenvolvimento');
    // TODO: Implementar login social
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4F46E5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
