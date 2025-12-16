import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  testWidgets('renders the light wordmark by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.light(),
        home: const Scaffold(
          body: Center(
            child: PragmaLogoWidget(width: 180),
          ),
        ),
      ),
    );

    final Finder logoFinder = find.byType(PragmaLogoWidget);
    final Image image = tester.widget<Image>(
      find.descendant(
        of: logoFinder,
        matching: find.byType(Image),
      ),
    );
    final AssetImage assetImage = image.image as AssetImage;
    expect(assetImage.assetName, 'assets/logo_light/logo.png');

    final Padding padding = tester.widget<Padding>(
      find.descendant(
        of: logoFinder,
        matching: find.byType(Padding),
      ),
    );
    expect(padding.padding.horizontal, closeTo(180 * 0.08 * 2, 0.001));
  });

  testWidgets('uses the dark asset for the selected variant',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: const Scaffold(
          body: PragmaLogoWidget(
            width: 80,
            variant: PragmaLogoVariant.isotypeCircle,
          ),
        ),
      ),
    );

    final Finder logoFinder = find.byType(PragmaLogoWidget);
    final Image image = tester.widget<Image>(
      find.descendant(
        of: logoFinder,
        matching: find.byType(Image),
      ),
    );
    final AssetImage assetImage = image.image as AssetImage;
    expect(assetImage.assetName, 'assets/logo_dark/circle_isotype_white.png');

    final Padding padding = tester.widget<Padding>(
      find.descendant(
        of: logoFinder,
        matching: find.byType(Padding),
      ),
    );
    expect(padding.padding.horizontal / 2, closeTo(80 * 0.04, 0.001));
  });
}
