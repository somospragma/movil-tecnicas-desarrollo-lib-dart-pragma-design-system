import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  test('roundtrip keeps label and color intact', () {
    const String label = 'Primary';
    const String color = '#12ab56';

    final ModelColorToken token = ModelColorToken(label: label, color: color);
    final ModelColorToken roundtrip = ModelColorToken.fromJson(token.toJson());

    expect(roundtrip.label, label);
    expect(roundtrip.color, '#12AB56');
    expect(roundtrip.isValidHex, isTrue);
  });

  test('fromJson gracefully handles null maps', () {
    final ModelColorToken token = ModelColorToken.fromJson(null);

    expect(token, ModelColorToken.empty);
  });

  test('copyWith overrides label and color', () {
    final ModelColorToken original =
        ModelColorToken(label: 'Secondary', color: '#FFAA00');

    final ModelColorToken copy = original.copyWith(
      label: 'Inverse',
      color: '0000ff',
    );

    expect(copy.label, 'Inverse');
    expect(copy.color, '#0000FF');
  });
}
