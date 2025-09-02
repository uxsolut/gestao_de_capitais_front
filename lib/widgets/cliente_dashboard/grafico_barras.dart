import 'package:flutter/material.dart';
import '../../models/cliente_dashboard/grafico_barras_model.dart';
import '../../themes/theme.dart'; // necessário

class GraficoBarrasAnimado extends StatefulWidget {
  final GraficoBarrasModel dados;

  const GraficoBarrasAnimado({super.key, required this.dados});

  @override
  State<GraficoBarrasAnimado> createState() => _GraficoBarrasAnimadoState();
}

class _GraficoBarrasAnimadoState extends State<GraficoBarrasAnimado>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isHovered = false;

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
    final labels = widget.dados.labels;
    final valores = widget.dados.valores;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.darkBackgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : AppTheme.defaultShadow,
          border: _isHovered
              ? Border.all(
                  color: AppTheme.primaryBlue.withOpacity(0.5),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título dinâmico
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.dados.titulo,
                  style: const TextStyle(
                    color: AppTheme.darkTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.dados.mostrarIcone)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.bar_chart,
                      color: AppTheme.primaryBlue,
                      size: 16,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Gráfico de barras animado
            SizedBox(
              height: 200,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: valores.asMap().entries.map((entry) {
                      int index = entry.key;
                      double value = entry.value;
                      return _buildAnimatedBar(value * _animation.value, index);
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Labels eixo X
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: labels.map((label) {
                return Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.darkTextSecondary.withOpacity(0.7),
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBar(double height, int index) {
    return MouseRegion(
      onEnter: (_) {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 30,
        height: 200 * height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppTheme.primaryBlue,
              AppTheme.primaryBlue.withOpacity(0.7),
              AppTheme.primaryBlue.withOpacity(0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppTheme.primaryBlue.withOpacity(0.8),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
