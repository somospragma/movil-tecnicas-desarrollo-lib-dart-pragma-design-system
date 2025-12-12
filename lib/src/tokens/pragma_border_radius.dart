import 'package:flutter/widgets.dart';

/// Token que describe un radio de borde estandarizado por el Design System.
@immutable
class PragmaBorderRadiusToken {
  const PragmaBorderRadiusToken({
    required this.name,
    required this.designToken,
    required this.value,
  });

  /// Nombre legible definido por el equipo de diseño.
  final String name;

  /// Identificador exacto del token dentro de Figma u otras guías.
  final String designToken;

  /// Valor en dp que debe usarse en Flutter.
  final double value;

  /// Helper para obtener un `BorderRadius.circular` usando el valor del token.
  BorderRadius toBorderRadius() => BorderRadius.circular(value);
}

/// Colección oficial de radios. Avanza en incrementos de 4 u 8 dp
/// según la complejidad del componente.
class PragmaBorderRadiusTokens {
  const PragmaBorderRadiusTokens._();

  static const PragmaBorderRadiusToken s = PragmaBorderRadiusToken(
    name: 'border-radius-s',
    designToken: r'$pds-border-radius-s',
    value: 4,
  );

  static const PragmaBorderRadiusToken m = PragmaBorderRadiusToken(
    name: 'border-radius-m',
    designToken: r'$pds-border-radius-m',
    value: 8,
  );

  static const PragmaBorderRadiusToken l = PragmaBorderRadiusToken(
    name: 'border-radius-l',
    designToken: r'$pds-border-radius-l',
    value: 16,
  );

  static const PragmaBorderRadiusToken xl = PragmaBorderRadiusToken(
    name: 'border-radius-xl',
    designToken: r'$pds-border-radius-xl',
    value: 24,
  );

  static const PragmaBorderRadiusToken full = PragmaBorderRadiusToken(
    name: 'border-radius-full',
    designToken: r'$pds-border-radius-full',
    value: 9999,
  );

  /// Lista útil para recorrer y construir catálogos.
  static const List<PragmaBorderRadiusToken> all = <PragmaBorderRadiusToken>[
    s,
    m,
    l,
    xl,
    full,
  ];
}

/// Atajos convenientes para usar radios redondeados sin instanciar objetos.
class PragmaBorderRadius {
  const PragmaBorderRadius._();

  static const double s = 4;
  static const double m = 8;
  static const double l = 16;
  static const double xl = 24;
  static const double full = 9999;

  /// `BorderRadius.circular` con el valor indicado.
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);

  /// `BorderRadius.circular` basado en un token oficial.
  static BorderRadius circularToken(PragmaBorderRadiusToken token) =>
      BorderRadius.circular(token.value);
}
