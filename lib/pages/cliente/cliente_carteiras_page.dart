import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/cabecalho.dart';
import '../../widgets/lista.dart';
import '../../widgets/dialog_confirmar_exclusao.dart';
import '../../widgets/dialog_formulario_carteira.dart';

import '../../controllers/cliente_carteiras_controller.dart';
import '../../models/lista_model.dart';
import '../../models/carteira_model.dart';

class ClienteCarteirasPage extends StatelessWidget {
  const ClienteCarteirasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ClienteCarteirasController>(context);

    // ✅ Só carrega uma vez!
    if (!controller.jaCarregado) {
      controller.carregarCarteirasUmaVez();
    }

    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null) {
      return Center(
        child: Text(
          controller.errorMessage!,
          style: TextStyle(color: theme.colorScheme.error),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Cabecalho(titulo: 'Carteiras', isMobile: isMobile),
            const SizedBox(height: 16),
            Lista(
              isMobile: isMobile,
              tituloLista: 'Minhas Carteiras',
              itens: controller.listaCarteiras,
              onEdit: (item) => _abrirDialogEditarCarteira(context, item),
              onDelete: (item) => _confirmarExclusao(
                context,
                'carteira',
                () => controller.excluirCarteira(item.id!, context: context),
              ),
              onAdicionar: () => _abrirDialogNovaCarteira(context, controller),

              // 👇 Novo comportamento ao clicar em qualquer item
              onTapItem: (item) {
                if (item.id != null) {
                  context.push('/cliente/contas/${item.id}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarExclusao(BuildContext context, String nomeDoItem, VoidCallback onConfirmar) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmarExclusaoDialog(nomeDoItem: nomeDoItem),
    );

    if (confirmado == true) {
      onConfirmar();
    }
  }

  Future<void> _abrirDialogNovaCarteira(BuildContext context, ClienteCarteirasController controller) async {
    final resultado = await showDialog<CarteiraModel>(
      context: context,
      builder: (_) => DialogFormularioCarteira(
        titulo: 'Nova Carteira',
        carteira: CarteiraModel(nome: ''),
      ),
    );

    if (resultado != null && resultado.nome.isNotEmpty) {
      await controller.criarCarteira(resultado.nome, context: context);
    }
  }

  Future<void> _abrirDialogEditarCarteira(BuildContext context, ListaModel item) async {
    final controller = Provider.of<ClienteCarteirasController>(context, listen: false);

    final resultado = await showDialog<CarteiraModel>(
      context: context,
      builder: (_) => DialogFormularioCarteira(
        titulo: 'Editar Carteira',
        carteira: CarteiraModel(id: item.id, nome: item.tituloItem ?? ''),
      ),
    );

    if (resultado != null && resultado.nome.isNotEmpty && item.id != null) {
      await controller.editarCarteira(item.id!, resultado.nome);
    }
  }
}
