import 'package:flutter/material.dart';

class ConfirmarExclusaoDialog extends StatelessWidget {
  final String nomeDoItem;
  final String? mensagemCustomizada;

  const ConfirmarExclusaoDialog({
    super.key,
    required this.nomeDoItem,
    this.mensagemCustomizada,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deleteColor = theme.colorScheme.error; // ou theme.colorScheme.deleteRed se você criou isso

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: theme.dialogBackgroundColor,
      title: Text(
        'Confirmar exclusão',
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Text(
        mensagemCustomizada ??
            'Tem certeza que deseja excluir este(a) $nomeDoItem? Esta ação não poderá ser desfeita.',
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
          ),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: deleteColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Excluir'),
        ),
      ],
    );
  }
}
