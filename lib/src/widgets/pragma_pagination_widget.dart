import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_spacing.dart';

/// Tonos soportados por el widget de paginación.
enum PragmaPaginationTone { dark, light }

/// Datos calculados que pueden usarse para construir el summary.
class PragmaPaginationSummary {
  const PragmaPaginationSummary({
    required this.currentPage,
    required this.totalPages,
    this.itemsPerPage,
    this.totalItems,
    this.firstItemIndex,
    this.lastItemIndex,
  });

  final int currentPage;
  final int totalPages;
  final int? itemsPerPage;
  final int? totalItems;
  final int? firstItemIndex;
  final int? lastItemIndex;
}

/// Builder opcional para personalizar el texto del summary.
typedef PragmaPaginationSummaryBuilder = String Function(
  PragmaPaginationSummary summary,
);

/// Componente que replica la paginación con cápsula glow, botones numerados,
/// flechas y selector de registros por página.
class PragmaPaginationWidget extends StatelessWidget {
  const PragmaPaginationWidget({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    super.key,
    this.itemsPerPage,
    this.itemsPerPageOptions = const <int>[10, 25, 50, 100],
    this.onItemsPerPageChanged,
    this.totalItems,
    this.enabled = true,
    this.tone = PragmaPaginationTone.dark,
    this.showSummary = true,
    this.summaryBuilder,
  }) : assert(totalPages > 0, 'Declara al menos una página.');

  /// Página actual (1-based).
  final int currentPage;

  /// Total de páginas disponibles.
  final int totalPages;

  /// Callback que se dispara al cambiar la página actual.
  final ValueChanged<int> onPageChanged;

  /// Tamaño actual seleccionado para "items por página".
  final int? itemsPerPage;

  /// Listado de opciones disponibles para el dropdown.
  final List<int> itemsPerPageOptions;

  /// Callback cuando el usuario selecciona un valor distinto en el dropdown.
  final ValueChanged<int>? onItemsPerPageChanged;

  /// Total de registros para calcular el summary (opcional).
  final int? totalItems;

  /// Controla si el widget responde a interacciones.
  final bool enabled;

  /// Cambia la superficie entre light/dark para combinar con la tabla.
  final PragmaPaginationTone tone;

  /// Muestra el texto inferior con el resumen calculado.
  final bool showSummary;

  /// Permite personalizar el texto del summary.
  final PragmaPaginationSummaryBuilder? summaryBuilder;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final _PaginationSurfaceStyle style =
        _PaginationSurfaceStyle.resolve(scheme, tone);

    final int safeTotalPages = math.max(1, totalPages);
    final int safeCurrentPage = currentPage.clamp(1, safeTotalPages);

    final List<int> normalizedOptions = _normalizedPerPageOptions();
    if (itemsPerPage != null && !normalizedOptions.contains(itemsPerPage)) {
      normalizedOptions.add(itemsPerPage!);
      normalizedOptions.sort();
    }

    final int? effectivePerPage = _resolveItemsPerPage(normalizedOptions);
    final bool showPerPageSelector =
        onItemsPerPageChanged != null && normalizedOptions.isNotEmpty;

    final List<_PaginationEntry> entries =
        _buildPaginationEntries(safeCurrentPage, safeTotalPages);

