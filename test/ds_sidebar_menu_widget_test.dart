import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pragma_design_system/pragma_design_system.dart';

void main() {
  final List<ModelDsSidebarMenuItem> items = <ModelDsSidebarMenuItem>[
    ModelDsSidebarMenuItem(
      id: 'home',
      label: 'Inicio',
      iconToken: DsSidebarIconToken.home,
    ),
    ModelDsSidebarMenuItem(
      id: 'analytics',
      label: 'Analitica',
      iconToken: DsSidebarIconToken.analytics,
    ),
    ModelDsSidebarMenuItem(
      id: 'disabled',
      label: 'Bloqueado',
      iconToken: DsSidebarIconToken.lock,
      enabled: false,
    ),
  ];

  Widget buildSidebar({
    bool collapsed = false,
    String? activeId,
    ValueChanged<String>? onItemTap,
    ValueChanged<bool>? onCollapsedToggle,
    bool showCollapseToggle = false,
  }) {
    return MaterialApp(
      theme: PragmaTheme.light(),
      home: Scaffold(
        body: DsSidebarMenuWidget(
          items: items,
          title: 'Menu',
          collapsed: collapsed,
          activeId: activeId,
          onItemTap: onItemTap,
          onCollapsedToggle: onCollapsedToggle,
          showCollapseToggle: showCollapseToggle,
        ),
      ),
    );
  }

  testWidgets('renders labels in expanded mode', (WidgetTester tester) async {
    await tester.pumpWidget(buildSidebar());

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Analitica'), findsOneWidget);
  });

  testWidgets('hides labels and enables tooltip wrappers in collapsed mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildSidebar(collapsed: true));

    expect(find.text('Inicio'), findsNothing);
    expect(find.byType(PragmaTooltipWidget), findsNWidgets(4));
  });

  testWidgets('emits onItemTap with item id when enabled',
      (WidgetTester tester) async {
    String? selectedId;
    await tester.pumpWidget(
      buildSidebar(
        onItemTap: (String id) => selectedId = id,
      ),
    );

    await tester.tap(find.text('Analitica'));
    await tester.pumpAndSettle();

    expect(selectedId, 'analytics');
  });

  testWidgets('disabled items ignore interaction', (WidgetTester tester) async {
    String? selectedId;
    await tester.pumpWidget(
      buildSidebar(
        onItemTap: (String id) => selectedId = id,
      ),
    );

    await tester.tap(find.text('Bloqueado'));
    await tester.pumpAndSettle();

    expect(selectedId, isNull);
  });

  testWidgets('collapse toggle emits the inverse state',
      (WidgetTester tester) async {
    bool? next;
    await tester.pumpWidget(
      buildSidebar(
        onCollapsedToggle: (bool value) => next = value,
        showCollapseToggle: true,
      ),
    );

    await tester.tap(find.byTooltip('Colapsar menu'));
    await tester.pumpAndSettle();

    expect(next, isTrue);
  });

  testWidgets('marks active item as selected in semantics',
      (WidgetTester tester) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      buildSidebar(activeId: 'analytics'),
    );

    expect(
      tester.getSemantics(find.text('Analitica')),
      matchesSemantics(
        label: 'Analitica',
        isButton: true,
        isEnabled: true,
        hasEnabledState: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('keeps collapse toggle hidden by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildSidebar());

    expect(find.byTooltip('Colapsar menu'), findsNothing);
    expect(find.byTooltip('Expandir menu'), findsNothing);
  });

  testWidgets('renders safely inside vertical scrollables',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PragmaTheme.light(),
        home: Scaffold(
          body: ListView(
            children: <Widget>[
              DsSidebarMenuWidget(
                items: items,
                title: 'Menu',
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Inicio'), findsOneWidget);
  });

  testWidgets('does not overflow when expanded width is narrow',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PragmaTheme.light(),
        home: Scaffold(
          body: DsSidebarMenuWidget(
            items: items,
            title: 'Menu',
            width: 92,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
