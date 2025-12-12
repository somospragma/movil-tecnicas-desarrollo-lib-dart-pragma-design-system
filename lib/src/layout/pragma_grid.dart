import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import '../tokens/pragma_grid_tokens.dart';

/// Clasificación de viewports compatible con las guías de Material/Pragma.
enum PragmaViewportEnum {
  mobile,
  tablet,
  desktop,
  tv,
}

/// Determina el viewport en función del ancho disponible.
PragmaViewportEnum getViewportFromWidth(double width) {
  if (width < 600) {
    return PragmaViewportEnum.mobile;
  }
  if (width < 1024) {
    return PragmaViewportEnum.tablet;
  }
  if (width < 1920) {
    return PragmaViewportEnum.desktop;
  }
  return PragmaViewportEnum.tv;
}

/// Determina el viewport usando el tamaño expuesto por `MediaQuery`.
PragmaViewportEnum getViewportFromContext(BuildContext context) {
  final double width = MediaQuery.sizeOf(context).width;
  return getViewportFromWidth(width);
}

/// Configuración calculada para construir layouts basados en columnas.
@immutable
class PragmaGridConfig {
  const PragmaGridConfig({
    required this.viewport,
    required this.columns,
    required this.gutter,
    required this.margin,
    required this.columnWidth,
    required this.containerWidth,
  });

  final PragmaViewportEnum viewport;
  final int columns;
  final double gutter;
  final double margin;
  final double columnWidth;
  final double containerWidth;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is PragmaGridConfig &&
        other.viewport == viewport &&
        other.columns == columns &&
        other.gutter == gutter &&
        other.margin == margin &&
        other.columnWidth == columnWidth &&
        other.containerWidth == containerWidth;
  }

  @override
  int get hashCode => Object.hash(
        viewport,
        columns,
        gutter,
        margin,
        columnWidth,
        containerWidth,
      );
}

/// Retorna la configuración de grid tomando como referencia el ancho provisto.
PragmaGridConfig getGridConfigFromWidth(double width) {
  final PragmaViewportEnum viewport = getViewportFromWidth(width);
  final PragmaGridTokenSet tokens = PragmaGridTokens.ofViewport(viewport);

  final double containerWidth = math.min(width, tokens.baseWidth);
  final double contentWidth = containerWidth - (tokens.minMargin * 2.0);
  final double columnsSpace =
      contentWidth - tokens.gutter * (tokens.columns - 1);
  final double columnWidth = columnsSpace / tokens.columns;

  return PragmaGridConfig(
    viewport: viewport,
    columns: tokens.columns,
    gutter: tokens.gutter,
    margin: tokens.minMargin,
    columnWidth: columnWidth,
    containerWidth: containerWidth,
  );
}

/// Lee el ancho del contexto actual y retorna la configuración de grid.
PragmaGridConfig getGridConfigFromContext(BuildContext context) {
  final double width = MediaQuery.sizeOf(context).width;
  return getGridConfigFromWidth(width);
}

// Ejemplo de uso dentro de un widget:
//
// Widget build(BuildContext context) {
//   final grid = getGridConfigFromContext(context);
//
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: grid.margin),
//     child: Row(
//       children: [
//         SizedBox(
//           width: grid.columnWidth,
//           child: ...,
//         ),
//         SizedBox(width: grid.gutter),
//         SizedBox(
//           width: grid.columnWidth,
//           child: ...,
//         ),
//       ],
//     ),
//   );
// }
