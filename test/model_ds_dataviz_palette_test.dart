import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  test('fallback uses available DS foundation tokens', () {
    final ModelDataVizPalette palette = ModelDataVizPalette.fallback();

    expect(palette.categorical.length, 10);
    expect(palette.sequential.length, 6);
    expect(palette.categorical.first, PragmaColorTokens.primaryPurple500);
    expect(palette.sequential.first, PragmaColorTokens.primaryPurple50);
    expect(palette.sequential.last, PragmaColorTokens.primaryPurple900);
  });

  test('roundtrip preserves categorical and sequential colors', () {
    final ModelDataVizPalette original = ModelDataVizPalette.fallback();

    final Map<String, dynamic> json = original.toJson();
    final ModelDataVizPalette decoded = ModelDataVizPalette.fromJson(json);

    expect(decoded, equals(original));
  });

  test('sequentialAt interpolates and clamps values', () {
    const ModelDataVizPalette palette = ModelDataVizPalette(
      categorical: <Color>[Color(0xFF000000)],
      sequential: <Color>[Color(0xFF000000), Color(0xFFFFFFFF)],
    );

    expect(palette.sequentialAt(-1), const Color(0xFF000000));
    expect(palette.sequentialAt(2), const Color(0xFFFFFFFF));
    final int midpoint = palette.sequentialAt(0.5).toARGB32();
    expect(midpoint, anyOf(0xFF7F7F7F, 0xFF808080));
  });
}
