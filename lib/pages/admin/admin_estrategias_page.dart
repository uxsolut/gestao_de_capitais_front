/*
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../services/robo_service.dart';
import '../../models/robo_model.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import '../../widgets/topo_fixo.dart';
import '../../services/aplicacao_service.dart';
import '../../services/versao_aplicacao_service.dart';

class AdminEstrategiasPage extends StatefulWidget {
  const AdminEstrategiasPage({super.key});

  @override
  State<AdminEstrategiasPage> createState() => _AdminEstrategiasPageState();
}

class _AdminEstrategiasPageState extends State<AdminEstrategiasPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  List<Robo> _robos = [];
  bool _isLoading = true;
  String? _errorMessage;

  final RoboService _roboService = RoboService();
  final AplicacaoService _aplicacaoService = AplicacaoService();
  final VersaoAplicacaoService _versaoAplicacaoService = VersaoAplicacaoService();


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
    _loadRobos();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadRobos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final robos = await _roboService.getRobos();
      
      setState(() {
        _robos = robos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateRoboDialog(),
        backgroundColor: const Color(0xFF4285f4),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            'Robôs (Estratégias)',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
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
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar robôs',
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
              onPressed: _loadRobos,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285f4),
              ),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_robos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.smart_toy_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum robô encontrado',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Não há robôs de trading cadastrados no sistema',
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
      child: _buildRobosList(isMobile),
    );
  }

  Widget _buildRobosList(bool isMobile) {
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
                  'Robôs de Trading (${_robos.length})',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Total: ${_robos.length} robô${_robos.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ..._robos.map((robo) => _buildRoboItem(robo, isMobile)),
        ],
      ),
    );
  }

  Widget _buildRoboItem(Robo robo, bool isMobile) {
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
                      robo.nome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: const Color(0xFF4285f4),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Symbol: ${robo.symbol}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
  children: [
    if (robo.criadoEm != null)
      Text(
        dateFormat.format(robo.criadoEm!),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
    const SizedBox(width: 8),
    Row(
  children: [
    if (robo.criadoEm != null)
      Text(
        dateFormat.format(robo.criadoEm!),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
    const SizedBox(width: 8),
    IconButton(
  icon: const Icon(Icons.download, color: Colors.lightBlueAccent, size: 20),
  tooltip: 'Baixar arquivo do robô',
  onPressed: () {
    _confirmarDownloadRobo(robo.id, robo.nome);
  },
),
IconButton(
  icon: const Icon(Icons.edit, color: Colors.orangeAccent, size: 20),
  tooltip: 'Editar robô',
  onPressed: () {
    _showEditarRoboDialog(robo);
  },
),
IconButton(
  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
  tooltip: 'Excluir robô',
  onPressed: () {
    _confirmarExclusaoRobo(robo.id, robo.nome);
  },
),

  ],
),

  ],
),

            ],
          ),
          
          if (robo.performance != null && robo.performance!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Performance:',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: robo.performance!.map((perf) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF34a853).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  perf,
                  style: const TextStyle(
                    color: Color(0xFF34a853),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  void _showCreateRoboDialog() {
    final _formKey = GlobalKey<FormState>();
    final _nomeController = TextEditingController();
    final _symbolController = TextEditingController();
    final TextEditingController _performanceController = TextEditingController();
    final List<String> _listaPerformance = [];
    PlatformFile? _selectedPlatformFile;
    Uint8List? _fileBytes;
    bool _isCreating = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF2d2d2d),
          title: const Text(
            'Criar Novo Robô',
            style: TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: 400,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nome
                  TextFormField(
                    controller: _nomeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Nome do Robô',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4285f4)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome é obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Symbol
                  TextFormField(
                    controller: _symbolController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Symbol',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4285f4)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Symbol é obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Performance com botão de adicionar
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    TextFormField(
      controller: _performanceController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Performance',
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: 'Digite e clique no +',
        hintStyle: const TextStyle(color: Colors.white30),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4285f4)),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.add, color: Color(0xFF4285f4)),
          onPressed: () {
            final texto = _performanceController.text.trim();
            if (texto.isNotEmpty) {
              setDialogState(() {
                _listaPerformance.add(texto);
                _performanceController.clear();
              });
            }
          },
        ),
      ),
    ),
    const SizedBox(height: 8),
    Wrap(
      spacing: 8,
      children: _listaPerformance.map((item) {
        return Chip(
          label: Text(item),
          backgroundColor: Colors.green.withOpacity(0.2),
          labelStyle: const TextStyle(color: Colors.green),
          deleteIcon: const Icon(Icons.close, size: 18),
          onDeleted: () {
            setDialogState(() {
              _listaPerformance.remove(item);
            });
          },
        );
      }).toList(),
    ),
  ],
),
const SizedBox(height: 16),

                  
                  // Arquivo
                  // Arquivo do Robô
Align(
  alignment: Alignment.centerLeft,
  child: Text(
    'Arquivo do Robô',
    style: TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
    ),
  ),
),
const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        Text(
  _selectedPlatformFile != null
      ? 'Arquivo: ${_selectedPlatformFile!.name}'
      : 'Nenhum arquivo selecionado',
  style: const TextStyle(color: Colors.white70),
),
                        const SizedBox(height: 8),
                        ElevatedButton(
  onPressed: () async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
    );
    if (result != null) {
      setDialogState(() {
        _selectedPlatformFile = result.files.first;
        _fileBytes = result.files.first.bytes;
      });
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF4285f4),
  ),
  child: const Text('Selecionar Arquivo'),
),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16), // espaço entre os dois uploads

                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isCreating ? null : () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: _isCreating ? null : () async {
  if (_formKey.currentState!.validate() && _selectedPlatformFile != null && _fileBytes != null) {
    if (_listaPerformance.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos uma performance'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setDialogState(() => _isCreating = true);

    try {
      final nome = _nomeController.text.trim();
      final symbol = _symbolController.text.trim();
      final performance = _listaPerformance;

      // 1. Criar robô
      final robo = await _roboService.criarRobo(
        nome: nome,
        symbol: symbol,
        performance: performance,
        arquivoWeb: _selectedPlatformFile,
        arquivoBytes: _fileBytes,
      );

      // 2. Criar aplicação
      final aplicacao = await _aplicacaoService.criarAplicacao(
        nome: 'robo $nome',
        tipo: 'backend',
      );

      // 3. Criar versão da aplicação
      final versao = await _versaoAplicacaoService.criarVersaoAplicacao(
        descricao: 'versao 1 do robo $nome',
        arquivo: _selectedPlatformFile!,
        idAplicacao: aplicacao.id,
      );

      // 4. Atualizar aplicação com id da versão e capturar nome atualizado
final aplicacaoAtualizada = await _aplicacaoService.atualizarAplicacao(
  id: aplicacao.id,
  idVersaoAplicacao: versao.id,
);

// Exemplo: mostrar o novo nome
print('Nome final da aplicação: ${aplicacaoAtualizada.nome}');

      Navigator.pop(context);
      _loadRobos();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Robô criado com sucesso!'),
          backgroundColor: Color(0xFF34a853),
        ),
      );
    } catch (e) {
      setDialogState(() => _isCreating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao criar robô e aplicações: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selecione um arquivo'),
        backgroundColor: Colors.orange,
      ),
    );
  }
},

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285f4),
              ),
              child: _isCreating 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }
  void _confirmarExclusaoRobo(int roboId, String nomeRobo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d2d),
        title: const Text(
          'Confirmar Exclusão',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Deseja realmente excluir o robô "$nomeRobo"? Esta ação não poderá ser desfeita.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // fecha o dialog
              try {
                await _roboService.excluirRobo(roboId);
                _loadRobos();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Robô excluído com sucesso.'),
                    backgroundColor: Color(0xFF34a853),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao excluir robô: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
  void _showEditarRoboDialog(Robo robo) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController(text: robo.nome);
  final TextEditingController _symbolController = TextEditingController(text: robo.symbol);
  final TextEditingController _performanceController = TextEditingController();
  final List<String> _listaPerformance = List<String>.from(robo.performance ?? []);

  PlatformFile? _selectedPlatformFile;
  Uint8List? _fileBytes;
  bool _isUpdating = false;
  bool _performanceAlterada = false;

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d2d),
        title: Text(
          'Editar ${robo.nome}',
          style: const TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nome
                TextFormField(
                  controller: _nomeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Nome do Robô',
                    labelStyle: TextStyle(color: Colors.white70),
                    hintText: 'Nome atual',
                    hintStyle: TextStyle(color: Colors.white30),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4285f4)),
                    ),
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Nome é obrigatório' : null,
                ),
                const SizedBox(height: 16),

                // Symbol
                TextFormField(
                  controller: _symbolController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Symbol',
                    labelStyle: TextStyle(color: Colors.white70),
                    hintText: 'Símbolo atual',
                    hintStyle: TextStyle(color: Colors.white30),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4285f4)),
                    ),
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Symbol é obrigatório' : null,
                ),
                const SizedBox(height: 16),

                // Performance com botão de adicionar/remover
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _performanceController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Performance',
                        labelStyle: const TextStyle(color: Colors.white70),
                        hintText: 'Digite e clique no +',
                        hintStyle: const TextStyle(color: Colors.white30),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF4285f4)),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add, color: Color(0xFF4285f4)),
                          onPressed: () {
                            final texto = _performanceController.text.trim();
                            if (texto.isNotEmpty) {
                              setDialogState(() {
                                _listaPerformance.add(texto);
                                _performanceController.clear();
                                _performanceAlterada = true;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _listaPerformance.map((item) {
                        return Chip(
                          label: Text(item),
                          backgroundColor: Colors.green.withOpacity(0.2),
                          labelStyle: const TextStyle(color: Colors.green),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () {
                            setDialogState(() {
                              _listaPerformance.remove(item);
                              _performanceAlterada = true;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Arquivo com botão de remoção
                Align(
  alignment: Alignment.centerLeft,
  child: Text(
    'Arquivo do Robô',
    style: TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
    ),
  ),
),
const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _selectedPlatformFile != null
                            ? 'Arquivo: ${_selectedPlatformFile!.name}'
                            : 'Nenhum arquivo selecionado',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(withData: true);
                              if (result != null) {
                                setDialogState(() {
                                  _selectedPlatformFile = result.files.first;
                                  _fileBytes = result.files.first.bytes;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4285f4),
                            ),
                            child: const Text('Selecionar Arquivo'),
                          ),
                          if (_selectedPlatformFile != null) ...[
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                setDialogState(() {
                                  _selectedPlatformFile = null;
                                  _fileBytes = null;
                                });
                              },
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isUpdating ? null : () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: _isUpdating
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setDialogState(() => _isUpdating = true);

                      try {
                        await _roboService.editarRobo(
                          id: robo.id,
                          nome: _nomeController.text.trim() == robo.nome
                              ? null
                              : _nomeController.text.trim(),
                          symbol: _symbolController.text.trim() == robo.symbol
                              ? null
                              : _symbolController.text.trim(),
                          performance: _performanceAlterada ? _listaPerformance : null,
                          arquivoWeb: _selectedPlatformFile,
                          arquivoBytes: _fileBytes,
                        );

                        Navigator.pop(context);
                        _loadRobos();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Robô atualizado com sucesso!'),
                            backgroundColor: Color(0xFF34a853),
                          ),
                        );
                      } catch (e) {
                        setDialogState(() => _isUpdating = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao atualizar robô: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4285f4),
            ),
            child: _isUpdating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Confirmar'),
          ),
        ],
      ),
    ),
  );
}
void _confirmarDownloadRobo(int roboId, String nomeRobo) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF2d2d2d),
      title: const Text(
        'Confirmar Download',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        'Deseja fazer o download do arquivo do robô "$nomeRobo"?',
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Baixar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4285f4),
          ),
          onPressed: () async {
            Navigator.pop(context);

            try {
              await _roboService.baixarArquivo(roboId, nomeRobo); // ✅ nome enviado aqui
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download iniciado.'),
                  backgroundColor: Color(0xFF34a853),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro ao baixar: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
    ),
  );
}

}
*/