    final Widget pager = DecoratedBox(
      decoration: style.decoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PragmaSpacing.md,
          vertical: PragmaSpacing.sm,
        ),
        child: Wrap(
          spacing: PragmaSpacing.xs,
          runSpacing: PragmaSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            _PaginationArrowButton(
              icon: Icons.chevron_left,
              semanticsLabel: 'Página anterior',
              enabled: enabled && safeCurrentPage > 1,
              style: style,
              onPressed: () {
                if (safeCurrentPage > 1) {
                  onPageChanged(safeCurrentPage - 1);
                }
              },
            ),
            ...entries.map(
              (
                _PaginationEntry entry,
              ) =>
                  _buildEntry(
                context,
                entry: entry,
                style: style,
                isCurrent: entry.page == safeCurrentPage,
                enabled: enabled,
              ),
            ),
            _PaginationArrowButton(
              icon: Icons.chevron_right,
              semanticsLabel: 'Página siguiente',
              enabled: enabled && safeCurrentPage < safeTotalPages,
              style: style,
              onPressed: () {
                if (safeCurrentPage < safeTotalPages) {
                  onPageChanged(safeCurrentPage + 1);
                }
              },
            ),
          ],
        ),
      ),
    );

    final List<Widget> rowChildren = <Widget>[pager];

    if (showPerPageSelector && effectivePerPage != null) {
      rowChildren.add(
        _PerPageSelector(
          value: effectivePerPage,
          options: normalizedOptions,
          onSelected: (int value) => onItemsPerPageChanged?.call(value),
          style: style,
          enabled: enabled,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: PragmaSpacing.md,
          runSpacing: PragmaSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: rowChildren,
        ),
        if (showSummary) ...<Widget>[
          const SizedBox(height: PragmaSpacing.xs),
          Text(
            _summaryLabel(
              currentPage: safeCurrentPage,
              totalPages: safeTotalPages,
              itemsPerPage: effectivePerPage,
              totalItems: totalItems,
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEntry(
    BuildContext context, {
    required _PaginationEntry entry,
    required _PaginationSurfaceStyle style,
    required bool isCurrent,
    required bool enabled,
  }) {
    if (entry.isGap) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: PragmaSpacing.xs),
        child: Text(
          '…',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: style.subduedForeground,
                fontWeight: FontWeight.w600,
              ),
        ),
      );
    }

    return _PaginationPageButton(
      page: entry.page!,
      isCurrent: isCurrent,
      enabled: enabled,
      style: style,
      onPressed: () => onPageChanged(entry.page!),
    );
  }

  List<int> _normalizedPerPageOptions() {
    final List<int> sanitized = itemsPerPageOptions
        .where((int option) => option > 0)
        .toSet()
        .toList()
      ..sort();
    return sanitized;
  }

  int? _resolveItemsPerPage(List<int> normalizedOptions) {
    if (itemsPerPage != null && itemsPerPage! > 0) {
      return itemsPerPage;
    }
    if (normalizedOptions.isNotEmpty) {
      return normalizedOptions.first;
    }
    return null;
  }

  String _summaryLabel({
    required int currentPage,
    required int totalPages,
    required int? itemsPerPage,
    required int? totalItems,
  }) {
    final int? firstItem =
        itemsPerPage == null ? null : ((currentPage - 1) * itemsPerPage) + 1;
    final int? lastItem =
        itemsPerPage == null ? null : currentPage * itemsPerPage;

    final PragmaPaginationSummary summary = PragmaPaginationSummary(
      currentPage: currentPage,
      totalPages: totalPages,
      itemsPerPage: itemsPerPage,
      totalItems: totalItems,
      firstItemIndex: firstItem,
      lastItemIndex: totalItems == null || lastItem == null
          ? lastItem
          : math.min(totalItems, lastItem),
    );

    if (summaryBuilder != null) {
      return summaryBuilder!(summary);
    }

    if (summary.totalItems != null &&
        summary.itemsPerPage != null &&
        summary.firstItemIndex != null &&
        summary.lastItemIndex != null) {
      final int cappedLast = math.min(
        summary.lastItemIndex!,
        summary.totalItems!,
      );
      return '${summary.firstItemIndex}–$cappedLast '
          'de ${summary.totalItems} resultados';
    }

    if (summary.itemsPerPage != null) {
      return 'Página ${summary.currentPage} de ${summary.totalPages} · '
          '${summary.itemsPerPage} por página';
    }

    return 'Página ${summary.currentPage} de ${summary.totalPages}';
  }

  List<_PaginationEntry> _buildPaginationEntries(
    int currentPage,
    int totalPages,
  ) {
    if (totalPages <= 6) {
      return List<_PaginationEntry>.generate(
        totalPages,
        (int index) => _PaginationEntry.number(index + 1),
      );
    }

    final Set<int> slots = <int>{1, totalPages, currentPage};
    slots.add(currentPage - 1);
    slots.add(currentPage + 1);

    if (currentPage <= 3) {
      slots.addAll(<int>[2, 3, 4]);
    } else if (currentPage >= totalPages - 2) {
      slots.addAll(<int>[totalPages - 1, totalPages - 2, totalPages - 3]);
    }

    final List<int> sortedSlots = slots
        .where((int page) => page >= 1 && page <= totalPages)
        .toList()
      ..sort();

    final List<_PaginationEntry> entries = <_PaginationEntry>[];
    int? lastPage;

    for (final int page in sortedSlots) {
      if (lastPage != null && page - lastPage > 1) {
        entries.add(const _PaginationEntry.gap());
      }
      entries.add(_PaginationEntry.number(page));
      lastPage = page;
    }

    return entries;
  }
}

class _PaginationEntry {
  const _PaginationEntry.number(this.page);

  const _PaginationEntry.gap() : page = null;

  final int? page;

  bool get isGap => page == null;
}

class _PaginationSurfaceStyle {
  const _PaginationSurfaceStyle({
    required this.background,
    required this.gradient,
    required this.foregroundColor,
    required this.subduedForeground,
    required this.activeBackground,
    required this.activeForeground,
    required this.disabledForeground,
    required this.borderColor,
    required this.selectorBackground,
    required this.selectorBorder,
    required this.selectorForeground,
  });

  final Color background;
  final LinearGradient? gradient;
  final Color foregroundColor;
  final Color subduedForeground;
  final Color activeBackground;
  final Color activeForeground;
  final Color disabledForeground;
  final Color borderColor;
  final Color selectorBackground;
  final Color selectorBorder;
  final Color selectorForeground;

