import 'package:flutter/material.dart';

class MenuInferiorCliente extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MenuInferiorCliente({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor, // Suporte a tema
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black26
                : Colors.grey.withOpacity(0.2), // Sombra adaptável
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary, // Azul do tema
        unselectedItemColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Carteiras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Estratégias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Notícia',
          ),
        ],
      ),
    );
  }
}
