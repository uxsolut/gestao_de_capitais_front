import 'package:flutter/material.dart';

class MetricaItem {
  final String titulo;
  final int valor;
  final IconData icone;
  final Color corIcone;

  MetricaItem({
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.corIcone,
  });
}

class MetricasModel {
  final List<MetricaItem> metricas;

  MetricasModel({required this.metricas});
}
