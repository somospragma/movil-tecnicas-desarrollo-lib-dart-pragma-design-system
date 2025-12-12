import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Describe un token de opacidad oficial del Design System.
@immutable
class PragmaOpacityToken {
  const PragmaOpacityToken({
    required this.name,
    required this.designToken,
    required this.value,
    required this.percentage,
  });

  /// Identificador legible dentro de las guías.
  final String name;

  /// Token documentado en Figma/Storybook.
  final String designToken;

  /// Valor decimal usado por Flutter (0 al 1).
  final double value;

  /// Valor porcentual (0 al 100) para mostrar en tablas o badges.
  final double percentage;

  /// Aplica el token al [color] recibido devolviendo una copia con el nuevo
  /// canal alfa usando `Color.withValues`.
  Color apply(Color color) => color.withValues(alpha: value);
}

/// Colección de tokens de opacidad autorizados.
class PragmaOpacityTokens {
  const PragmaOpacityTokens._();

  static const PragmaOpacityToken opacity08 = PragmaOpacityToken(
    name: 'Opacity-8',
    designToken: r'$pds-opacity-8',
    value: 0.08,
    percentage: 8,
  );

  static const PragmaOpacityToken opacity30 = PragmaOpacityToken(
    name: 'Opacity-30',
    designToken: r'$pds-opacity-30',
    value: 0.30,
    percentage: 30,
  );

  static const PragmaOpacityToken opacity60 = PragmaOpacityToken(
    name: 'Opacity-60',
    designToken: r'$pds-opacity-60',
    value: 0.60,
    percentage: 60,
  );

  static const List<PragmaOpacityToken> all = <PragmaOpacityToken>[
    opacity08,
    opacity30,
    opacity60,
  ];
}

/// Atajos para usar rápidamente los valores documentados.
class PragmaOpacity {
  const PragmaOpacity._();

  static const double opacity8 = 0.08;
  static const double opacity30 = 0.30;
  static const double opacity60 = 0.60;

  /// Devuelve [color] con el canal alfa reemplazado por [token].
  static Color apply(Color color, PragmaOpacityToken token) =>
      color.withValues(alpha: token.value);
}
