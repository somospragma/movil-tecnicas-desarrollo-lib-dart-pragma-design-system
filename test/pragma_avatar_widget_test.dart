import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(home: Scaffold(body: Center(child: child)));
  }

  testWidgets('renders initials when provided', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(const PragmaAvatarWidget(initials: 'pd')),
    );

    expect(find.text('PD'), findsOneWidget);
  });

  testWidgets('falls back to icon when no initials or image',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(const PragmaAvatarWidget(icon: Icons.camera_alt_outlined)),
    );

    expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
  });

  testWidgets('respects a custom radius without clamping',
      (WidgetTester tester) async {
    const Key avatarKey = ValueKey<String>('avatar');
    const double customRadius = 4;
    await tester.pumpWidget(
      wrap(const PragmaAvatarWidget(key: avatarKey, radius: customRadius)),
    );

    final Size size = tester.getSize(find.byKey(avatarKey));
    expect(size.width, customRadius * 2);
    expect(size.height, customRadius * 2);
  });

  testWidgets('uses initials as semantics label when not provided',
      (WidgetTester tester) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(wrap(const PragmaAvatarWidget(initials: 'ab')));

    final SemanticsNode node = tester.getSemantics(
      find.byType(PragmaAvatarWidget),
    );
    expect(node.label.contains('AB'), isTrue);
    handle.dispose();
  });
}
