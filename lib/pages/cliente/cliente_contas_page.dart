import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // <-- para context.pushNamed
import '../../widgets/cabecalho.dart';
import '../../widgets/lista.dart';
import '../../widgets/dialog_formulario_conta.dart';
import '../../models/lista_model.dart';
import '../../controllers/cliente_contas_controller.dart';
import '../../models/corretora_models.dart';
import '../../widgets/dialog_lista.dart';
import '../../models/dialog_lista_model.dart';
import '../../widgets/dialog_confirmar_exclusao.dart';

class ClienteContasPage extends StatefulWidget {
  final String carteiraId;

  const ClienteContasPage({
    super.key,
    required this.carteiraId,
  });

  @override
  State<ClienteContasPage> createState() => _ClienteContasPageState();
}

class _ClienteContasPageState extends State<ClienteContasPage> {
  final ClienteContasController _controller = ClienteContasController();

  @override
  void initState() {
    super.initState();
    _controller.carregarContas(int.parse(widget.carteiraId)).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Cabecalho(
              titulo: 'Contas da Carteira',
              isMobile: isMobile,
              mostrarVoltar: true,
            ),
            const SizedBox(height: 16),
            if (_controller.carregando)
              const CircularProgressIndicator()
            else if (_controller.erro != null)
              Text(_controller.erro!, style: TextStyle(color: theme.colorScheme.error))
            else
              Lista(
                isMobile: isMobile,
                tituloLista: 'Minhas Contas',
                itens: _controller.contas,
                onEdit: (item) => _editarConta(context, item),
                onAdicionar: () => _novaConta(context),
                onAcaoExtra1: (item) => _abrirDialogAdicionarRobos(context, item),
                textoAcaoExtra1: 'Adicionar Robôs',
                onAcaoExtra2: (item) => _navegarParaRobosDaConta(context, item),
                textoAcaoExtra2: 'Ver Robôs',
                onDelete: (item) async {
                  final confirmou = await showDialog<bool>(
                    context: context,
                    builder: (_) => ConfirmarExclusaoDialog(
                      nomeDoItem: 'conta "${item.tituloItem}"',
                    ),
                  );

                  if (confirmou == true) {
                    try {
                      final ok = await _controller.deletarConta(item.id, int.parse(widget.carteiraId));
                      if (!mounted) return;
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Conta excluída com sucesso.')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Não foi possível excluir a conta.')),
                        );
                      }
                      await _controller.carregarContas(int.parse(widget.carteiraId));
                      if (mounted) setState(() {});
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao excluir: $e')),
                      );
                    }
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  void _editarConta(BuildContext context, ListaModel item) async {
    await _controller.carregarCorretoras();

    final conta = _controller.obterContaCompletaPorId(item.id);
    if (conta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: dados da conta não encontrados.')),
      );
      return;
    }

    final corretoraInicial = _controller.corretoras.firstWhere(
      (c) => c.id == conta.idCorretora,
      orElse: () => _controller.corretoras.first,
    );

    await showDialog(
      context: context,
      builder: (_) => DialogFormularioConta(
        titulo: 'Editar Conta',
        corretoras: _controller.corretoras,
        nomeInicial: conta.nome,
        contaMetaTraderInicial: conta.contaMetaTrader,
        corretoraInicial: corretoraInicial,
        onSalvar: (nome, contaMetaTrader, idCorretora) async {
          await _controller.atualizarConta(
            contaId: item.id,
            nome: nome,
            contaMetaTrader: contaMetaTrader,
            idCorretora: idCorretora,
            carteiraId: int.parse(widget.carteiraId),
          );

          await _controller.carregarContas(int.parse(widget.carteiraId));
          if (mounted) setState(() {});
        },
      ),
    );
  }

  Future<void> _novaConta(BuildContext context) async {
    await _controller.carregarCorretoras();

    await showDialog(
      context: context,
      builder: (_) => DialogFormularioConta(
        titulo: 'Nova Conta',
        corretoras: _controller.corretoras,
        onSalvar: (nome, contaMetaTrader, idCorretora) async {
          await _controller.criarConta(
            carteiraId: widget.carteiraId,
            nome: nome,
            contaMetaTrader: contaMetaTrader,
            idCorretora: idCorretora,
          );

          await _controller.carregarContas(int.parse(widget.carteiraId));
          if (mounted) setState(() {});
        },
      ),
    );
  }

  void _abrirDialogAdicionarRobos(BuildContext context, ListaModel item) async {
    final conta = _controller.obterContaCompletaPorId(item.id);
    if (conta == null) return;

    final robosDisponiveis = await _controller.getRobosDisponiveisParaConta(conta.id);
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (_) => DialogLista(
        titulo: 'Selecionar Robô',
        itens: robosDisponiveis.map((robo) {
          return DialogListaModel(
            id: robo.id,
            titulo: robo.nome,
            linha1: 'Performance: ${robo.performance?.join(', ') ?? '-'}',
          );
        }).toList(),
        onSelecionar: (roboSelecionado) {
          _controller
              .vincularRoboDoUser(
                idRobo: roboSelecionado.id,
                idConta: conta.id,
                idCarteira: int.parse(widget.carteiraId),
              )
              .then((_) async {
            await _controller.carregarContas(int.parse(widget.carteiraId));
            if (mounted) setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Robô vinculado com sucesso')),
            );
          });
        },
      ),
    );
  }

  Future<void> _navegarParaRobosDaConta(BuildContext context, ListaModel item) async {
    // Busca a lista inicial de robôs vinculados à conta
    var robosVinculados = await _controller.buscarRobosDaConta(item.id);
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return DialogLista(
            titulo: 'Robôs da conta',
            itens: robosVinculados,
            // ✅ Agora CLICÁVEL: ao tocar, navega para a tela do bot
            onSelecionar: (roboItem) {
              // Fecha o diálogo primeiro...
              Navigator.of(context).pop();
              // ...e navega no próximo frame para evitar conflito com o pop
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pushNamed('tradingBot', pathParameters: {
                  'id': roboItem.id.toString(), // usa o id do DialogListaModel
                });
              });
            },
            // Continúa permitindo exclusão no mesmo diálogo
            onDelete: (roboItem) async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (_) => ConfirmarExclusaoDialog(
                  nomeDoItem: 'robô "${roboItem.titulo}"',
                ),
              );

              if (confirmar == true) {
                await _controller.deletarRoboDoUser(roboItem.id);
                // Atualiza a lista dentro do diálogo
                robosVinculados = await _controller.buscarRobosDaConta(item.id);
                setStateDialog(() {});
              }
            },
          );
        },
      ),
    );
  }
}
