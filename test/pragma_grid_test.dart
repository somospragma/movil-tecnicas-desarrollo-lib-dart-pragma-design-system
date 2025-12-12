import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  group('PragmaViewportEnum', () {
    test('clasifica correctamente mobile', () {
      expect(getViewportFromWidth(320), PragmaViewportEnum.mobile);
      expect(getViewportFromWidth(599), PragmaViewportEnum.mobile);
    });

    test('clasifica correctamente tablet', () {
      expect(getViewportFromWidth(600), PragmaViewportEnum.tablet);
      expect(getViewportFromWidth(1023), PragmaViewportEnum.tablet);
    });

    test('clasifica correctamente desktop', () {
      expect(getViewportFromWidth(1024), PragmaViewportEnum.desktop);
      expect(getViewportFromWidth(1919), PragmaViewportEnum.desktop);
    });

    test('clasifica correctamente tv', () {
      expect(getViewportFromWidth(1920), PragmaViewportEnum.tv);
      expect(getViewportFromWidth(2500), PragmaViewportEnum.tv);
    });
  });

  group('PragmaGridConfig', () {
    test('configuración para mobile respeta columnas y márgenes mínimos', () {
      final PragmaGridConfig config = getGridConfigFromWidth(390);

      expect(config.viewport, PragmaViewportEnum.mobile);
      expect(config.columns, 4);
      expect(config.gutter, greaterThanOrEqualTo(16));
      expect(config.margin, greaterThanOrEqualTo(32));
      expect(config.containerWidth, lessThanOrEqualTo(390));
      expect(config.columnWidth, greaterThan(0));
    });

    test('configuración para desktop usa 12 columnas', () {
      final PragmaGridConfig config = getGridConfigFromWidth(1440);

      expect(config.viewport, PragmaViewportEnum.desktop);
      expect(config.columns, 12);
      expect(config.gutter, greaterThanOrEqualTo(16));
      expect(config.margin, greaterThanOrEqualTo(32));
      expect(config.containerWidth, lessThanOrEqualTo(1440));
      expect(config.columnWidth, greaterThan(0));
    });
  });
}
