import 'package:flutter/material.dart';
import 'pie_chart.dart'; // seu gráfico existente
import '../models/conta_models.dart';

class GraficoMargemConta extends StatelessWidget {
  final List<Conta> contas;

  const GraficoMargemConta({Key? key, required this.contas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalMargem = 0;
    double totalDisponivel = 0;

    for (var conta in contas) {
      totalMargem += conta.margemTotal ?? 0;
      totalDisponivel += conta.margemDisponivel ?? 0;
    }

    double margemUsada = (totalMargem - totalDisponivel).clamp(0, totalMargem);
    double margemDisponivel = totalDisponivel.clamp(0, totalMargem);

    double total = margemUsada + margemDisponivel;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2d2d2d),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Margem Utilizada vs Disponível',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
  child: CustomPieChart(
    title: 'Margem Utilizada vs Disponível',
    data: [
      CustomPieChartData(
          label: 'Usada',
          value: margemUsada.toDouble(),
          color: Colors.red),
      CustomPieChartData(
          label: 'Disponível',
          value: margemDisponivel.toDouble(),
          color: Colors.green),
    ],
  ),
),
        ],
      ),
    );
  }
}
