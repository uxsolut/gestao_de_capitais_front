import 'package:flutter/material.dart';
import '../../models/corretora_models.dart';

class DialogFormularioConta extends StatefulWidget {
  final String titulo;
  final Function(String nome, String contaMetaTrader, int idCorretora) onSalvar;
  final String? nomeInicial;
  final String? contaMetaTraderInicial;
  final Corretora? corretoraInicial;
  final List<Corretora> corretoras;

  const DialogFormularioConta({
    super.key,
    required this.titulo,
    required this.onSalvar,
    required this.corretoras,
    this.nomeInicial,
    this.contaMetaTraderInicial,
    this.corretoraInicial,
  });

  @override
  State<DialogFormularioConta> createState() => _DialogFormularioContaState();
}

class _DialogFormularioContaState extends State<DialogFormularioConta> {
  late final TextEditingController _nomeController;
  late final TextEditingController _metaTraderController;
  Corretora? _corretoraSelecionada;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nomeInicial ?? '');
    _metaTraderController = TextEditingController(text: widget.contaMetaTraderInicial ?? '');
    _corretoraSelecionada = widget.corretoraInicial;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _metaTraderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        widget.titulo,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nome da conta
            TextFormField(
              controller: _nomeController,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Nome da Conta',
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Conta MetaTrader
            TextFormField(
              controller: _metaTraderController,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Conta MetaTrader',
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown de corretora
            DropdownButtonFormField<Corretora>(
              value: _corretoraSelecionada,
              items: widget.corretoras.map((corretora) {
                return DropdownMenuItem(
                  value: corretora,
                  child: Text(corretora.nome),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _corretoraSelecionada = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Corretora',
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
          ),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final nome = _nomeController.text.trim();
            final conta = _metaTraderController.text.trim();
            final corretora = _corretoraSelecionada;

            if (nome.isNotEmpty && conta.isNotEmpty && corretora != null) {
              widget.onSalvar(nome, conta, corretora.id);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
