import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

import '../config/api_config.dart';

// modelos já existentes no seu dashboard
import '../models/cliente_dashboard/metricas_model.dart';
import '../models/cliente_dashboard/resumo_dados_model.dart';
import '../models/cliente_dashboard/grafico_pizza_model.dart';

// >>> modelos do gráfico de ATIVOS (seu arquivo que você enviou)
import '../models/ativo_chart_model.dart';

class ClienteDashboardService {
  final _storage = const FlutterSecureStorage();

  // Ex.: https://api.seu-dominio.com + /dashboard
  final String _baseUrl = '${ApiConfig.baseUrl}${ApiConfig.dashboardEndpoint}';

  // ===========================================================================
  // UTILITÁRIOS
  // ===========================================================================

  /// Cor determinística por rótulo (fallback)
  Color _colorForLabel(String label) {
    final bytes = utf8.encode(label);
    int h = 0;
    for (final b in bytes) {
      h = (h * 31 + b) & 0x1fffffff;
    }
    final hue = (h % 360).toDouble();
    final hsv = HSVColor.fromAHSV(1.0, hue, 0.65, 0.90);
    return hsv.toColor();
  }

  /// Cores fixas para manter o visual do seu print
  Color _colorForKnownSymbol(String symbol) {
    final s = symbol.toUpperCase();
    if (s == 'CAPITAL') return const Color(0xFF00E676); // verde
    if (s == 'USD/BRL') return const Color(0xFF2196F3); // azul
    if (s == 'IBOV') return const Color(0xFFFF5252);    // vermelho
    return _colorForLabel(symbol);
  }

  /// Heurística para descobrir o TipoAtivo (caso venham vários tipos misturados)
  TipoAtivo _inferTipoAtivo({String? tipoMercado, required String symbol}) {
    final t = (tipoMercado ?? '').toLowerCase();
    if (t == 'moeda') return TipoAtivo.moeda;
    if (t == 'indice') return TipoAtivo.indice;
    if (t == 'robo') return TipoAtivo.acao; // “Seu Capital” etc podem cair aqui

    final sym = symbol.toUpperCase();
    if (sym.contains('/')) return TipoAtivo.moeda; // USD/BRL etc
    if (sym.contains('IBOV') ||
        sym.contains('IGPM') ||
        sym.contains('SELIC') ||
        sym.contains('IPCA')) {
      return TipoAtivo.indice;
    }
    if (sym.contains('BTC') || sym.contains('ETH')) return TipoAtivo.crypto;
    if (sym.contains('GOLD') ||
        sym.contains('OURO') ||
        sym.contains('OIL') ||
        sym.contains('BRENT') ||
        sym.contains('WTI') ||
        sym.contains('PETROLEO') ||
        sym.contains('PETRÓLEO')) {
      return TipoAtivo.commodity;
    }
    return TipoAtivo.acao;
  }

  /// Monta querystring com suporte a chaves repetidas (e.g., tipos=...&tipos=...)
  String _buildQuery({
    Map<String, String?> single = const {},
    Map<String, List<String>> multi = const {},
  }) {
    final parts = <String>[];
    single.forEach((k, v) {
      if (v != null && v.isNotEmpty) {
        parts.add('$k=${Uri.encodeComponent(v)}');
      }
    });
    multi.forEach((k, list) {
      for (final v in list) {
        parts.add('$k=${Uri.encodeComponent(v)}');
      }
    });
    return parts.isEmpty ? '' : '?${parts.join('&')}';
  }

  /// Converte período do widget em janela temporal + agrupar
  ({DateTime? start, DateTime? end, String groupBy}) _rangeFromPeriodo(
    FiltroPeriodo periodo,
  ) {
    final now = DateTime.now();
    DateTime? start;
    DateTime? end = now;
    String group = 'day';

    switch (periodo) {
      case FiltroPeriodo.dia:
        start = now.subtract(const Duration(days: 1));
        group = 'day';
        break;
      case FiltroPeriodo.semana:
        start = now.subtract(const Duration(days: 7));
        group = 'day';
        break;
      case FiltroPeriodo.mes:
        start = now.subtract(const Duration(days: 31));
        group = 'day';
        break;
      case FiltroPeriodo.trimestre:
        start = now.subtract(const Duration(days: 93));
        group = 'week';
        break;
      case FiltroPeriodo.ano:
        start = DateTime(now.year - 1, now.month, now.day);
        group = 'month';
        break;
      case FiltroPeriodo.tudo:
        start = null;
        end = null;
        group = 'month';
        break;
    }
    return (start: start, end: end, groupBy: group);
  }

  // ===========================================================================
  // ENDPOINTS JÁ EXISTENTES
  // ===========================================================================

