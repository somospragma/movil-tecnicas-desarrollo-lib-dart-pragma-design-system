# Opacity tokens

## Purpose

Overlays and hover states in the Design System must preserve contrast regardless of the background. To achieve that we restrict transparency levels to three intervals: 8%, 30%, and 60%. These values work on both light and dark surfaces, preventing inconsistencies between Storybook and production apps.

## Flutter implementation

Starting with Flutter 3.22, the `Color.withOpacity` API is deprecated in favor of `Color.withValues`. The package exposes helpers to stay aligned:

```dart
final Color hover = PragmaOpacity.apply(
  scheme.primary,
  PragmaOpacityTokens.opacity08,
);

final Color disabledBorder = scheme.outlineVariant.withValues(
  alpha: PragmaOpacity.opacity60,
);
```

Use `PragmaOpacityTokens` when you need the descriptive metadata (name plus percentage) and `PragmaOpacity` if you only require the decimal value.

## Token table

| Name       | Percentage | Token             | Decimal value |
| ---------- | ---------- | ----------------- | ------------- |
| Opacity-8  | 8%         | `$pds-opacity-8`  | 0.08          |
| Opacity-30 | 30%        | `$pds-opacity-30` | 0.30          |
| Opacity-60 | 60%        | `$pds-opacity-60` | 0.60          |

> If you ever need a different value, loop in the design team to confirm whether it should be added to the scale or if the requirement can be solved with these intervals.
