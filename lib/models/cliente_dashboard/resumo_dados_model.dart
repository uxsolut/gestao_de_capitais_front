import 'package:flutter/material.dart';

class ResumoDadosModel {
  final List<ResumoGrupo> grupos;

  ResumoDadosModel({required this.grupos});
}

class ResumoGrupo {
  final String titulo;
  final IconData icone;
  final Color corIcone;
  final List<String> itens;

  ResumoGrupo({
    required this.titulo,
    required this.icone,
    required this.corIcone,
    required this.itens,
  });
}
