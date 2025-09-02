/*
import 'package:flutter/material.dart';
import '../../models/corretora_models.dart';
import '../../services/corretora_service.dart';
import '../../widgets/topo_fixo.dart';

class AdminCorretorasPage extends StatefulWidget {
  const AdminCorretorasPage({Key? key}) : super(key: key);

  @override
  State<AdminCorretorasPage> createState() => _AdminCorretorasPageState();
}

class _AdminCorretorasPageState extends State<AdminCorretorasPage> with TickerProviderStateMixin {
  List<Corretora> _corretoras = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarCorretoras();
  }

  Future<void> _carregarCorretoras() async {
    setState(() => _isLoading = true);
    try {
      final lista = await CorretoraService().listarCorretoras();
      setState(() => _corretoras = lista);
    } catch (e) {
      // erro silencioso
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarDialogCriarCorretora() {
    final nomeController = TextEditingController();
    final cnpjController = TextEditingController();
    final telefoneController = TextEditingController();
    final emailController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              backgroundColor: const Color(0xFF1E1E1E),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          'Criar Nova Corretora',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _campoInput('Nome da Corretora', nomeController),
                      const SizedBox(height: 12),
                      _campoInput('CNPJ', cnpjController),
                      const SizedBox(height: 12),
                      _campoInput('Telefone', telefoneController),
                      const SizedBox(height: 12),
                      _campoInput('Email', emailController),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4285F4),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() => isLoading = true);
                                    await CorretoraService().criarCorretora(
                                      CorretoraCreate(
                                        nome: nomeController.text,
                                        cnpj: cnpjController.text,
                                        telefone: telefoneController.text,
                                        email: emailController.text,
                                      ),
                                    );
                                    Navigator.pop(context, true);
                                  },
                            child: const Text('Criar', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((criado) {
      if (criado == true) _carregarCorretoras();
    });
  }

  Widget _campoInput(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4285F4)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Corretoras",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const TopoFixo(),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2b2b2b),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      'Corretoras',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
      'Total: ${_corretoras.length} corretoras',
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
      ),
    ),
  ],
),

                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _corretoras.length,
                          itemBuilder: (context, index) {
                            final corretora = _corretoras[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1a1a1a),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF2C66C3), // Azul mais escuro
                                  width: 1,
                                ),
                              ),
                              child: Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(
      child: Text(
        corretora.nome,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.orangeAccent),
          tooltip: 'Editar',
          onPressed: () => _abrirDialogEditarCorretora(corretora),
        ),
        IconButton(
          icon: const Icon(Icons.delete, size: 20, color: Colors.redAccent),
          tooltip: 'Excluir',
          onPressed: () => _confirmarExclusaoCorretora(corretora.id),
        ),
      ],
    ),
  ],
),

    const SizedBox(height: 6),
    Row(
      children: [
        const Icon(Icons.email, size: 16, color: Colors.white70),
        const SizedBox(width: 6),
        Text(
          corretora.email ?? 'sem email',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    ),
    if (corretora.telefone != null && corretora.telefone!.isNotEmpty)
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            const Icon(Icons.phone, size: 16, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              corretora.telefone!,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    if (corretora.cnpj != null && corretora.cnpj!.isNotEmpty)
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            const Icon(Icons.badge, size: 16, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              corretora.cnpj!,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
  ],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: _mostrarDialogCriarCorretora,
      ),
    );
  }
  void _abrirDialogEditarCorretora(Corretora corretora) {
  final nomeController = TextEditingController(text: corretora.nome);
  final cnpjController = TextEditingController(text: corretora.cnpj ?? '');
  final telefoneController = TextEditingController(text: corretora.telefone ?? '');
  final emailController = TextEditingController(text: corretora.email ?? '');
  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: const Color(0xFF1E1E1E),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        'Editar Corretora',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _campoInput('Nome da Corretora', nomeController),
                    const SizedBox(height: 12),
                    _campoInput('CNPJ', cnpjController),
                    const SizedBox(height: 12),
                    _campoInput('Telefone', telefoneController),
                    const SizedBox(height: 12),
                    _campoInput('Email', emailController),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4285F4),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() => isLoading = true);
                                  await CorretoraService().editarCorretora(
                                    corretora.id,
                                    CorretoraCreate(
                                      nome: nomeController.text,
                                      cnpj: cnpjController.text,
                                      telefone: telefoneController.text,
                                      email: emailController.text,
                                    ),
                                  );
                                  Navigator.pop(context, true);
                                },
                          child: const Text('Salvar', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  ).then((editado) {
    if (editado == true) _carregarCorretoras();
  });
}
void _confirmarExclusaoCorretora(int id) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text(
          'Excluir Corretora',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Tem certeza que deseja excluir esta corretora?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              await CorretoraService().excluirCorretora(id);
              Navigator.pop(context);
              _carregarCorretoras();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      );
    },
  );
}

}
*/