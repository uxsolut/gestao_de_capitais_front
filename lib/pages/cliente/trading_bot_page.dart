// lib/pages/cliente/trading_bot_page.dart
import 'package:flutter/material.dart';
import '../../widgets/cabecalho.dart';
import '../../widgets/trading_bot_widget.dart';

class TradingBotPage extends StatelessWidget {
  final String idRobo;

  const TradingBotPage({super.key, required this.idRobo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Cabecalho(
                titulo: 'Trading Bot',
                isMobile: isMobile,
                mostrarVoltar: true,
              ),
              const SizedBox(height: 16),

              // 🔒 Bounded height pro conteúdo
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Card(
                      elevation: 0,
                      color: theme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: TradingBotWidget(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
