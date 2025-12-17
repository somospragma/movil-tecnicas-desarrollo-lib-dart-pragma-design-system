import 'package:flutter/material.dart';

import '../tokens/pragma_border_radius.dart';
import '../tokens/pragma_color_tokens.dart';
import '../tokens/pragma_spacing.dart';

/// Builder opcional para renderizar filas con estructura inválida.
typedef PragmaInvalidRowBuilder = Widget Function(
  BuildContext context,
  PragmaTableRowData row,
  int expectedColumnCount,
  int rowIndex,
);

/// Define la alineación y el encabezado de una columna dentro del
/// [PragmaTableWidget].
@immutable
class PragmaTableColumn {
  const PragmaTableColumn({
    required this.label,
    this.flex = 1,
    this.alignment = Alignment.centerLeft,
  }) : assert(flex > 0, 'El flex debe ser mayor a cero.');

  /// Texto mostrado en el encabezado.
  final String label;

  /// Factor de espacio relativo asignado a la columna.
  final int flex;

  /// Alineación aplicada tanto al encabezado como a las celdas de la columna.
  final Alignment alignment;
}

/// Describe una fila de datos renderizada por [PragmaTableWidget].
@immutable
class PragmaTableRowData {
  const PragmaTableRowData({
    required this.cells,
    this.tone = PragmaTableRowTone.light,
    this.state = PragmaTableRowState.idle,
    this.onTap,
    this.semanticLabel,
  });

  /// Contenido de cada celda. Debe coincidir con el total de columnas.
  final List<Widget> cells;

  /// Define si la fila usa un fondo claro u oscuro.
  final PragmaTableRowTone tone;

  /// Estado visual (idle, hover o selected) según las guías.
  final PragmaTableRowState state;

  /// Callback opcional cuando se toca la fila.
  final VoidCallback? onTap;

  /// Etiqueta descriptiva útil para lectores de pantalla.
  final String? semanticLabel;
}

/// Fondos soportados por cada fila.
enum PragmaTableRowTone { light, dark }

/// Estados gráficos que puede mostrar una fila.
enum PragmaTableRowState { idle, hover, selected }

/// Tabla multi-columna alineada a los estilos de Pragma.
class PragmaTableWidget extends StatelessWidget {
  const PragmaTableWidget({
    required this.columns,
    required this.rows,
    super.key,
    this.compact = false,
    this.showHeader = true,
    this.showRowDividers = true,
    this.emptyPlaceholder,
    this.invalidRowBuilder,
  }) : assert(columns.length > 0, 'Declara al menos una columna.');

  /// Columnas mostradas en el encabezado y usadas para distribuir el espacio.
  final List<PragmaTableColumn> columns;

  /// Filas que componen el cuerpo de la tabla.
  final List<PragmaTableRowData> rows;

  /// Reduce la altura de las filas y tipografías cuando es `true`.
  final bool compact;

  /// Oculta el encabezado cuando no se necesita mostrar etiquetas.
  final bool showHeader;

  /// Dibuja divisores sutiles entre filas.
  final bool showRowDividers;

  /// Placeholder opcional mostrado cuando `rows` está vacío.
  final Widget? emptyPlaceholder;

  /// Builder para filas con datos inválidos (cantidad de celdas distinta).
  ///
  /// Si es `null`, esas filas se omiten silenciosamente.
  final PragmaInvalidRowBuilder? invalidRowBuilder;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final _TableMetrics metrics = _TableMetrics(compact: compact);
    final Color borderColor = scheme.outlineVariant.withValues(alpha: 0.4);
    final Color rowDividerColor = borderColor.withValues(alpha: 0.5);

    final List<_RenderableRow> renderQueue = _buildRenderableRows(
      rows: rows,
      expectedColumnCount: columns.length,
      includeInvalid: invalidRowBuilder != null,
    );

    final List<Widget> columnChildren = <Widget>[];

    if (showHeader) {
      columnChildren.add(
        _TableHeader(
          columns: columns,
          metrics: metrics,
          dividerColor: borderColor,
        ),
      );
    }

