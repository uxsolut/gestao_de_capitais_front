import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/login_controller.dart';
import '../../controllers/dashboard_controller.dart';

import '../../widgets/cabecalho.dart';
import '../../widgets/cliente_dashboard/metricas.dart';
import '../../widgets/cliente_dashboard/resumo_dados.dart';
import '../../widgets/cliente_dashboard/estado.dart';
import '../../widgets/cliente_dashboard/grafico_pizza.dart';
import '../../widgets/cliente_dashboard/grafico_barras.dart';

// Widget do gráfico de ativos (arquivo em lib/widgets/ativo_chart_widget.dart)
import '../../widgets/ativo_chart_widget.dart';
import '../../models/ativo_chart_model.dart';

// >>> novo: service que já consome os endpoints do backend
import '../../services/cliente_dashboard_service.dart';

class ClienteDashboardPage extends StatefulWidget {
  const ClienteDashboardPage({super.key});

  @override
  State<ClienteDashboardPage> createState() => _ClienteDashboardPageState();
}

class _ClienteDashboardPageState extends State<ClienteDashboardPage> {
  final _service = ClienteDashboardService();

  // Estado do gráfico de ativos
  late List<Ativo> _ativosBaseDemo;
  late List<CotacaoAtivo> _cotacoesBaseDemo;
  ConfiguracaoGraficoAtivos? _configAtivos;
  bool _usandoApi = false; // começa em demo, troca para API quando carregar
  bool _carregandoGrafico = false;

  // (opcional) quando você tiver UI para tipos_mercado, guarde aqui
  List<String>? _tiposMercadoSelecionados;

