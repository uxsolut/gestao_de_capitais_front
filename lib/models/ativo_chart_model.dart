import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Modelo para um ativo financeiro
class Ativo {
  final String id;
  final String descricao;
  final Color cor;
  final TipoAtivo tipo;
  final String simbolo;

  Ativo({
    required this.id,
    required this.descricao,
    required this.cor,
    required this.tipo,
    required this.simbolo,
  });

  factory Ativo.fromJson(Map<String, dynamic> json) {
    return Ativo(
      id: json['id'] ?? '',
      descricao: json['descricao'] ?? '',
      cor: Color(int.parse((json['cor'] ?? '#00E676').replaceFirst('#', '0xFF'))),
      tipo: TipoAtivo.values.firstWhere(
        (e) => e.toString().split('.').last == json['tipo'],
        orElse: () => TipoAtivo.acao,
      ),
      simbolo: json['simbolo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'cor': '#${cor.value.toRadixString(16).substring(2)}',
      'tipo': tipo.toString().split('.').last,
      'simbolo': simbolo,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ativo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Cotação de um ativo em uma data específica
class CotacaoAtivo {
  final String ativoId;
  final double valorFechamento;
  final DateTime data;
  final double? valorAbertura;
  final double? valorMaximo;
  final double? valorMinimo;
  final int? volume;

  CotacaoAtivo({
    required this.ativoId,
    required this.valorFechamento,
    required this.data,
    this.valorAbertura,
    this.valorMaximo,
    this.valorMinimo,
    this.volume,
  });

  factory CotacaoAtivo.fromJson(Map<String, dynamic> json) {
    return CotacaoAtivo(
      ativoId: json['ativoId'] ?? '',
      valorFechamento: (json['valorFechamento'] ?? 0).toDouble(),
      data: DateTime.parse(json['data']),
      valorAbertura: json['valorAbertura']?.toDouble(),
      valorMaximo: json['valorMaximo']?.toDouble(),
      valorMinimo: json['valorMinimo']?.toDouble(),
      volume: json['volume']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ativoId': ativoId,
      'valorFechamento': valorFechamento,
      'data': data.toIso8601String(),
      'valorAbertura': valorAbertura,
      'valorMaximo': valorMaximo,
      'valorMinimo': valorMinimo,
      'volume': volume,
    };
  }
}

/// Ponto de cotação no gráfico
class PontoCotacao {
  final DateTime data;
  final double valor;

  PontoCotacao({
    required this.data,
    required this.valor,
  });

  factory PontoCotacao.fromJson(Map<String, dynamic> json) {
    return PontoCotacao(
      data: DateTime.parse(json['data']),
      valor: (json['valor'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toIso8601String(),
      'valor': valor,
    };
  }
}

/// Série temporal de um ativo para o gráfico
class SerieAtivo {
  final Ativo ativo;
  final List<PontoCotacao> pontos;
  final bool selecionado;

  SerieAtivo({
    required this.ativo,
    required this.pontos,
    this.selecionado = true,
  });

  /// Variação percentual da série
  double get variacaoPercent {
    if (pontos.length < 2) return 0.0;
    final primeiro = pontos.first.valor;
    final ultimo = pontos.last.valor;
    return primeiro != 0 ? ((ultimo - primeiro) / primeiro) * 100.0 : 0.0;
  }

  /// Valor atual (último ponto)
  double get valorAtual => pontos.isNotEmpty ? pontos.last.valor : 0.0;

  /// Está em alta?
  bool get emAlta => variacaoPercent >= 0;

  /// Estatísticas da série
  EstatisticasAtivo get estatisticas {
    if (pontos.isEmpty) {
      return EstatisticasAtivo(
        valorMinimo: 0.0,
        valorMaximo: 0.0,
        valorMedio: 0.0,
        variacaoTotal: 0.0,
        variacaoPercent: 0.0,
        volatilidade: 0.0,
      );
    }

    final valores = pontos.map((p) => p.valor).toList();
    final valorMinimo = valores.reduce((a, b) => a < b ? a : b);
    final valorMaximo = valores.reduce((a, b) => a > b ? a : b);
    final valorMedio = valores.reduce((a, b) => a + b) / valores.length;

    final valorInicial = valores.first;
    final valorFinal = valores.last;
    final variacaoTotal = valorFinal - valorInicial;
    final variacaoPercent =
        valorInicial != 0 ? (variacaoTotal / valorInicial) * 100.0 : 0.0;

    // Volatilidade (desvio padrão)
    final variancia = valores
            .map((v) => (v - valorMedio) * (v - valorMedio))
            .reduce((a, b) => a + b) /
        valores.length;
    final volatilidade = math.sqrt(variancia);

    return EstatisticasAtivo(
      valorMinimo: valorMinimo,
      valorMaximo: valorMaximo,
      valorMedio: valorMedio,
      variacaoTotal: variacaoTotal,
      variacaoPercent: variacaoPercent.toDouble(),
      volatilidade: volatilidade,
    );
  }

  factory SerieAtivo.fromJson(Map<String, dynamic> json) {
    return SerieAtivo(
      ativo: Ativo.fromJson(json['ativo']),
      pontos: (json['pontos'] as List?)
              ?.map((item) => PontoCotacao.fromJson(item))
              .toList() ??
          [],
      selecionado: json['selecionado'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ativo': ativo.toJson(),
      'pontos': pontos.map((item) => item.toJson()).toList(),
      'selecionado': selecionado,
    };
  }
}

/// Estatísticas de um ativo
class EstatisticasAtivo {
  final double valorMinimo;
  final double valorMaximo;
  final double valorMedio;
  final double variacaoTotal;
  final double variacaoPercent;
  final double volatilidade;

  EstatisticasAtivo({
    required this.valorMinimo,
    required this.valorMaximo,
    required this.valorMedio,
    required this.variacaoTotal,
    required this.variacaoPercent,
    required this.volatilidade,
  });
}

/// Tipos de ativos
enum TipoAtivo {
  acao,
  moeda,
  crypto,
  indice,
  commodity,
}

/// Extensões para tipos de ativos (labels e ícones)
extension TipoAtivoExtension on TipoAtivo {
  String get label {
    switch (this) {
      case TipoAtivo.acao:
        return 'Ações';
      case TipoAtivo.moeda:
        return 'Moedas';
      case TipoAtivo.crypto:
        return 'Criptomoedas';
      case TipoAtivo.indice:
        return 'Índices';
      case TipoAtivo.commodity:
        return 'Commodities';
    }
  }

  IconData get icon {
    switch (this) {
      case TipoAtivo.acao:
        return Icons.trending_up_rounded;
      case TipoAtivo.moeda:
        return Icons.currency_exchange_rounded;
      case TipoAtivo.crypto:
        return Icons.currency_bitcoin_rounded;
      case TipoAtivo.indice:
        return Icons.analytics_rounded;
      case TipoAtivo.commodity:
        return Icons.agriculture_rounded;
    }
  }
}

/// Filtros de período (sem acento em identificadores)
enum FiltroPeriodo {
  dia,
  semana,
  mes,
  trimestre,
  ano,
  tudo,
}

/// Extensão para labels de período
extension FiltroPeriodoExtension on FiltroPeriodo {
  String get label {
    switch (this) {
      case FiltroPeriodo.dia:
        return '1D';
      case FiltroPeriodo.semana:
        return '1S';
      case FiltroPeriodo.mes:
        return '1M';
      case FiltroPeriodo.trimestre:
        return '3M';
      case FiltroPeriodo.ano:
        return '1A';
      case FiltroPeriodo.tudo:
        return 'Tudo';
    }
  }
}

/// Processador de dados para ativos
class ProcessadorDadosAtivos {
  /// Cores padrão para tipos de ativos
  static const Map<TipoAtivo, List<Color>> coresPorTipo = {
    TipoAtivo.acao: [
      Color(0xFF00E676), // Verde
      Color(0xFF4CAF50), // Verde escuro
      Color(0xFF8BC34A), // Verde claro
    ],
    TipoAtivo.moeda: [
      Color(0xFF2196F3), // Azul
      Color(0xFF03A9F4), // Azul claro
      Color(0xFF3F51B5), // Azul escuro
    ],
    TipoAtivo.crypto: [
      Color(0xFFFFC107), // Amarelo
      Color(0xFFFF9800), // Laranja
      Color(0xFFFF5722), // Laranja escuro
    ],
    TipoAtivo.indice: [
      Color(0xFF9C27B0), // Roxo
      Color(0xFFE91E63), // Rosa
      Color(0xFF673AB7), // Roxo escuro
    ],
    TipoAtivo.commodity: [
      Color(0xFF795548), // Marrom
      Color(0xFF607D8B), // Azul acinzentado
      Color(0xFF9E9E9E), // Cinza
    ],
  };

  /// Cria configuração a partir de cotações
  static ConfiguracaoGraficoAtivos processarCotacoes({
    required List<CotacaoAtivo> cotacoes,
    required List<Ativo> ativos,
    required String titulo,
    String subtitulo = '',
    FiltroPeriodo periodo = FiltroPeriodo.mes,
    List<String>? ativosSelecionados,
  }) {
    // Agrupa cotações por ativo
    final Map<String, List<CotacaoAtivo>> cotacoesPorAtivo = {};
    for (final cotacao in cotacoes) {
      cotacoesPorAtivo.putIfAbsent(cotacao.ativoId, () => []).add(cotacao);
    }

    // Cria séries para cada ativo
    final List<SerieAtivo> series = [];

    for (final ativo in ativos) {
      final cotacoesAtivo = cotacoesPorAtivo[ativo.id] ?? [];

      // Ordena por data crescente
      cotacoesAtivo.sort((a, b) => a.data.compareTo(b.data));

      // Converte para pontos do gráfico
      final pontos = cotacoesAtivo
          .map((c) => PontoCotacao(data: c.data, valor: c.valorFechamento))
          .toList();

      series.add(SerieAtivo(
        ativo: ativo,
        pontos: pontos,
      ));
    }

    return ConfiguracaoGraficoAtivos(
      titulo: titulo,
      subtitulo: subtitulo,
      periodo: periodo,
      series: series,
      ativosSelecionados:
          ativosSelecionados ?? ativos.take(3).map((a) => a.id).toList(),
    );
  }

  /// Filtra cotações por período
  static List<CotacaoAtivo> filtrarCotacoesPorPeriodo(
    List<CotacaoAtivo> cotacoes,
    FiltroPeriodo periodo,
  ) {
    final agora = DateTime.now();
    late DateTime dataInicio;

    switch (periodo) {
      case FiltroPeriodo.dia:
        dataInicio = DateTime(agora.year, agora.month, agora.day);
        break;
      case FiltroPeriodo.semana:
        dataInicio = agora.subtract(const Duration(days: 7));
        break;
      case FiltroPeriodo.mes:
        dataInicio = DateTime(agora.year, agora.month - 1, agora.day);
        break;
      case FiltroPeriodo.trimestre:
        dataInicio = DateTime(agora.year, agora.month - 3, agora.day);
        break;
      case FiltroPeriodo.ano:
        dataInicio = DateTime(agora.year - 1, agora.month, agora.day);
        break;
      case FiltroPeriodo.tudo:
        return cotacoes; // Retorna todas
    }

    return cotacoes.where((c) => c.data.isAfter(dataInicio)).toList();
  }

  /// Gera cor automática para ativo baseada no tipo
  static Color gerarCorParaAtivo(Ativo ativo, int index) {
    final cores = coresPorTipo[ativo.tipo] ?? coresPorTipo[TipoAtivo.acao]!;
    return cores[index % cores.length];
  }

  /// Cria lista de ativos de exemplo
  static List<Ativo> criarAtivosExemplo() {
    return [
      Ativo(
        id: 'seu_capital',
        descricao: 'Seu Capital',
        cor: const Color(0xFF00E676),
        tipo: TipoAtivo.acao,
        simbolo: 'CAPITAL',
      ),
      Ativo(
        id: 'usd_brl',
        descricao: 'Dólar',
        cor: const Color(0xFF2196F3),
        tipo: TipoAtivo.moeda,
        simbolo: 'USD/BRL',
      ),
      Ativo(
        id: 'ibovespa',
        descricao: 'Bolsa (Ibovespa)',
        cor: const Color(0xFFFF5252),
        tipo: TipoAtivo.indice,
        simbolo: 'IBOV',
      ),
      Ativo(
        id: 'igpm',
        descricao: 'IGPM',
        cor: const Color(0xFFFFC107),
        tipo: TipoAtivo.indice,
        simbolo: 'IGPM',
      ),
      Ativo(
        id: 'selic',
        descricao: 'Taxa de Juros (Selic)',
        cor: const Color(0xFF9C27B0),
        tipo: TipoAtivo.indice,
        simbolo: 'SELIC',
      ),
      Ativo(
        id: 'btc_usd',
        descricao: 'Bitcoin',
        cor: const Color(0xFFFF9800),
        tipo: TipoAtivo.crypto,
        simbolo: 'BTC/USD',
      ),
      Ativo(
        id: 'eth_usd',
        descricao: 'Ethereum',
        cor: const Color(0xFF673AB7),
        tipo: TipoAtivo.crypto,
        simbolo: 'ETH/USD',
      ),
      Ativo(
        id: 'eur_brl',
        descricao: 'Euro',
        cor: const Color(0xFF03A9F4),
        tipo: TipoAtivo.moeda,
        simbolo: 'EUR/BRL',
      ),
      Ativo(
        id: 'ouro',
        descricao: 'Ouro',
        cor: const Color(0xFF795548),
        tipo: TipoAtivo.commodity,
        simbolo: 'GOLD',
      ),
      Ativo(
        id: 'petroleo',
        descricao: 'Petróleo',
        cor: const Color(0xFF607D8B),
        tipo: TipoAtivo.commodity,
        simbolo: 'OIL',
      ),
    ];
  }
}

/// Configuração do gráfico de ativos
class ConfiguracaoGraficoAtivos {
  final String titulo;
  final String subtitulo;
  final FiltroPeriodo periodo;
  final List<SerieAtivo> series;
  final List<String> ativosSelecionados;
  final bool mostrarGrid;
  final bool mostrarLegenda;
  final bool animado;

  ConfiguracaoGraficoAtivos({
    required this.titulo,
    this.subtitulo = '',
    required this.periodo,
    required this.series,
    required this.ativosSelecionados,
    this.mostrarGrid = true,
    this.mostrarLegenda = true,
    this.animado = true,
  });

  /// Retorna as séries selecionadas
  List<SerieAtivo> get seriesSelecionadas {
    return series
        .where((serie) => ativosSelecionados.contains(serie.ativo.id))
        .toList();
  }

  /// Retorna todos os ativos disponíveis
  List<Ativo> get ativosDisponiveis {
    return series.map((serie) => serie.ativo).toList();
  }

  factory ConfiguracaoGraficoAtivos.fromJson(Map<String, dynamic> json) {
    return ConfiguracaoGraficoAtivos(
      titulo: json['titulo'] ?? '',
      subtitulo: json['subtitulo'] ?? '',
      periodo: FiltroPeriodo.values.firstWhere(
        (e) => e.toString().split('.').last == json['periodo'],
        orElse: () => FiltroPeriodo.mes,
      ),
      series: (json['series'] as List?)
              ?.map((item) => SerieAtivo.fromJson(item))
              .toList() ??
          [],
      ativosSelecionados: List<String>.from(json['ativosSelecionados'] ?? []),
      mostrarGrid: json['mostrarGrid'] ?? true,
      mostrarLegenda: json['mostrarLegenda'] ?? true,
      animado: json['animado'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'subtitulo': subtitulo,
      'periodo': periodo.toString().split('.').last,
      'series': series.map((item) => item.toJson()).toList(),
      'ativosSelecionados': ativosSelecionados,
      'mostrarGrid': mostrarGrid,
      'mostrarLegenda': mostrarLegenda,
      'animado': animado,
    };
  }
}
