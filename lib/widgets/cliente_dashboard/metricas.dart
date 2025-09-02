import 'package:flutter/material.dart';
import '../../../models/cliente_dashboard/metricas_model.dart';

class ClienteDashboardMetricas extends StatelessWidget {
  final bool isMobile;
  final MetricasModel model;

  const ClienteDashboardMetricas({
    super.key,
    required this.isMobile,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? Column(
            children: model.metricas
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildMetricCard(context, item),
                    ))
                .toList(),
          )
        : Row(
            children: model.metricas
                .map((item) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _buildMetricCard(context, item),
                      ),
                    ))
                .toList(),
          );
  }

  Widget _buildMetricCard(BuildContext context, MetricaItem item) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.corIcone.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icone,
                    color: item.corIcone,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.trending_up,
                  color: Colors.greenAccent.shade400,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.titulo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.valor.toString(),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: isMobile ? 24 : 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