    if (renderQueue.isEmpty) {
      columnChildren.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: metrics.horizontalPadding,
            vertical: metrics.rowPadding,
          ),
          child: DefaultTextStyle(
            style: metrics
                .bodyStyle(theme)
                .copyWith(color: scheme.onSurfaceVariant),
            child: emptyPlaceholder ??
                const Text('Sin datos disponibles por ahora.'),
          ),
        ),
      );
    } else {
      columnChildren.addAll(
        List<Widget>.generate(renderQueue.length, (int index) {
          final _RenderableRow entry = renderQueue[index];
          final bool showDivider =
              showRowDividers && index != renderQueue.length - 1;

          if (entry.isValid) {
            return _TableRowView(
              row: entry.row,
              columns: columns,
              metrics: metrics,
              dividerColor: rowDividerColor,
              showDivider: showDivider,
            );
          }

          final Widget invalidRow = invalidRowBuilder!(
            context,
            entry.row,
            columns.length,
            entry.index,
          );

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: double.infinity, child: invalidRow),
              if (showDivider) Container(height: 1, color: rowDividerColor),
            ],
          );
        }),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(PragmaBorderRadius.l),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: columnChildren,
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({
    required this.columns,
    required this.metrics,
    required this.dividerColor,
  });

  final List<PragmaTableColumn> columns;
  final _TableMetrics metrics;
  final Color dividerColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        border: Border(bottom: BorderSide(color: dividerColor)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: metrics.horizontalPadding,
          vertical: metrics.headerPadding,
        ),
        child: Row(
          children: <Widget>[
            for (final PragmaTableColumn column in columns)
              Expanded(
                flex: column.flex,
                child: Align(
                  alignment: column.alignment,
                  child: Text(
                    column.label,
                    style: metrics
                        .headerStyle(theme)
                        .copyWith(color: scheme.onSurfaceVariant),
                    textAlign: _textAlignFor(column.alignment),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TableRowView extends StatelessWidget {
  const _TableRowView({
    required this.row,
    required this.columns,
    required this.metrics,
    required this.dividerColor,
    required this.showDivider,
  });

  final PragmaTableRowData row;
  final List<PragmaTableColumn> columns;
  final _TableMetrics metrics;
  final Color dividerColor;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final _PragmaTableRowStyle style =
        _resolveRowStyle(theme, row.tone, row.state);

    Widget content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: metrics.horizontalPadding,
        vertical: metrics.rowPadding,
      ),
      child: Row(
        children: <Widget>[
          for (int index = 0; index < columns.length; index++)
            Expanded(
              flex: columns[index].flex,
              child: Align(
                alignment: columns[index].alignment,
                child: row.cells[index],
              ),
            ),
        ],
      ),
    );

    content = DefaultTextStyle.merge(
      style: metrics.bodyStyle(theme).copyWith(color: style.textColor),
      child: IconTheme.merge(
        data: IconThemeData(color: style.iconColor),
        child: content,
      ),
    );

    if (row.semanticLabel != null || row.onTap != null) {
      content = Semantics(
        label: row.semanticLabel,
        button: row.onTap != null,
        child: content,
      );
    }

    if (row.onTap != null) {
      content = Material(
        type: MaterialType.transparency,
        child: InkWell(onTap: row.onTap, child: content),
      );
    }

    final Widget surface = Container(
      decoration: BoxDecoration(
        color: style.gradient == null ? style.backgroundColor : null,
        gradient: style.gradient,
        border: style.borderColor == null
            ? null
            : Border.all(color: style.borderColor!),
        boxShadow: style.shadows,
      ),
      child: content,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        surface,
        if (showDivider) Container(height: 1, color: dividerColor),
      ],
    );
  }
}

class _TableMetrics {
  const _TableMetrics({required this.compact});

  final bool compact;

  double get headerPadding => compact ? PragmaSpacing.xs : PragmaSpacing.sm;
  double get rowPadding => compact ? PragmaSpacing.xs : PragmaSpacing.sm;
  double get horizontalPadding => PragmaSpacing.md;

  TextStyle headerStyle(ThemeData theme) {
    return theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700) ??
        const TextStyle(fontWeight: FontWeight.w700);
  }

  TextStyle bodyStyle(ThemeData theme) {
    return compact
        ? theme.textTheme.bodySmall ?? const TextStyle()
        : theme.textTheme.bodyMedium ?? const TextStyle();
  }
}

