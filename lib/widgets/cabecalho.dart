import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // Para usar context.pop()

import '../../../themes/theme.dart';
import '../../controllers/theme_controller.dart';

class Cabecalho extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final bool isMobile;
  final bool mostrarVoltar; // 👈 Novo parâmetro

  const Cabecalho({
    super.key,
    required this.titulo,
    this.subtitulo,
    required this.isMobile,
    this.mostrarVoltar = false, // valor padrão: não mostra
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Lado esquerdo: seta (opcional) + textos
          Row(
            children: [
              if (mostrarVoltar)
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  tooltip: "Voltar",
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: subtitulo == null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: isMobile ? 20 : 24,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  if (subtitulo != null) const SizedBox(height: 4),
                  if (subtitulo != null)
                    Text(
                      subtitulo!,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Lado direito: container com ícones
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.shadowColor.withOpacity(0.2),
                  theme.cardColor.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: theme.textTheme.bodyLarge?.color?.withOpacity(0.1) ??
                    Colors.grey.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Tooltip(
                  message: "Notificações",
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: theme.iconTheme.color,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Tooltip(
                  message: "Configurações",
                  child: IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    color: theme.iconTheme.color,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<ThemeController>(
                  builder: (context, themeController, _) {
                    return Tooltip(
                      message: themeController.isDarkMode
                          ? 'Tema Claro'
                          : 'Tema Escuro',
                      child: IconButton(
                        icon: Icon(
                          themeController.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                        color: theme.iconTheme.color,
                        onPressed: () => themeController.toggleTheme(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF007AFF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.transparent,
                    child: Text(
                      "P",
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
