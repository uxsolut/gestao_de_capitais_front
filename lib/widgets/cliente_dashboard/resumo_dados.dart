import 'package:flutter/material.dart';
import '../../../models/cliente_dashboard/resumo_dados_model.dart';

class ClienteResumoDados extends StatelessWidget {
  final bool isMobile;
  final ResumoDadosModel model;

  const ClienteResumoDados({
    super.key,
    required this.isMobile,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Text(
            'Resumo dos Dados',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...model.grupos.map((grupo) {
            if (grupo.itens.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummarySection(
                  context: context,
                  title: grupo.titulo,
                  items: grupo.itens,
                  icon: grupo.icone,
                  color: grupo.corIcone,
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummarySection({
    required BuildContext context,
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 4),
              child: Text(
                '• $item',
                style: theme.textTheme.bodySmall,
              ),
            )),
      ],
    );
  }
}