class _PragmaTableRowStyle {
  const _PragmaTableRowStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    this.gradient,
    this.shadows = const <BoxShadow>[],
    this.borderColor,
  });

  final Color backgroundColor;
  final Gradient? gradient;
  final List<BoxShadow> shadows;
  final Color? borderColor;
  final Color textColor;
  final Color iconColor;
}

_PragmaTableRowStyle _resolveRowStyle(
  ThemeData theme,
  PragmaTableRowTone tone,
  PragmaTableRowState state,
) {
  final ColorScheme scheme = theme.colorScheme;
  final bool isLightTone = tone == PragmaTableRowTone.light;
  final Color baseBackground = isLightTone
      ? scheme.surface
      : (theme.brightness == Brightness.light
          ? PragmaColorTokens.primaryGray900
          : scheme.surfaceContainerHighest);
  final Color baseText = isLightTone ? scheme.onSurface : Colors.white;

  switch (state) {
    case PragmaTableRowState.hover:
      final Gradient gradient = LinearGradient(
        colors: <Color>[
          scheme.primary.withValues(alpha: isLightTone ? 0.35 : 0.55),
          Color.lerp(scheme.primary, scheme.secondary, 0.45)!
              .withValues(alpha: isLightTone ? 0.3 : 0.5),
        ],
      );
      return _PragmaTableRowStyle(
        backgroundColor: baseBackground,
        gradient: gradient,
        textColor: Colors.white,
        iconColor: Colors.white,
        shadows: <BoxShadow>[
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.45),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      );
    case PragmaTableRowState.selected:
      final Color overlay =
          scheme.secondary.withValues(alpha: isLightTone ? 0.18 : 0.28);
      final Color highlightText = isLightTone ? scheme.onPrimary : Colors.white;
      return _PragmaTableRowStyle(
        backgroundColor: Color.alphaBlend(overlay, baseBackground),
        borderColor: overlay,
        textColor: highlightText,
        iconColor: highlightText,
      );
    case PragmaTableRowState.idle:
      final Color border = isLightTone
          ? scheme.outlineVariant.withValues(alpha: 0.3)
          : Colors.white.withValues(alpha: 0.1);
      return _PragmaTableRowStyle(
        backgroundColor: baseBackground,
        borderColor: border,
        textColor: baseText,
        iconColor: baseText.withValues(alpha: 0.85),
      );
  }
}

TextAlign _textAlignFor(Alignment alignment) {
  if (alignment.x <= -0.25) {
    return TextAlign.left;
  }
  if (alignment.x >= 0.25) {
    return TextAlign.right;
  }
  return TextAlign.center;
}

List<_RenderableRow> _buildRenderableRows({
  required List<PragmaTableRowData> rows,
  required int expectedColumnCount,
  required bool includeInvalid,
}) {
  final List<_RenderableRow> output = <_RenderableRow>[];
  for (int index = 0; index < rows.length; index++) {
    final PragmaTableRowData row = rows[index];
    final bool isValid = row.cells.length == expectedColumnCount;
    if (isValid) {
      output.add(_RenderableRow(row: row, index: index, isValid: true));
    } else if (includeInvalid) {
      output.add(_RenderableRow(row: row, index: index, isValid: false));
    }
  }
  return output;
}

class _RenderableRow {
  const _RenderableRow({
    required this.row,
    required this.index,
    required this.isValid,
  });

  final PragmaTableRowData row;
  final int index;
  final bool isValid;
}
