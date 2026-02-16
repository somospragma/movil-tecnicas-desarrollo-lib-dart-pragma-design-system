import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  test('roundtrip keeps sidebar item fields intact', () {
    final ModelDsSidebarMenuItem original = ModelDsSidebarMenuItem(
      id: 'reports',
      label: 'Reportes',
      iconToken: DsSidebarIconToken.reports,
      enabled: false,
      semanticLabel: 'Abrir reportes',
    );

    final ModelDsSidebarMenuItem decoded =
        ModelDsSidebarMenuItem.fromJson(original.toJson());

    expect(decoded, equals(original));
    expect(decoded.iconToken, DsSidebarIconToken.reports);
  });

  test('fromJson handles unknown icon token using fallback', () {
    final ModelDsSidebarMenuItem decoded = ModelDsSidebarMenuItem.fromJson(
      const <String, dynamic>{
        'id': 'x',
        'label': 'Elemento',
        'iconToken': 'not-allowed',
      },
    );

    expect(decoded.iconToken, DsSidebarIconToken.home);
    expect(decoded.enabled, isTrue);
  });

  test('copyWith overrides selected fields', () {
    final ModelDsSidebarMenuItem source = ModelDsSidebarMenuItem(
      id: 'home',
      label: 'Inicio',
      iconToken: DsSidebarIconToken.home,
    );

    final ModelDsSidebarMenuItem updated = source.copyWith(
      id: 'settings',
      iconToken: DsSidebarIconToken.settings,
      enabled: false,
    );

    expect(updated.id, 'settings');
    expect(updated.iconToken, DsSidebarIconToken.settings);
    expect(updated.enabled, isFalse);
    expect(updated.label, 'Inicio');
  });
}
