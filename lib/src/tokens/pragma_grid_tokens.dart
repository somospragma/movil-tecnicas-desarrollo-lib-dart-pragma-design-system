import 'package:flutter/foundation.dart';
import '../layout/pragma_grid.dart';
import 'pragma_spacing.dart';

/// Tokens que describen cómo se comporta la grilla responsive
/// para cada tipo de viewport definido por el Design System.
@immutable
class PragmaGridTokenSet {
  const PragmaGridTokenSet({
    required this.baseWidth,
    required this.columns,
    required this.gutter,
    required this.minMargin,
  });

  /// Ancho de referencia del diseño en el que se definió la grid (Figma).
  final double baseWidth;

  /// Número de columnas del layout.
  final int columns;

  /// Espacio entre columnas (gutter), en dp.
  final double gutter;

  /// Margen mínimo externo (izquierda/derecha), en dp.
  final double minMargin;
}

class PragmaGridTokens {
  const PragmaGridTokens._();

  /// Configuración para mobile (diseños tipo 390–480px).
  static const PragmaGridTokenSet mobile = PragmaGridTokenSet(
    baseWidth: 390,
    columns: 4,
    gutter: PragmaSpacing.sm,
    minMargin: PragmaSpacing.lg,
  );

  /// Configuración para tablet (diseños intermedios).
  static const PragmaGridTokenSet tablet = PragmaGridTokenSet(
    baseWidth: 800,
    columns: 8,
    gutter: PragmaSpacing.sm,
    minMargin: PragmaSpacing.lg,
  );

  /// Configuración para desktop (ej. 1440px).
  static const PragmaGridTokenSet desktop = PragmaGridTokenSet(
    baseWidth: 1440,
    columns: 12,
    gutter: PragmaSpacing.md,
    minMargin: 100,
  );

  /// Configuración para TV (>= 1920px). Reutiliza Desktop por ahora.
  static const PragmaGridTokenSet tv = PragmaGridTokenSet(
    baseWidth: 1920,
    columns: 12,
    gutter: PragmaSpacing.md,
    minMargin: 100,
  );

  static PragmaGridTokenSet ofViewport(PragmaViewportEnum viewport) {
    switch (viewport) {
      case PragmaViewportEnum.mobile:
        return mobile;
      case PragmaViewportEnum.tablet:
        return tablet;
      case PragmaViewportEnum.desktop:
        return desktop;
      case PragmaViewportEnum.tv:
        return tv;
    }
  }
}
