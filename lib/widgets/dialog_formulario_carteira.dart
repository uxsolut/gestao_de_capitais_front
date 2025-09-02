import 'package:flutter/material.dart';
import '../../models/carteira_model.dart';

class DialogFormularioCarteira extends StatefulWidget {
  final String titulo;
  final CarteiraModel carteira;

  const DialogFormularioCarteira({
    super.key,
    required this.titulo,
    required this.carteira,
  });

  @override
  State<DialogFormularioCarteira> createState() => _DialogFormularioCarteiraState();
}

class _DialogFormularioCarteiraState extends State<DialogFormularioCarteira> {
  late final TextEditingController _nomeController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.carteira.nome);
  }

  @override
  void dispose() {
    _nomeController.dispose();
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
        child: TextFormField(
          controller: _nomeController,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            labelText: 'Nome da Carteira',
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
    if (nome.isNotEmpty) {
      final carteiraAtualizada = widget.carteira.copyWith(nome: nome);
      Navigator.pop(context, carteiraAtualizada);
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
