import 'package:flutter/material.dart';
import '../../../models/cliente_dashboard/metricas_model.dart';
import '../../../models/cliente_dashboard/resumo_dados_model.dart';
import '../../../models/cliente_dashboard/grafico_pizza_model.dart';
import '../../../services/cliente_dashboard_service.dart';

class DashboardController extends ChangeNotifier {
  final ClienteDashboardService _dashboardService = ClienteDashboardService();

  bool isLoading = true;
  String? errorMessage;

  MetricasModel? metricasModel;
  ResumoDadosModel? resumoModel;
  GraficoPizzaDados? graficoPizzaModel;

  bool _jaCarregado = false;

  Future<void> carregarDados() async {
    if (_jaCarregado) return;
    _jaCarregado = true;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final (metricas, resumo) = await _dashboardService.fetchDashboardData();
      metricasModel = metricas;
      resumoModel  = resumo;

      // Gráfico (recalcula % aqui!)
      final dados = await _dashboardService.fetchMargemPorPais();
      graficoPizzaModel = _recalcularPercentuais(dados);

    } catch (e) {
      errorMessage = 'Erro ao carregar os dados do dashboard.';
      debugPrint('DashboardController erro: $e');

      // fallback visual
      graficoPizzaModel ??= _recalcularPercentuais(
        GraficoPizzaDados(
          titulo: 'Margem Total por País',
          itens: [
            GraficoPizzaItem(label: 'Brasil', valor: 0, porcentagem: 0, cor: Colors.green),
            GraficoPizzaItem(label: 'Estados Unidos', valor: 0, porcentagem: 0, cor: Colors.blue),
            GraficoPizzaItem(label: 'Outros', valor: 0, porcentagem: 0, cor: Colors.grey),
          ],
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void recarregar() {
    _jaCarregado = false;
    carregarDados();
  }

  Future<void> recarregarGraficoPizza() async {
    try {
      final dados = await _dashboardService.fetchMargemPorPais();
      graficoPizzaModel = _recalcularPercentuais(dados);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao recarregar gráfico de margem por país: $e');
    }
  }

  GraficoPizzaDados _recalcularPercentuais(GraficoPizzaDados dados) {
    final total = dados.itens.fold<double>(0, (a, b) => a + b.valor);
    final denom = total > 0 ? total : 1.0;

    final itens = dados.itens.map((it) {
      final pct = double.parse(((it.valor / denom) * 100).toStringAsFixed(1));
      return GraficoPizzaItem(
        label: it.label,
        valor: it.valor,          // usado para desenhar
        porcentagem: pct,         // só para exibir
        cor: it.cor,
      );
    }).toList();

    return GraficoPizzaDados(titulo: dados.titulo, itens: itens);
  }
}