  @override
  void initState() {
    super.initState();

    // carrega outras seções do dashboard
    Future.microtask(() {
      final controller =
          Provider.of<DashboardController>(context, listen: false);
      controller.carregarDados(); // só executa uma vez por _jaCarregado
    });

    // 1) monta DEMO imediato (não muda layout, evita "vazio")
    final demo = _criarDadosExemplo(dias: 60, seed: 42);
    _ativosBaseDemo = demo.$1;
    _cotacoesBaseDemo = demo.$2;
    _rebuildConfigDemo(); // set _configAtivos com dados locais

    // 2) tenta buscar os dados REAIS e substituir quando chegar
    _carregarGraficoAtivos(periodo: _configAtivos?.periodo ?? FiltroPeriodo.mes);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DashboardController>(context);
    final loginController = Provider.of<LoginController>(context);
    final isMobile = MediaQuery.of(context).size.width < 600;
    final userName = loginController.currentUser?.user.nome ?? 'Usuário';

    final theme = Theme.of(context);

    if (controller.isLoading || controller.errorMessage != null) {
      return ClienteDashboardEstado(
        isLoading: controller.isLoading,
        errorMessage: controller.errorMessage,
        onRetry: controller.recarregar,
        isMobile: isMobile,
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Cabecalho(
                titulo: 'Olá, $userName! 👋',
                subtitulo: 'Bem-vindo ao seu Trading Dashboard',
                isMobile: isMobile,
              ),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.graficoPizzaModel != null)
                    Expanded(
                      child: ClienteGraficoPizza(
                        dados: controller.graficoPizzaModel!,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 32),

              // === Gráfico de Ativos ===
              if (_configAtivos != null) ...[
                AtivoChartWidget(
                  configuracao: _configAtivos!,
                  onPeriodoChanged: (p) async {
                    // mantém o mesmo layout; só troca a fonte (API ou demo)
                    if (_usandoApi) {
                      await _carregarGraficoAtivos(periodo: p);
                    } else {
                      _rebuildConfigDemo(periodo: p);
                    }
                  },
                  onAtivosSelecionadosChanged: (ids) {
                    // não precisamos bater na API pra isso; só atualiza seleção local
                    _apenasAtualizarSelecaoLocal(ids);
                  },
                  onRefreshData: () async {
                    if (_usandoApi) {
                      await _carregarGraficoAtivos(
                        periodo: _configAtivos?.periodo ?? FiltroPeriodo.mes,
                        force: true,
                      );
                    } else {
                      final demo = _criarDadosExemplo(
                        dias: 60,
                        seed: DateTime.now().millisecond,
                      );
                      _ativosBaseDemo = demo.$1;
                      _cotacoesBaseDemo = demo.$2;
                      _rebuildConfigDemo(refresh: true);
                    }
                  },
                  height: 300,
                ),
                const SizedBox(height: 32),
              ],

              /* ClienteDashboardMetricas(
                isMobile: isMobile,
                model: controller.metricasModel!,
              ),
              const SizedBox(height: 24), */

              /* ClienteResumoDados(
                isMobile: isMobile,
                model: controller.resumoModel!,
              ),
              const SizedBox(height: 24), */
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // DEMO (fallback imediato, sem depender de rede)
  // ===========================================================================
  void _rebuildConfigDemo({
    FiltroPeriodo? periodo,
    List<String>? ativosSelecionados,
    bool refresh = false,
  }) {
    final current = _configAtivos;
    final novoPeriodo = periodo ?? current?.periodo ?? FiltroPeriodo.mes;

    final cotacoesFiltradas = ProcessadorDadosAtivos.filtrarCotacoesPorPeriodo(
      _cotacoesBaseDemo,
      novoPeriodo,
    );

    final selecionados = ativosSelecionados ??
        current?.ativosSelecionados ??
        _ativosBaseDemo.take(3).map((e) => e.id).toList();

    setState(() {
      _configAtivos = ProcessadorDadosAtivos.processarCotacoes(
        cotacoes: cotacoesFiltradas,
        ativos: _ativosBaseDemo,
        titulo: 'Evolução dos Ativos',
        subtitulo: 'Acompanhe seus principais indicadores',
        periodo: novoPeriodo,
        ativosSelecionados: selecionados,
      );
    });
  }

  (List<Ativo>, List<CotacaoAtivo>) _criarDadosExemplo({
    int dias = 60,
    int seed = 42,
  }) {
    final ativos = ProcessadorDadosAtivos.criarAtivosExemplo().take(5).toList();

    final agora = DateTime.now();
    final inicio = agora.subtract(Duration(days: dias));
    final rnd = math.Random(seed);

    final List<CotacaoAtivo> cotacoes = [];
    for (final ativo in ativos) {
      double base = 100 + rnd.nextInt(50).toDouble(); // preço inicial
      for (int i = 0; i <= dias; i++) {
        final data = inicio.add(Duration(days: i));
        // Caminhada aleatória leve
        final variacao = (rnd.nextDouble() - 0.5) * 2.0; // -1.0 a +1.0
        base = (base + variacao).clamp(10.0, 1000.0);
        cotacoes.add(CotacaoAtivo(
          ativoId: ativo.id,
          valorFechamento: double.parse(base.toStringAsFixed(2)),
          data: data,
        ));
      }
    }

    return (ativos, cotacoes);
  }

  // ===========================================================================
  // API (dinâmico) — usa ClienteDashboardService sem mudar layout
  // ===========================================================================
  Future<void> _carregarGraficoAtivos({
    FiltroPeriodo? periodo,
    bool force = false,
  }) async {
    if (_carregandoGrafico && !force) return;

    setState(() => _carregandoGrafico = true);

    try {
      final conf = await _service.fetchGraficoAtivos(
        tiposMercado: _tiposMercadoSelecionados, // hoje null; futuro: virá do seu filtro
        periodo: periodo ?? _configAtivos?.periodo ?? FiltroPeriodo.mes,
        // preserva seleção do usuário se já houver
        ativosSelecionados: _configAtivos?.ativosSelecionados,
        titulo: 'Evolução dos Ativos',
        subtitulo: 'Acompanhe seus principais indicadores',
      );

      // se a API retornou vazio, mantém o demo; senão troca para API
      if (conf.series.isNotEmpty) {
        setState(() {
          _configAtivos = conf;
          _usandoApi = true;
        });
      }
    } catch (_) {
      // falhou? fica no demo em silêncio (sem alterar layout)
      // (pode logar/mostrar snack se quiser)
    } finally {
      if (mounted) setState(() => _carregandoGrafico = false);
    }
  }

  void _apenasAtualizarSelecaoLocal(List<String> novosIds) {
    final atual = _configAtivos;
    if (atual == null) return;

    setState(() {
      _configAtivos = ConfiguracaoGraficoAtivos(
        titulo: atual.titulo,
        subtitulo: atual.subtitulo,
        periodo: atual.periodo,
        series: atual.series,
        ativosSelecionados: novosIds,
        mostrarGrid: atual.mostrarGrid,
        mostrarLegenda: atual.mostrarLegenda,
        animado: atual.animado,
      );
    });
  }
}
