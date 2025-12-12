import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Escala su [child] para que coincida con el ancho disponible conservando
/// la proporción definida en [designSize].
///
/// Útil cuando deseas presentar maquetas completas (por ejemplo, pantallas
/// exportadas desde Figma) y quieres que se adapten de forma uniforme
/// independientemente del ancho real del dispositivo o viewport.
class PragmaScaleBox extends StatelessWidget {
  const PragmaScaleBox({
    required this.child,
    required this.designSize,
    this.alignment = Alignment.topCenter,
    this.minScale,
    this.maxScale,
    super.key,
  });

  /// Contenido que se escalará.
  final Widget child;

  /// Tamaño original del diseño en el que se basó el layout.
  final Size designSize;

  /// Alineación utilizada tanto para el escalado como para el contenido.
  final Alignment alignment;

  /// Escala mínima permitida (opcional).
  final double? minScale;

  /// Escala máxima permitida (opcional).
  final double? maxScale;

  @override
  Widget build(BuildContext context) {
    assert(
      designSize.width > 0 && designSize.height > 0,
      'designSize must be greater than zero in both dimensions',
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : designSize.width;
        double scale = availableWidth / designSize.width;

        if (maxScale != null) {
          scale = math.min(scale, maxScale!);
        }
        if (minScale != null) {
          scale = math.max(scale, minScale!);
        }

        final double targetHeight = designSize.height * scale;

        return SizedBox(
          width: availableWidth,
          height: targetHeight,
          child: FittedBox(
            alignment: alignment,
            fit: BoxFit.fitWidth,
            child: SizedBox.fromSize(
              size: designSize,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
