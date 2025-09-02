class ListaModel {
  final int id;

  final String? tituloItem;     // Título principal de cada item
  final String? descricao1;     // Primeira linha de descrição
  final String? descricao2;     // Segunda linha (opcional)
  final String? descricao3;     // Terceira linha (opcional)

  final DateTime? dataHora;     // Data de criação ou atualização
  final List<String>? tags;     // Tags visuais

  final bool podeBaixar;
  final bool podeEditar;
  final bool podeDeletar;

  ListaModel({
    required this.id,
    this.tituloItem,
    this.descricao1,
    this.descricao2,
    this.descricao3,
    this.dataHora,
    this.tags,
    this.podeBaixar = false,
    this.podeEditar = false,
    this.podeDeletar = false,
  });
}
