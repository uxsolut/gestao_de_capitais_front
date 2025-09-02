import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';
import '../../models/dialog_lista_model.dart';

class DialogLista extends StatefulWidget {
  final String titulo;
  final List<DialogListaModel> itens;

  /// Se true (padrão) e houver [onSelecionar], os itens serão clicáveis.
  /// Se false, nunca serão clicáveis (mesmo com [onSelecionar] setado).
  final bool clicavel;

  final void Function(DialogListaModel)? onSelecionar;
  final void Function(DialogListaModel)? onDelete;
  final bool Function(DialogListaModel, String filtro)? filtroPersonalizado;

  const DialogLista({
    super.key,
    required this.titulo,
    required this.itens,
    this.clicavel = true,
    this.onSelecionar,
    this.onDelete,
    this.filtroPersonalizado,
  });

  @override
  State<DialogLista> createState() => _DialogListaState();
}

class _DialogListaState extends State<DialogLista> {
  final TextEditingController _filtroController = TextEditingController();
  int _hoveredIndex = -1;

  String _normalizar(String texto) => removeDiacritics(texto).toLowerCase().trim();

  List<DialogListaModel> _aplicarFiltro() {
    final texto = _filtroController.text;
    if (texto.isEmpty) return widget.itens;

    if (widget.filtroPersonalizado != null) {
      return widget.itens.where((i) => widget.filtroPersonalizado!(i, texto)).toList();
    }

    final filtro = _normalizar(texto);
    return widget.itens.where((item) => _normalizar(item.titulo).contains(filtro)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itensFiltrados = _aplicarFiltro();

    final canClick = widget.clicavel && widget.onSelecionar != null;

    return Dialog(
      backgroundColor: theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 400,
          height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.titulo,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _filtroController,
                decoration: InputDecoration(
                  hintText: 'Filtrar por nome...',
                  hintStyle: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  filled: true,
                  fillColor: theme.cardColor.withOpacity(0.1),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                ),
                style: theme.textTheme.bodyMedium,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: itensFiltrados.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum item encontrado.',
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor),
                        ),
                      )
                    : ListView.builder(
                        itemCount: itensFiltrados.length,
                        itemBuilder: (context, index) {
                          final item = itensFiltrados[index];
                          final isHovered = _hoveredIndex == index;

                          final card = Card(
                            color: isHovered
                                ? theme.hoverColor.withOpacity(0.15)
                                : theme.cardColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.titulo, style: theme.textTheme.bodyLarge),
                                        if (item.linha1 != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              item.linha1!,
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                        if (item.linha2 != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Text(
                                              item.linha2!,
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.colorScheme.secondary,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (widget.onDelete != null)
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      tooltip: 'Excluir',
                                      color: Theme.of(context).colorScheme.error,
                                      onPressed: () => widget.onDelete!(item),
                                    ),
                                ],
                              ),
                            ),
                          );

                          return MouseRegion(
                            onEnter: (_) => setState(() => _hoveredIndex = index),
                            onExit: (_) => setState(() => _hoveredIndex = -1),
                            cursor: canClick ? SystemMouseCursors.click : SystemMouseCursors.basic,
                            child: canClick
                                ? Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        widget.onSelecionar!(item);
                                        Navigator.of(context).maybePop();
                                      },
                                      child: card,
                                    ),
                                  )
                                : card,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _filtroController.dispose();
    super.dispose();
  }
}
