import 'package:flutter/material.dart';

class GraficoPizzaItem {
  final String label;       // Ex: "Brasil", "Estados Unidos", "Outros"
  final double valor;       // Valor absoluto
  final double porcentagem; // 0..100
  final Color cor;

  GraficoPizzaItem({
    required this.label,
    required this.valor,
    required this.porcentagem,
    required this.cor,
  });
}

class GraficoPizzaDados {
  final String titulo;
  final List<GraficoPizzaItem> itens;

  GraficoPizzaDados({
    required this.titulo,
    required this.itens,
  });
}
