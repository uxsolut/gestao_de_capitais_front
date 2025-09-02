class GraficoBarrasModel {
  final String titulo;
  final List<String> labels;
  final List<double> valores;
  final bool mostrarIcone;

  const GraficoBarrasModel({
    required this.titulo,
    required this.labels,
    required this.valores,
    this.mostrarIcone = true,
  });
}
