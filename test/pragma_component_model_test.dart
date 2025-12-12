import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  group('ModelAnatomyAttribute', () {
    test('roundtrips JSON data', () {
      const ModelAnatomyAttribute attribute = ModelAnatomyAttribute(
        title: 'Ícono',
        description: 'Representa la acción principal',
        value: 0.5,
      );

      final Map<String, dynamic> json = attribute.toJson();
      final ModelAnatomyAttribute parsed = ModelAnatomyAttribute.fromJson(json);

      expect(parsed, equals(attribute));
    });

    test('falls back to defaults when json is null', () {
      final ModelAnatomyAttribute attribute =
          ModelAnatomyAttribute.fromJson(null);
      expect(attribute.title, isEmpty);
      expect(attribute.description, isEmpty);
      expect(attribute.value, equals(0.1));
    });
  });

  group('ModelPragmaComponent', () {
    test('roundtrips JSON data from fixture', () {
      final Map<String, dynamic> raw = json.decode(
        fixture('components/scalebox_component.json'),
      ) as Map<String, dynamic>;

      final ModelPragmaComponent component = ModelPragmaComponent.fromJson(raw);
      expect(component.titleComponent, 'PragmaScaleBox');
      expect(component.anatomy, hasLength(2));

      final ModelPragmaComponent reconverted =
          ModelPragmaComponent.fromJson(component.toJson());

      expect(reconverted, equals(component));
    });

    test('copyWith overrides values', () {
      final ModelPragmaComponent base = ModelPragmaComponent(
        titleComponent: 'Accordion',
        description: 'Panel expandible',
      );

      final ModelPragmaComponent updated = base.copyWith(
        description: 'Panel expandible con estados controlados',
        useCases: <String>['FAQ', 'Documentación'],
      );

      expect(updated.description, 'Panel expandible con estados controlados');
      expect(updated.useCases, contains('FAQ'));
    });
  });
}

String fixture(String name) {
  const String root = String.fromEnvironment(
    'fixture_root',
    defaultValue: 'test/fixtures',
  );
  final File file = File('$root/$name');
  return file.readAsStringSync();
}
