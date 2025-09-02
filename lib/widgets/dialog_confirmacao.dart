import 'package:flutter/material.dart';

class ConfirmacaoDialog extends StatelessWidget {
  final String titulo; // Ex.: "Confirmar início" ou "Confirmar parada"
  final String mensagem; // Ex.: "Tem certeza que deseja iniciar o robô X?"
  final String textoBotaoConfirmar; // Ex.: "Iniciar", "Parar"
  final Color? corBotao; // Cor personalizada para o botão confirmar
  final VoidCallback onConfirmar; // Ação ao confirmar

  const ConfirmacaoDialog({
    super.key,
    required this.titulo,
    required this.mensagem,
    required this.textoBotaoConfirmar,
    required this.onConfirmar,
    this.corBotao,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: theme.dialogBackgroundColor,
      title: Text(
        titulo,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Text(
        mensagem,
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
          onPressed: () {
            Navigator.pop(context, true);
            onConfirmar();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: corBotao ?? theme.colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(textoBotaoConfirmar),
        ),
      ],
    );
  }
}
