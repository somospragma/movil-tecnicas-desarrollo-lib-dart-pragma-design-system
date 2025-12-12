# Responsive grid utilities

This guide explains how to leverage the tokens and helpers shipped in `pragma_design_system` to build consistent layouts and how to use `PragmaGridContainer` as a debugging overlay.

## Viewports and available tokens

The engine exposes four breakpoints aligned with Material Design. Each one defines the number of columns, gutter size, and minimum margins surfaced through `PragmaGridTokens`.

| Viewport  | Reference width | Columns | Gutter | Minimum margin |
| --------- | --------------- | ------- | ------ | -------------- |
| `mobile`  | up to 599 px    | 4       | 16 dp  | 32 dp          |
| `tablet`  | 600–1023 px     | 8       | 16 dp  | 32 dp          |
| `desktop` | 1024–1919 px    | 12      | 24 dp  | 100 dp         |
| `tv`      | 1920+ px        | 12      | 24 dp  | 100 dp         |

## Fetching the grid configuration

`lib/src/layout/pragma_grid.dart` exposes helpers that turn the available width into a reusable `PragmaGridConfig`.

```dart
final PragmaGridConfig grid = getGridConfigFromContext(context);

return Padding(
  padding: EdgeInsets.symmetric(horizontal: grid.margin),
  child: Row(
    children: <Widget>[
      SizedBox(width: grid.columnWidth, child: const _ModuleCard()),
      SizedBox(width: grid.gutter),
      // ...
    ],
  ),
);
```

When you need to compute it without a `BuildContext` (for instance, in tests or layout services) call `getGridConfigFromWidth(double width)`.

## Detecting the viewport

Map any width to `PragmaViewportEnum` to trigger conditional behaviors such as showing/hiding widgets or adjusting density.

```dart
final PragmaViewportEnum viewport = getViewportFromContext(context);
if (viewport == PragmaViewportEnum.mobile) {
  // Simplify the layout or reduce columns
}
```

## Using `PragmaGridContainer`

`PragmaGridContainer` is a utility widget that paints columns, gutters, and margins on top of its `child`. Because it relies on `CustomPainter`, it only renders visuals and never blocks interaction.

```dart
return PragmaGridContainer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: const <Widget>[
      _ModuleCard(),
    ],
  ),
);
```

The overlay includes a floating badge with live metrics. Customize the palette via `columnColor`, `gutterColor`, `marginColor`, or `infoBackgroundColor`.

## Scaling compositions with `PragmaScaleBox`

Whenever you need to showcase an entire mockup or a composite layout that must preserve its original proportions, wrap it with `PragmaScaleBox`. Provide the design-time size and the widget scales the content to fill the available width:

```dart
PragmaScaleBox(
  designSize: const Size(390, 844),
  child: const _PhoneMockup(),
)
```

Optionally clamp `minScale`/`maxScale` or tweak the `alignment` to decide how the mockup expands.

## Recommended workflow for implementers

1. **Configure offline Poppins** following `doc/poppins_offline.md`, then run the example app to ensure everything compiles.
2. **Adopt the helpers** by replacing magic margins with `grid.margin`, `grid.columnWidth`, and `grid.gutter`. This keeps every component aligned with the official grid.
3. **Enable the overlay** on the screens you are designing. Wrap the `Scaffold` (or any subtree) with `PragmaGridContainer` and navigate through different sizes.
4. **Validate metrics** using the bottom badge: confirm the viewport matches the Figma design and that the expected margins/columns are present.
5. **Disable the overlay** before shipping the final build. The widget is meant for development or QA environments.

## Additional resources

- Check the `Grid debugger` page inside `example/lib/main.dart` for a full implementation, including navigation wired through the `AppBar`.
- The tests in `test/pragma_grid_test.dart` provide a minimal reference on how to validate the calculations when future changes land.