  BoxDecoration get decoration => BoxDecoration(
        gradient: gradient,
        color: gradient == null ? background : null,
        borderRadius:
            BorderRadius.circular(PragmaBorderRadiusTokens.full.value),
        border: Border.all(color: borderColor),
      );

  static _PaginationSurfaceStyle resolve(
    ColorScheme scheme,
    PragmaPaginationTone tone,
  ) {
    if (tone == PragmaPaginationTone.dark) {
      return _PaginationSurfaceStyle(
        background: scheme.primaryContainer,
        gradient: LinearGradient(
          colors: <Color>[
            scheme.primary,
            scheme.primary.withValues(alpha: 0.1),
          ],
        ),
        foregroundColor: Colors.white,
        subduedForeground: Colors.white.withValues(alpha: 0.72),
        activeBackground: Colors.white,
        activeForeground: scheme.primary,
        disabledForeground: Colors.white.withValues(alpha: 0.35),
        borderColor: Colors.white.withValues(alpha: 0.16),
        selectorBackground: Colors.white.withValues(alpha: 0.08),
        selectorBorder: Colors.white.withValues(alpha: 0.24),
        selectorForeground: Colors.white,
      );
    }

    return _PaginationSurfaceStyle(
      background: scheme.surface,
      gradient: null,
      foregroundColor: scheme.onSurface,
      subduedForeground: scheme.onSurfaceVariant,
      activeBackground: scheme.primary.withValues(alpha: 0.12),
      activeForeground: scheme.primary,
      disabledForeground: scheme.onSurface.withValues(alpha: 0.38),
      borderColor: scheme.outlineVariant,
      selectorBackground: scheme.surface,
      selectorBorder: scheme.outlineVariant,
      selectorForeground: scheme.onSurface,
    );
  }
}

class _PaginationArrowButton extends StatelessWidget {
  const _PaginationArrowButton({
    required this.icon,
    required this.semanticsLabel,
    required this.enabled,
    required this.style,
    required this.onPressed,
  });

  final IconData icon;
  final String semanticsLabel;
  final bool enabled;
  final _PaginationSurfaceStyle style;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        enabled ? style.foregroundColor : style.disabledForeground;

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticsLabel,
      child: IconButton(
        onPressed: enabled ? onPressed : null,
        tooltip: semanticsLabel,
        padding: EdgeInsets.zero,
        iconSize: 24,
        splashRadius: 22,
        icon: Icon(icon, color: iconColor),
      ),
    );
  }
}

class _PaginationPageButton extends StatelessWidget {
  const _PaginationPageButton({
    required this.page,
    required this.isCurrent,
    required this.enabled,
    required this.style,
    required this.onPressed,
  });

  final int page;
  final bool isCurrent;
  final bool enabled;
  final _PaginationSurfaceStyle style;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w600) ??
        TextStyle(fontWeight: FontWeight.w600, color: style.foregroundColor);

    final Color foreground = !enabled
        ? style.disabledForeground
        : (isCurrent ? style.activeForeground : style.foregroundColor);

    final Color? background = isCurrent ? style.activeBackground : null;

    return Semantics(
      button: true,
      selected: isCurrent,
      label: 'Página $page',
      child: TextButton(
        onPressed: enabled ? onPressed : null,
        style: TextButton.styleFrom(
          minimumSize: const Size(44, 36),
          padding: const EdgeInsets.symmetric(horizontal: PragmaSpacing.sm),
          foregroundColor: foreground,
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(PragmaBorderRadiusTokens.l.value),
          ),
        ),
        child: Text(
          '$page',
          style: textStyle.copyWith(color: foreground),
        ),
      ),
    );
  }
}

class _PerPageSelector extends StatelessWidget {
  const _PerPageSelector({
    required this.value,
    required this.options,
    required this.onSelected,
    required this.style,
    required this.enabled,
  });

  final int value;
  final List<int> options;
  final ValueChanged<int> onSelected;
  final _PaginationSurfaceStyle style;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w600) ??
        TextStyle(
          fontWeight: FontWeight.w600,
          color: style.selectorForeground,
        );

    return PopupMenuButton<int>(
      enabled: enabled,
      initialValue: value,
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return options.map((int option) {
          return PopupMenuItem<int>(
            value: option,
            child: Text('$option por página'),
          );
        }).toList();
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.selectorBackground,
          borderRadius: BorderRadius.circular(PragmaBorderRadiusTokens.l.value),
          border: Border.all(color: style.selectorBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PragmaSpacing.md,
            vertical: PragmaSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$value por página',
                style: textStyle.copyWith(color: style.selectorForeground),
              ),
              const SizedBox(width: PragmaSpacing.xs),
              Icon(
                Icons.expand_more,
                size: 20,
                color: enabled
                    ? style.selectorForeground
                    : style.disabledForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
