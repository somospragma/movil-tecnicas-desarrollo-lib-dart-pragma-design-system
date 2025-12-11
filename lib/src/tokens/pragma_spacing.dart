import 'package:flutter/widgets.dart';

/// Representa un token de espaciado definido por el equipo de diseño.
@immutable
class PragmaSpacingToken {
  const PragmaSpacingToken({
    required this.name,
    required this.designToken,
    required this.value,
  });

  /// Nombre legible definido en las guías.
  final String name;

  /// Nombre del token en Figma / especificaciones.
  final String designToken;

  /// Valor en puntos (dp) equivalente en Flutter.
  final double value;
}

/// Colección de tokens de espaciado empleados en el Design System.
class PragmaSpacingTokens {
  const PragmaSpacingTokens._();

  static const PragmaSpacingToken xxs = PragmaSpacingToken(
    name: 'space-xxs',
    designToken: r'$pds-space-xxs',
    value: 4,
  );
  static const PragmaSpacingToken xs = PragmaSpacingToken(
    name: 'space-xs',
    designToken: r'$pds-space-xs',
    value: 8,
  );
  static const PragmaSpacingToken s = PragmaSpacingToken(
    name: 'space-s',
    designToken: r'$pds-space-s',
    value: 16,
  );
  static const PragmaSpacingToken m = PragmaSpacingToken(
    name: 'space-m',
    designToken: r'$pds-space-m',
    value: 24,
  );
  static const PragmaSpacingToken l = PragmaSpacingToken(
    name: 'space-l',
    designToken: r'$pds-space-l',
    value: 32,
  );
  static const PragmaSpacingToken xl = PragmaSpacingToken(
    name: 'space-xl',
    designToken: r'$pds-space-xl',
    value: 40,
  );
  static const PragmaSpacingToken xxl = PragmaSpacingToken(
    name: 'space-xxl',
    designToken: r'$pds-space-xxl',
    value: 48,
  );
  static const PragmaSpacingToken xxl2 = PragmaSpacingToken(
    name: 'space-xxl-2',
    designToken: r'$pds-space-xxl-2',
    value: 56,
  );
  static const PragmaSpacingToken xxl3 = PragmaSpacingToken(
    name: 'space-xxl-3',
    designToken: r'$pds-space-xxl-3',
    value: 64,
  );
  static const PragmaSpacingToken xxl4 = PragmaSpacingToken(
    name: 'space-xxl-4',
    designToken: r'$pds-space-xxl-4',
    value: 72,
  );
  static const PragmaSpacingToken xxl5 = PragmaSpacingToken(
    name: 'space-xxl-5',
    designToken: r'$pds-space-xxl-5',
    value: 80,
  );
  static const PragmaSpacingToken xxl6 = PragmaSpacingToken(
    name: 'space-xxl-6',
    designToken: r'$pds-space-xxl-6',
    value: 88,
  );

  /// Lista completa en orden creciente, útil para automatizar catálogos.
  static const List<PragmaSpacingToken> all = <PragmaSpacingToken>[
    xxs,
    xs,
    s,
    m,
    l,
    xl,
    xxl,
    xxl2,
    xxl3,
    xxl4,
    xxl5,
    xxl6,
  ];
}

/// Atajos prácticos que exponen los valores del sistema de espaciado.
class PragmaSpacing {
  const PragmaSpacing._();

  static const double zero = 0;
  static const double xxxs = 2;
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 32;
  static const double xl = 40;
  static const double xxl = 48;
  static const double xxl2 = 56;
  static const double xxl3 = 64;
  static const double xxl4 = 72;
  static const double xxl5 = 80;
  static const double xxl6 = 88;

  static EdgeInsets insetAll(double value) => EdgeInsets.all(value);

  /// Atajo para construir `EdgeInsets` a partir de un token específico.
  static EdgeInsets insetToken(PragmaSpacingToken token) =>
      EdgeInsets.all(token.value);

  static EdgeInsets insetSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static EdgeInsets insetOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  }
}
