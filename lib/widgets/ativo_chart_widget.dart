import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/ativo_chart_model.dart';
import 'dart:math' as math;

class AtivoChartWidget extends StatefulWidget {
  final ConfiguracaoGraficoAtivos configuracao;
  final Function(FiltroPeriodo)? onPeriodoChanged;
  final Function(List<String>)? onAtivosSelecionadosChanged;
  final Function()? onRefreshData;
  final double height;

  const AtivoChartWidget({
    Key? key,
    required this.configuracao,
    this.onPeriodoChanged,
    this.onAtivosSelecionadosChanged,
    this.onRefreshData,
    this.height = 300,
  }) : super(key: key);

  @override
  State<AtivoChartWidget> createState() => _AtivoChartWidgetState();
}

class _AtivoChartWidgetState extends State<AtivoChartWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _glowController;
  late Animation<double> _animation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    if (widget.configuracao.animado) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    return Container(
      height: widget.height + 140,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: isDark
            ? null
            : Border.all(color: Colors.grey.withOpacity(0.08), width: 0.5),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark),
            _buildControls(isDark),
            if (widget.configuracao.mostrarLegenda) _buildLegend(isDark),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildChart(isDark),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.configuracao.titulo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    letterSpacing: 0.3,
                  ),
                ),
                if (widget.configuracao.subtitulo.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.configuracao.subtitulo,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showGerenciarAtivosDialog(context, isDark),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF00E676).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF00E676).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.tune_rounded, size: 16, color: Color(0xFF00E676)),
                  SizedBox(width: 6),
                  Text(
                    'Gerenciar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00E676),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF00E676),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E676)
                          .withOpacity(_glowAnimation.value * 0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControls(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey[900]?.withOpacity(0.3)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark
                      ? Colors.grey[800]?.withOpacity(0.5) ??
                          Colors.transparent
                      : Colors.grey[200]?.withOpacity(0.5) ??
                          Colors.transparent,
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: FiltroPeriodo.values.map((periodo) {
                  final isSelected = periodo == widget.configuracao.periodo;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onPeriodoChanged?.call(periodo),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00E676)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          periodo.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.black
                                : (isDark ? Colors.grey[400] : Colors.grey[600]),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: widget.onRefreshData,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.grey[900]?.withOpacity(0.3)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? Colors.grey[800]?.withOpacity(0.5) ??
                          Colors.transparent
                      : Colors.grey[200]?.withOpacity(0.5) ??
                          Colors.transparent,
                  width: 0.5,
                ),
              ),
              child: Icon(
                Icons.refresh_rounded,
                size: 16,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(bool isDark) {
    final seriesSelecionadas = widget.configuracao.seriesSelecionadas;

    if (seriesSelecionadas.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Text(
          'Nenhum ativo selecionado',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[500] : Colors.grey[600],
            letterSpacing: 0.2,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: seriesSelecionadas.map((serie) {
          final stats = serie.estatisticas;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: serie.ativo.cor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: serie.ativo.cor.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: serie.ativo.cor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  serie.ativo.descricao,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${serie.emAlta ? '+' : ''}${stats.variacaoPercent.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: serie.ativo.cor,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart(bool isDark) {
    final seriesSelecionadas = widget.configuracao.seriesSelecionadas;

    if (seriesSelecionadas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 48,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'Selecione ativos para visualizar',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showGerenciarAtivosDialog(context, isDark),
              child: const Text(
                'Toque em "Gerenciar" para escolher',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF00E676),
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return LineChart(
          LineChartData(
            gridData: FlGridData(
              show: widget.configuracao.mostrarGrid,
              drawVerticalLine: true,
              drawHorizontalLine: true,
              getDrawingHorizontalLine: (value) => FlLine(
                color:
                    (isDark ? Colors.grey[800] : Colors.grey[200])!.withOpacity(0.3),
                strokeWidth: 0.5,
              ),
              getDrawingVerticalLine: (value) => FlLine(
                color:
                    (isDark ? Colors.grey[800] : Colors.grey[200])!.withOpacity(0.3),
                strokeWidth: 0.5,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) => SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      _formatXAxisLabel(value.toInt(), seriesSelecionadas),
                      style: TextStyle(
                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) => SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      _formatYAxisLabel(value),
                      style: TextStyle(
                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color:
                    (isDark ? Colors.grey[800] : Colors.grey[200])!.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            lineBarsData: seriesSelecionadas.map((serie) {
              final spots = _createSpotsFromSerie(serie);
              final animatedSpots =
                  spots.take((spots.length * _animation.value).round()).toList();

              return LineChartBarData(
                spots: animatedSpots,
                isCurved: true,
                color: serie.ativo.cor,
                barWidth: 1.5,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: false,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      serie.ativo.cor.withOpacity(0.1),
                      serie.ativo.cor.withOpacity(0.02),
                    ],
                  ),
                ),
                shadow: Shadow(
                  color: serie.ativo.cor.withOpacity(0.2),
                  blurRadius: 3,
                ),
              );
            }).toList(),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                // Compatível com fl_chart 0.68.x
                getTooltipColor: (touchedSpot) =>
                    (isDark ? const Color(0xFF2A2A2A) : Colors.white)
                        .withOpacity(0.95),
                tooltipPadding: const EdgeInsets.all(8),
                tooltipBorder: BorderSide(
                  color: (isDark ? Colors.grey[700] : Colors.grey[300])!,
                  width: 0.5,
                ),
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final serie = seriesSelecionadas[spot.barIndex];
                    return LineTooltipItem(
                      '${serie.ativo.simbolo}\n${_formatCurrency(spot.y)}',
                      TextStyle(
                        color: serie.ativo.cor,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showGerenciarAtivosDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => GerenciarAtivosDialog(
        configuracao: widget.configuracao,
        isDark: isDark,
        onAtivosSelecionadosChanged: widget.onAtivosSelecionadosChanged,
      ),
    );
  }

  List<FlSpot> _createSpotsFromSerie(SerieAtivo serie) {
    return serie.pontos
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.valor))
        .toList();
  }

  String _formatXAxisLabel(int index, List<SerieAtivo> series) {
    if (series.isEmpty || index >= series.first.pontos.length) return '';
    final data = series.first.pontos[index].data;

    switch (widget.configuracao.periodo) {
      case FiltroPeriodo.dia:
        return '${data.hour.toString().padLeft(2, '0')}h';
      case FiltroPeriodo.semana:
        return '${data.day}/${data.month}';
      case FiltroPeriodo.mes:
      case FiltroPeriodo.trimestre:
        return '${data.day}/${data.month}';
      case FiltroPeriodo.ano:
      case FiltroPeriodo.tudo:
        return '${data.month}/${data.year.toString().substring(2)}';
    }
  }

  String _formatYAxisLabel(double value) => _formatCurrency(value);

  String _formatCurrency(double value) {
    if (value >= 1000000000) return '${(value / 1000000000).toStringAsFixed(1)}B';
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }
}

/// Dialog para gerenciar ativos selecionados
class GerenciarAtivosDialog extends StatefulWidget {
  final ConfiguracaoGraficoAtivos configuracao;
  final bool isDark;
  final Function(List<String>)? onAtivosSelecionadosChanged;

  const GerenciarAtivosDialog({
    Key? key,
    required this.configuracao,
    required this.isDark,
    this.onAtivosSelecionadosChanged,
  }) : super(key: key);

  @override
  State<GerenciarAtivosDialog> createState() => _GerenciarAtivosDialogState();
}

class _GerenciarAtivosDialogState extends State<GerenciarAtivosDialog> {
  late List<String> ativosSelecionados;
  Map<TipoAtivo, bool> tiposExpandidos = {};

  @override
  void initState() {
    super.initState();
    ativosSelecionados = List.from(widget.configuracao.ativosSelecionados);
    for (final tipo in TipoAtivo.values) {
      tiposExpandidos[tipo] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = widget.isDark ? const Color(0xFF1A1A1A) : Colors.white;

    // Agrupa ativos por tipo
    final Map<TipoAtivo, List<Ativo>> ativosPorTipo = {};
    for (final ativo in widget.configuracao.ativosDisponiveis) {
      ativosPorTipo.putIfAbsent(ativo.tipo, () => []).add(ativo);
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: widget.isDark
              ? null
              : Border.all(color: Colors.grey.withOpacity(0.1), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: widget.isDark
                        ? Colors.grey[800]!.withOpacity(0.3)
                        : Colors.grey[200]!.withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Gerenciar Ativos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.isDark
                            ? Colors.grey[800]?.withOpacity(0.3)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color:
                            widget.isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de ativos por tipo
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: TipoAtivo.values.map((tipo) {
                  final ativos = ativosPorTipo[tipo] ?? [];
                  if (ativos.isEmpty) return const SizedBox.shrink();
                  return _buildTipoAtivoSection(tipo, ativos);
                }).toList(),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: widget.isDark
                        ? Colors.grey[800]!.withOpacity(0.3)
                        : Colors.grey[200]!.withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '${ativosSelecionados.length} ativos selecionados',
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                      letterSpacing: 0.2,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() => ativosSelecionados.clear()),
                    child: Text(
                      'Limpar',
                      style: TextStyle(
                        color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      widget.onAtivosSelecionadosChanged?.call(ativosSelecionados);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Aplicar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipoAtivoSection(TipoAtivo tipo, List<Ativo> ativos) {
    final isExpandido = tiposExpandidos[tipo] ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color:
            widget.isDark ? Colors.grey[900]?.withOpacity(0.2) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDark
              ? Colors.grey[800]?.withOpacity(0.3) ?? Colors.transparent
              : Colors.grey[200]?.withOpacity(0.5) ?? Colors.transparent,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // Header do tipo
          GestureDetector(
            onTap: () =>
                setState(() => tiposExpandidos[tipo] = !isExpandido),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    tipo.icon,
                    size: 20,
                    color: widget.isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tipo.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            widget.isDark ? Colors.white : const Color(0xFF1A1A1A),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Text(
                    '${ativos.where((a) => ativosSelecionados.contains(a.id)).length}/${ativos.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpandido
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),

          // Lista de ativos
          if (isExpandido)
            ...ativos.map((ativo) => _buildAtivoItem(ativo)).toList(),
        ],
      ),
    );
  }

  Widget _buildAtivoItem(Ativo ativo) {
    final isSelected = ativosSelecionados.contains(ativo.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            ativosSelecionados.remove(ativo.id);
          } else {
            ativosSelecionados.add(ativo.id);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? ativo.cor.withOpacity(0.08) : Colors.transparent,
          border: Border(
            top: BorderSide(
              color: widget.isDark
                  ? Colors.grey[800]?.withOpacity(0.2) ?? Colors.transparent
                  : Colors.grey[200]?.withOpacity(0.3) ?? Colors.transparent,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Checkbox customizado
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? ativo.cor : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? ativo.cor
                      : (widget.isDark ? Colors.grey[600]! : Colors.grey[400]!),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            // Cor do ativo
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: ativo.cor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Info do ativo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ativo.descricao,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color:
                          widget.isDark ? Colors.white : const Color(0xFF1A1A1A),
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    ativo.simbolo,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
