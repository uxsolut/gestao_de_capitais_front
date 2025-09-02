import 'package:flutter/material.dart';

class TopoFixo extends StatelessWidget {
  const TopoFixo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Fundo com opacidade e sombra para visual "glass"
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.2),
            Colors.grey.shade900.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Tooltip(
            message: "Notificações",
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
          Tooltip(
            message: "Configurações",
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              color: Colors.white,
              onPressed: () {},
            ),
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
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.transparent,
              child: Text(
                "P",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
