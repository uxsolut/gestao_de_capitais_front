import 'package:flutter/material.dart';
import '../../models/corretora_models.dart';
import '../../services/corretora_service.dart';
import '../../widgets/topo_fixo.dart';

class AdminCorretorasPage extends StatefulWidget {
  const AdminCorretorasPage({Key? key}) : super(key: key);

  @override
  State<AdminCorretorasPage> createState() => _AdminCorretorasPageState();
}

class _AdminCorretorasPageState extends State<AdminCorretorasPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final CorretoraService _service = CorretoraService();

  List<Corretora> _corretoras = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();

    _carregarCorretoras();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  Future<void> _carregarCorretoras() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final lista = await _service.listarCorretoras();
      setState(() {
        _corretoras = lista;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
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
                _buildHeader(isMobile),
                SizedBox(height: isMobile ? 16 : 24),
                Expanded(child: _buildContent(isMobile)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateCorretoraDialog,
        backgroundColor: const Color(0xFF4285f4),
        child: const Icon(Icons.add),
      ),
    );
  }

  // ===== Header sem seta =====
  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Corretoras',
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const TopoFixo(),
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
            Icon(Icons.error_outline,
                size: 64, color: Colors.red.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar corretoras',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _carregarCorretoras,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285f4)),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_corretoras.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.apartment_outlined,
                size: 64, color: Colors.white.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              'Nenhuma corretora cadastrada',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Use o botão + para criar a primeira corretora',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(child: _buildCorretorasList(isMobile));
  }

  Widget _buildCorretorasList(bool isMobile) {
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
                  'Corretoras (${_corretoras.length})',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Total: ${_corretoras.length} corretora${_corretoras.length != 1 ? 's' : ''}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ..._corretoras.map((c) => _buildCorretoraItem(c, isMobile)),
        ],
      ),
    );
  }

  Widget _buildCorretoraItem(Corretora c, bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20, vertical: 8),
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
          // Cabeçalho (nome + ações)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nome
              Expanded(
                child: Text(
                  c.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Ações
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: Colors.orangeAccent, size: 20),
                    tooltip: 'Editar corretora',
                    onPressed: () => _showEditarCorretoraDialog(c),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete,
                        color: Colors.redAccent, size: 20),
                    tooltip: 'Excluir corretora',
                    onPressed: () => _confirmarExclusaoCorretora(c.id, c.nome),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Linhas de detalhes
          if ((c.email ?? '').isNotEmpty) _linhaInfo(Icons.email, c.email!),
          if ((c.telefone ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _linhaInfo(Icons.phone, c.telefone!),
            ),
          if ((c.cnpj ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _linhaInfo(Icons.badge, c.cnpj!),
            ),
        ],
      ),
    );
  }

  Widget _linhaInfo(IconData icone, String texto) {
    return Row(
      children: [
        Icon(icone, size: 16, color: Colors.white70),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            texto,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Dialog: CRIAR
  void _showCreateCorretoraDialog() {
    final _formKey = GlobalKey<FormState>();
    final _nome = TextEditingController();
    final _cnpj = TextEditingController();
    final _telefone = TextEditingController();
    final _email = TextEditingController();
    bool _isCreating = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2d2d2d),
            title: const Text('Criar Nova Corretora',
                style: TextStyle(color: Colors.white)),
            content: SizedBox(
              width: 420,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _inputOutlined(
                      controller: _nome,
                      label: 'Nome da Corretora',
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    _inputOutlined(controller: _cnpj, label: 'CNPJ'),
                    const SizedBox(height: 16),
                    _inputOutlined(controller: _telefone, label: 'Telefone'),
                    const SizedBox(height: 16),
                    _inputOutlined(controller: _email, label: 'Email'),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: _isCreating ? null : () => Navigator.pop(context),
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.white70)),
              ),
              ElevatedButton(
                onPressed: _isCreating
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        setDialogState(() => _isCreating = true);
                        try {
                          await _service.criarCorretora(CorretoraCreate(
                            nome: _nome.text.trim(),
                            cnpj: _cnpj.text.trim(),
                            telefone: _telefone.text.trim(),
                            email: _email.text.trim(),
                          ));
                          Navigator.pop(context);
                          _carregarCorretoras();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Corretora criada com sucesso!'),
                              backgroundColor: Color(0xFF34a853),
                            ),
                          );
                        } catch (e) {
                          setDialogState(() => _isCreating = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao criar corretora: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285f4)),
                child: _isCreating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Criar'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Dialog: EDITAR
  void _showEditarCorretoraDialog(Corretora c) {
    final _formKey = GlobalKey<FormState>();
    final _nome = TextEditingController(text: c.nome);
    final _cnpj = TextEditingController(text: c.cnpj ?? '');
    final _telefone = TextEditingController(text: c.telefone ?? '');
    final _email = TextEditingController(text: c.email ?? '');
    bool _isUpdating = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2d2d2d),
            title: Text('Editar ${c.nome}',
                style: const TextStyle(color: Colors.white)),
            content: SizedBox(
              width: 420,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _inputOutlined(
                      controller: _nome,
                      label: 'Nome da Corretora',
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    _inputOutlined(controller: _cnpj, label: 'CNPJ'),
                    const SizedBox(height: 16),
                    _inputOutlined(controller: _telefone, label: 'Telefone'),
                    const SizedBox(height: 16),
                    _inputOutlined(controller: _email, label: 'Email'),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: _isUpdating ? null : () => Navigator.pop(context),
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.white70)),
              ),
              ElevatedButton(
                onPressed: _isUpdating
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        setDialogState(() => _isUpdating = true);
                        try {
                          await _service.editarCorretora(
                            c.id,
                            CorretoraCreate(
                              nome: _nome.text.trim(),
                              cnpj: _cnpj.text.trim(),
                              telefone: _telefone.text.trim(),
                              email: _email.text.trim(),
                            ),
                          );
                          Navigator.pop(context);
                          _carregarCorretoras();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Corretora atualizada!'),
                              backgroundColor: Color(0xFF34a853),
                            ),
                          );
                        } catch (e) {
                          setDialogState(() => _isUpdating = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro ao atualizar: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285f4)),
                child: _isUpdating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Confirmar'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Confirmar Exclusão
  void _confirmarExclusaoCorretora(int id, String nome) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d2d),
        title:
            const Text('Confirmar Exclusão', style: TextStyle(color: Colors.white)),
        content: Text(
          'Deseja realmente excluir a corretora "$nome"? Esta ação não poderá ser desfeita.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _service.excluirCorretora(id);
                _carregarCorretoras();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Corretora excluída com sucesso.'),
                    backgroundColor: Color(0xFF34a853),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao excluir: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  // Input padrão
  Widget _inputOutlined({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: const InputDecoration(
        labelText: 'label', // será sobrescrito abaixo
      ).copyWith(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white30)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4285f4))),
      ),
    );
  }
}