  /// Métricas + resumo (/dashboard)
  Future<(MetricasModel, ResumoDadosModel)> fetchDashboardData() async {
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final metricas = MetricasModel(metricas: [
        MetricaItem(
          titulo: 'Carteiras',
          valor: data['metricas']['total_carteiras'],
          icone: Icons.account_balance_wallet,
          corIcone: const Color(0xFF4285f4),
        ),
        MetricaItem(
          titulo: 'Robôs do Usuário',
          valor: data['metricas']['total_robos'],
          icone: Icons.smart_toy,
          corIcone: const Color(0xFF34a853),
        ),
        MetricaItem(
          titulo: 'Ordens',
          valor: data['metricas']['total_ordens'],
          icone: Icons.receipt_long,
          corIcone: const Color(0xFFff9800),
        ),
      ]);

      final resumo = ResumoDadosModel(grupos: [
        ResumoGrupo(
          titulo: 'Todas as Carteiras',
          icone: Icons.account_balance_wallet,
          corIcone: const Color(0xFF4285f4),
          itens: List<String>.from(data['resumo']['carteiras_recentes']),
        ),
        ResumoGrupo(
          titulo: 'Todas as Ordens',
          icone: Icons.receipt_long,
          corIcone: const Color(0xFFff9800),
          itens: List<String>.from(data['resumo']['ordens_recentes']),
        ),
      ]);

      return (metricas, resumo);
    } else {
      throw Exception(
        'Erro ao carregar dados do dashboard: ${response.statusCode} | ${response.body}',
      );
    }
  }

  /// Donut: "Margem Total por País" (/dashboard/margem-por-pais)
  Future<GraficoPizzaDados> fetchMargemPorPais() async {
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$_baseUrl/margem-por-pais'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao carregar margem por país: ${response.statusCode} | ${response.body}',
      );
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final itensJson = (data['itens'] as List<dynamic>? ?? []);

    double total = (data['total'] as num?)?.toDouble() ?? 0.0;
    if (total <= 0) {
      total = itensJson.fold<double>(
        0.0,
        (acc, e) => acc + ((e['margem_total'] as num?)?.toDouble() ?? 0.0),
      );
    }
    final denom = total > 0 ? total : 1.0;

    final itens = <GraficoPizzaItem>[];
    for (final e in itensJson) {
      final label = (e['pais'] ?? '').toString().trim();
      final valor = (e['margem_total'] as num?)?.toDouble() ?? 0.0;
      if (label.isEmpty || valor <= 0) continue;

      final cor = _colorForLabel(label);
      final pct = double.parse(((valor / denom) * 100).toStringAsFixed(1));

      itens.add(GraficoPizzaItem(
        label: label,
        valor: valor,
        porcentagem: pct,
        cor: cor,
      ));
    }

    itens.sort((a, b) => b.valor.compareTo(a.valor));

    return GraficoPizzaDados(
      titulo: 'Margem Total por País',
      itens: itens,
    );
  }

  // ===========================================================================
  // NOVO: Gráfico de EVOLUÇÃO DOS ATIVOS (dinâmico)
  // Endpoints: /dashboard/grafico/ativos, /dashboard/grafico/series
  // ===========================================================================

  /// Busca ativos disponíveis conforme o(s) tipo(s) de mercado selecionados.
  /// Retorna um mapa id->(descricao,symbol) mantendo a ordem da API.
  Future<List<Map<String, dynamic>>> _fetchAtivos({
    List<String>? tiposMercado,
  }) async {
    final token = await _storage.read(key: 'token');

    final query = _buildQuery(
      multi: tiposMercado == null || tiposMercado.isEmpty
          ? const {}
          : {
              'tipos': tiposMercado,
            },
    );

    final resp = await http.get(
      Uri.parse('$_baseUrl/grafico/ativos$query'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode != 200) {
      throw Exception(
        'Erro ao carregar ativos: ${resp.statusCode} | ${resp.body}',
      );
    }
    final list = json.decode(resp.body) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  /// Busca séries para uma lista de ativos (ids).
  Future<Map<int, List<Map<String, dynamic>>>> _fetchSeries({
    required List<int> ativoIds,
    List<String>? tiposMercado,
    DateTime? start,
    DateTime? end,
    String groupBy = 'day',
  }) async {
    final token = await _storage.read(key: 'token');

    final single = <String, String?>{
      'group_by': groupBy,
      if (start != null) 'start': '${start.year.toString().padLeft(4, '0')}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}',
      if (end != null) 'end': '${end.year.toString().padLeft(4, '0')}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}',
    };

    final multi = <String, List<String>>{
      'ativo_ids': ativoIds.map((e) => e.toString()).toList(),
      if (tiposMercado != null && tiposMercado.isNotEmpty) 'tipos': tiposMercado,
    };

    final query = _buildQuery(single: single, multi: multi);

    final resp = await http.get(
      Uri.parse('$_baseUrl/grafico/series$query'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode != 200) {
      throw Exception(
        'Erro ao carregar séries: ${resp.statusCode} | ${resp.body}',
      );
    }

    final data = json.decode(resp.body) as Map<String, dynamic>;
    final seriesList = (data['series'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    // Retorna map por ativo_id -> lista de pontos {data, valor}
    final byAtivo = <int, List<Map<String, dynamic>>>{};
    for (final s in seriesList) {
      final id = (s['ativo_id'] as num?)?.toInt();
      final pontos = (s['pontos'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      if (id != null) {
        byAtivo[id] = pontos;
      }
    }
    return byAtivo;
  }

  /// Monta a ConfiguracaoGraficoAtivos que o seu widget já consome.
  ///
  /// [tiposMercado] → valores do enum do backend (ex.: ["Moeda","Indice"])
  /// [periodo] → período do botão (1D, 1S, 1M, 3M, 1A, Tudo)
  /// [ativosSelecionados] → mantém seleção do usuário (se nulo, pega os 3 primeiros)
  Future<ConfiguracaoGraficoAtivos> fetchGraficoAtivos({
    List<String>? tiposMercado,
    FiltroPeriodo periodo = FiltroPeriodo.mes,
    List<String>? ativosSelecionados,
    String titulo = 'Evolução dos Ativos',
    String subtitulo = 'Acompanhe seus principais indicadores',
  }) async {
    // 1) Busca a lista de ativos conforme os tipos selecionados
    final ativosApi = await _fetchAtivos(tiposMercado: tiposMercado);

    // Converte para estrutura do app
    // Mantém a ordem da API (importante para cores previsíveis)
    final ativosConvertidos = <int, Ativo>{};
    int idx = 0;
    for (final a in ativosApi) {
      final intId = (a['id'] as num).toInt();
      final desc = (a['descricao'] ?? '').toString();
      final symbol = (a['symbol'] ?? a['simbolo'] ?? '').toString();

      // Se veio apenas 1 tipo selecionado, usamos diretamente; senão heurística
      final tipo = _inferTipoAtivo(
        tipoMercado: (tiposMercado != null && tiposMercado.length == 1)
            ? tiposMercado.first
            : null,
        symbol: symbol,
      );

      final cor = _colorForKnownSymbol(symbol);

      final ativo = Ativo(
        id: intId.toString(),
        descricao: desc,
        cor: cor,
        tipo: tipo,
        simbolo: symbol,
      );

      // Ajuste opcional de cor por tipo (mantendo cor fixa dos “conhecidos”)
      // final corAuto = ProcessadorDadosAtivos.gerarCorParaAtivo(ativo, idx);
      // ativo = ativo.copyWith(cor: corAuto); // seu modelo não tem copyWith; então mantemos cor escolhida

      ativosConvertidos[intId] = ativo;
      idx++;
    }

    if (ativosConvertidos.isEmpty) {
      return ConfiguracaoGraficoAtivos(
        titulo: titulo,
        subtitulo: subtitulo,
        periodo: periodo,
        series: const [],
        ativosSelecionados: const [],
      );
    }

    // 2) Determina janela temporal e group_by
    final win = _rangeFromPeriodo(periodo);

    // 3) Busca as séries para TODOS os ativos retornados
    final seriesApi = await _fetchSeries(
      ativoIds: ativosConvertidos.keys.toList(),
      tiposMercado: tiposMercado,
      start: win.start,
      end: win.end,
      groupBy: win.groupBy,
    );

    // 4) Monta as séries no formato do widget
    final seriesOut = <SerieAtivo>[];
    for (final entry in ativosConvertidos.entries) {
      final ativoId = entry.key;
      final ativo = entry.value;

      final pontosApi = seriesApi[ativoId] ?? const <Map<String, dynamic>>[];
      final pontos = <PontoCotacao>[];
      for (final p in pontosApi) {
        final dataStr = (p['data'] ?? '').toString();
        final valor = (p['valor'] as num?)?.toDouble();
        if (dataStr.isEmpty || valor == null) continue;

        // data vem ISO YYYY-MM-DD do backend
        final dt = DateTime.tryParse(dataStr);
        if (dt != null) {
          pontos.add(PontoCotacao(data: dt, valor: valor));
        }
      }

      // garante ordenação por data
      pontos.sort((a, b) => a.data.compareTo(b.data));

      seriesOut.add(SerieAtivo(ativo: ativo, pontos: pontos));
    }

    // 5) Seleção padrão (se não vier de fora)
    final selecionados =
        ativosSelecionados ?? seriesOut.take(3).map((s) => s.ativo.id).toList();

    return ConfiguracaoGraficoAtivos(
      titulo: titulo,
      subtitulo: subtitulo,
      periodo: periodo,
      series: seriesOut,
      ativosSelecionados: selecionados,
    );
  }
}
