import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/cliente_dashboard/grafico_pizza_model.dart';

class ClienteGraficoPizza extends StatefulWidget {
  final GraficoPizzaDados dados;

  const ClienteGraficoPizza({super.key, required this.dados});

  @override
  State<ClienteGraficoPizza> createState() => _ClienteGraficoPizzaState();
}

class _ClienteGraficoPizzaState extends State<ClienteGraficoPizza>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isHovered = false;
  int _hoveredIndex = -1;

  // altura prevista de cada linha da legenda
  static const double _legendRowHeight = 34.0;
  static const int _legendRowsVisible = 3; // mostra 3; o resto rola

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.dados.itens;
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _hoveredIndex = -1;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: _isHovered
              ? Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.5), width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.dados.titulo,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.pie_chart,
                      color: theme.colorScheme.primary, size: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _CustomPieChartPainter(
                          data: data,
                          animationValue: _animation.value,
                          hoveredIndex: _hoveredIndex,
                          backgroundColor: theme.scaffoldBackgroundColor,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),

                // ===== LEGENDA com scroll se tiver mais de 3 itens =====
                Expanded(
                  child: _LegendScrollable(
                    data: data,
                    rowBuilder: (item, index) =>
                        _buildLegendItem(item, index, theme),
                    rowHeight: _legendRowHeight,
                    visibleRows: _legendRowsVisible,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(GraficoPizzaItem data, int index, ThemeData theme) {
    final isHovered = _hoveredIndex == index;
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isHovered ? data.cor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: data.cor,
                shape: BoxShape.circle,
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: data.cor.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                data.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isHovered
                      ? theme.textTheme.bodyLarge?.color
                      : theme.textTheme.bodySmall?.color,
                  fontSize: 14,
                  fontWeight: isHovered ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            SizedBox(
  width: 56, // Ajuste se quiser mais ou menos espaço
  child: Text(
    '${data.porcentagem.toStringAsFixed(1)}%',
    textAlign: TextAlign.right,
    style: TextStyle(
      color: isHovered
          ? data.cor
          : theme.textTheme.bodySmall?.color?.withOpacity(0.7),
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}

/// Lista/legenda com rolagem vertical. Mostra 'visibleRows' linhas visíveis.
/// Se houver mais itens, aparece scrollbar e é possível rolar "infinitamente".
class _LegendScrollable extends StatelessWidget {
  final List<GraficoPizzaItem> data;
  final Widget Function(GraficoPizzaItem item, int index) rowBuilder;
  final double rowHeight;
  final int visibleRows;

  const _LegendScrollable({
    required this.data,
    required this.rowBuilder,
    required this.rowHeight,
    required this.visibleRows,
  });

  @override
  Widget build(BuildContext context) {
    final rows = data.length;
    final visible = rows < visibleRows ? rows : visibleRows;
    final height = (visible * rowHeight) + 8; // +8 p/ respiro

    return SizedBox(
      height: height <= 0 ? rowHeight : height,
      child: Scrollbar(
        thumbVisibility: rows > visibleRows,
        child: ListView.separated(
  itemCount: data.length,
  padding: const EdgeInsets.only(right: 16), // ← espaço pro scroll
  separatorBuilder: (_, __) => const SizedBox(height: 2),
  itemBuilder: (context, index) => rowBuilder(data[index], index),
),
      ),
    );
  }
}

class _CustomPieChartPainter extends CustomPainter {
  final List<GraficoPizzaItem> data;
  final double animationValue;
  final int hoveredIndex;
  final Color backgroundColor;

  _CustomPieChartPainter({
    required this.data,
    required this.animationValue,
    required this.hoveredIndex,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    double total = data.fold(0, (sum, item) => sum + item.valor);
    if (total <= 0) return; // evita divisão por zero

    double startAngle = -math.pi / 2;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle =
          (data[i].valor / total) * 2 * math.pi * animationValue;
      final isHovered = hoveredIndex == i;
      final currentRadius = isHovered ? radius + 5 : radius;

      final paint = Paint()
        ..color = data[i].cor
        ..style = PaintingStyle.fill;

      if (isHovered) {
        final shadowPaint = Paint()
          ..color = data[i].cor.withOpacity(0.3)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: currentRadius + 3),
          startAngle,
          sweepAngle,
          true,
          shadowPaint,
        );
      }

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: currentRadius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      final borderPaint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: currentRadius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      startAngle += sweepAngle;
    }

    // “furo” do donut
    canvas.drawCircle(center, radius * 0.4, Paint()..color = backgroundColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
