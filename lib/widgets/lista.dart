import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/lista_model.dart';
import '../../themes/theme.dart';

class Lista extends StatelessWidget {
  final bool isMobile;
  final String tituloLista;
  final List<ListaModel> itens;
  final void Function(ListaModel)? onDownload;
  final void Function(ListaModel)? onEdit;
  final void Function(ListaModel)? onDelete;
  final void Function()? onAdicionar;
  final void Function(ListaModel)? onTapItem;
  final void Function(ListaModel)? onAcaoExtra1;
  final void Function(ListaModel)? onAcaoExtra2;
  final String? textoAcaoExtra1;
  final String? textoAcaoExtra2; 

  const Lista({
    super.key,
    required this.isMobile,
    required this.tituloLista,
    required this.itens,
    this.onDownload,
    this.onEdit,
    this.onDelete,
    this.onAdicionar,
    this.onTapItem,
    this.onAcaoExtra1,
    this.onAcaoExtra2,
    this.textoAcaoExtra1,
    this.textoAcaoExtra2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tituloLista,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Total: ${itens.length}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                    if (onAdicionar != null) ...[
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: onAdicionar,
                        style: TextButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('Adicionar'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          ...itens.map((item) {
            final hovered = ValueNotifier(false);

            Widget itemCard = MouseRegion(
              onEnter: (_) => hovered.value = true,
              onExit: (_) => hovered.value = false,
              cursor: onTapItem != null ? SystemMouseCursors.click : MouseCursor.defer,
              child: ValueListenableBuilder<bool>(
                valueListenable: hovered,
                builder: (context, isHovered, _) {
                  return GestureDetector(
                    onTap: onTapItem != null ? () => onTapItem!(item) : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 20,
                        vertical: 8,
                      ),
                      padding: EdgeInsets.all(isMobile ? 16 : 20),
                      decoration: BoxDecoration(
                        color: isHovered
                            ? theme.colorScheme.primary.withOpacity(0.05)
                            : context.itemBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cabeçalho do item
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.tituloItem ?? '',
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (item.descricao1 != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          item.descricao1!,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                    if (item.descricao2 != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          item.descricao2!,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    if (item.descricao3 != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          item.descricao3!,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  if (item.dataHora != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        dateFormat.format(item.dataHora!),
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                  if (item.podeBaixar && onDownload != null)
                                    IconButton(
                                      icon: const Icon(Icons.download),
                                      color: const Color(0xFF4285F4),
                                      tooltip: 'Baixar',
                                      onPressed: () => onDownload!(item),
                                    ),
                                  if (item.podeEditar && onEdit != null)
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: const Color(0xFFFF9800),
                                      tooltip: 'Editar',
                                      onPressed: () => onEdit!(item),
                                    ),
                                  if (item.podeDeletar && onDelete != null)
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: Theme.of(context).colorScheme.error,
                                      tooltip: 'Excluir',
                                      onPressed: () => onDelete!(item),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          if (item.tags != null && item.tags!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Tags:',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: item.tags!
                                  .map(
                                    (tag) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        tag,
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],

                          // 👇 NOVOS BOTÕES
                          if (onAcaoExtra1 != null || onAcaoExtra2 != null) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                if (onAcaoExtra1 != null)
                                  TextButton(
                                    onPressed: () => onAcaoExtra1!(item),
                                    style: TextButton.styleFrom(
                                      backgroundColor: theme.colorScheme.primary,
                                      foregroundColor: theme.colorScheme.onPrimary,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    child: Text(textoAcaoExtra1 ?? 'Ação 1'),
                                  ),
                                if (onAcaoExtra2 != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: TextButton(
                                      onPressed: () => onAcaoExtra2!(item),
                                      style: TextButton.styleFrom(
                                        backgroundColor: theme.colorScheme.primary,
                                        foregroundColor: theme.colorScheme.onPrimary,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                      child: Text(textoAcaoExtra2 ?? 'Ação 2'),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            );

            return itemCard;
          }).toList(),
        ],
      ),
    );
  }
}
