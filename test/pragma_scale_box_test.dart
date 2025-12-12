import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  testWidgets('PragmaScaleBox ajusta el ancho y conserva la proporción',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 400,
            child: PragmaScaleBox(
              designSize: const Size(200, 100),
              child: Container(color: Colors.red),
            ),
          ),
        ),
      ),
    );

    final Size size = tester.getSize(find.byType(PragmaScaleBox));
    expect(size.width, closeTo(400, 0.001));
    expect(size.height, closeTo(200, 0.001));
  });
}
