class DialogListaModel {
  final int id;
  final String titulo;
  final String? linha1;
  final String? linha2;

  DialogListaModel({
    required this.id,
    required this.titulo,
    this.linha1,
    this.linha2,
  });
}
