import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/login_controller.dart';
import '../../services/ordem_service.dart';
import '../../models/ordem_models.dart';
import 'package:intl/intl.dart';

class AdminOrdensPage extends StatefulWidget {
  const AdminOrdensPage({super.key});

  @override
  State<AdminOrdensPage> createState() => _AdminOrdensPageState();
}

class _AdminOrdensPageState extends State<AdminOrdensPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  final OrdemService _ordemService = OrdemService();
  List<Ordem> _ordens = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  final _comentarioController = TextEditingController();
  final _numeroUnicoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _precoController = TextEditingController();
  final _contaController = TextEditingController();
  final _tipoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
    _loadOrdens();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _comentarioController.dispose();
    _numeroUnicoController.dispose();
    _quantidadeController.dispose();
    _precoController.dispose();
    _contaController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  Future<void> _loadOrdens() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ordens = await _ordemService.getOrdens();
      
      setState(() {
        _ordens = ordens;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createOrdem() async {
    if (_comentarioController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um comentário para a ordem'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final loginController = Provider.of<LoginController>(context, listen: false);
      final userId = loginController.currentUser?.user.id;

      final ordemCreate = OrdemCreate(
        comentarioOrdem: _comentarioController.text.trim(),
        idUser: userId,
        numeroUnico: _numeroUnicoController.text.trim().isNotEmpty 
            ? _numeroUnicoController.text.trim() 
            : null,
        quantidade: _quantidadeController.text.trim().isNotEmpty 
            ? int.tryParse(_quantidadeController.text.trim()) 
            : null,
        preco: _precoController.text.trim().isNotEmpty 
            ? double.tryParse(_precoController.text.trim()) 
            : null,
        contaMetaTrader: _contaController.text.trim().isNotEmpty 
            ? _contaController.text.trim() 
            : null,
        tipo: _tipoController.text.trim().isNotEmpty 
            ? _tipoController.text.trim() 
            : null,
      );

      await _ordemService.createOrdem(ordemCreate);
      
      _clearForm();
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ordem criada com sucesso!'),
          backgroundColor: Color(0xFF34a853),
        ),
      );
      
      _loadOrdens();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao criar ordem: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearForm() {
    _comentarioController.clear();
    _numeroUnicoController.clear();
    _quantidadeController.clear();
    _precoController.clear();
    _contaController.clear();
    _tipoController.clear();
  }

  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(isMobile),
                SizedBox(height: isMobile ? 16 : 24),
                
                // Content
                Expanded(
                  child: _buildContent(isMobile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Ordens',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => _loadOrdens(),
              icon: const Icon(Icons.refresh, color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(bool isMobile) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4285f4)),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar ordens',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadOrdens,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285f4),
              ),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_ordens.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma ordem encontrada',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Crie sua primeira ordem clicando no botão +',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: _buildOrdensList(isMobile),
    );
  }

  Widget _buildOrdensList(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2d2d2d),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ordens de Trading (${_ordens.length})',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Total: ${_ordens.length} ordem${_ordens.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ..._ordens.map((ordem) => _buildOrdemItem(ordem, isMobile)),
        ],
      ),
    );
  }

  Widget _buildOrdemItem(Ordem ordem, bool isMobile) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 20,
        vertical: 8,
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF4285f4).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ordem.comentarioOrdem,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${ordem.id}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF34a853).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ordem.tipo ?? 'N/A',
                  style: const TextStyle(
                    color: Color(0xFF34a853),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Detalhes da ordem
          if (ordem.numeroUnico != null) ...[
            _buildDetailRow('Número Único', ordem.numeroUnico!, Icons.tag),
            const SizedBox(height: 8),
          ],
          
          if (ordem.quantidade != null) ...[
            _buildDetailRow('Quantidade', ordem.quantidade.toString(), Icons.numbers),
            const SizedBox(height: 8),
          ],
          
          if (ordem.preco != null) ...[
            _buildDetailRow('Preço', 'R\$ ${ordem.preco!.toStringAsFixed(2)}', Icons.attach_money),
            const SizedBox(height: 8),
          ],
          
          if (ordem.contaMetaTrader != null) ...[
            _buildDetailRow('Conta MT', ordem.contaMetaTrader!, Icons.account_balance),
            const SizedBox(height: 8),
          ],
          
          if (ordem.idUser != null) ...[
            _buildDetailRow('Usuário', 'ID: ${ordem.idUser}', Icons.person),
            const SizedBox(height: 8),
          ],
          
          // Data de criação
          if (ordem.criadoEm != null) ...[
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Criado em: ${dateFormat.format(ordem.criadoEm!)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF4285f4),
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  void _showAddOrdemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d2d),
        title: const Text(
          'Nova Ordem',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_comentarioController, 'Comentário da Ordem *', Icons.comment),
              const SizedBox(height: 16),
              _buildTextField(_numeroUnicoController, 'Número Único', Icons.tag),
              const SizedBox(height: 16),
              _buildTextField(_quantidadeController, 'Quantidade', Icons.numbers, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(_precoController, 'Preço', Icons.attach_money, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(_contaController, 'Conta MetaTrader', Icons.account_balance),
              const SizedBox(height: 16),
              _buildTextField(_tipoController, 'Tipo', Icons.category),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearForm();
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _createOrdem,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4285f4),
            ),
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF1a1a1a),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4285f4)),
        ),
      ),
    );
  }
}