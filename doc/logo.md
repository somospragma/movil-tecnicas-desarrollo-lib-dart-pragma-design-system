# Pragma logo guidelines

This file summarizes how to reference the official Pragma logo assets inside Flutter applications and within the design system examples. Every asset already lives inside the `/assets/logo_light` and `/assets/logo_dark` folders of the package, so consumers do not need to add extra files to their apps.

## Variants and files

| Variant             | Size (px) | Light file                              | Dark file                                    | Recommended use cases                                    |
| ------------------- | --------- | --------------------------------------- | -------------------------------------------- | -------------------------------------------------------- |
| Wordmark            | 256 x 64  | `assets/logo_light/logo.png`            | `assets/logo_dark/logo_white.png`            | Splash screens, landing hero blocks, full-width headers. |
| App logo            | 119 x 41  | `assets/logo_light/app_logo.png`        | `assets/logo_dark/app_logo_white.png`        | App bars with limited height, onboarding carousels.      |
| Isotype circle      | 64 x 64   | `assets/logo_light/isotype_circle.png`  | `assets/logo_dark/circle_isotype_white.png`  | Avatars, launchers, compact badges.                      |
| Isotype circles (g) | 226 x 33  | `assets/logo_light/circles_isotype.png` | `assets/logo_dark/circles_isotype_white.png` | Dividers, empty states, decorative rows inside cards.    |

> The dark variants flip the foreground color to guarantee contrast on dark surfaces. Avoid manually inverting colors—use the provided files instead.

## Using `PragmaLogoWidget`

The easiest way to embed the logo is through `PragmaLogoWidget`, which internally uses `PragmaScaleBox` to keep the exact aspect ratio while adapting to any available width.

```dart
PragmaLogoWidget(
  width: 200,
  variant: PragmaLogoVariant.wordmark,
);
```

- The widget automatically selects the light or dark file depending on `Theme.of(context).brightness`.
- Margins are calculated proportionally to the provided width so the logo always breathes according to the brand specification.
- You can override the `margin` or `alignment` parameters if a layout requires custom spacing.

## Manual usage in other tools

If you need to export the assets to another environment (for example a marketing site), keep these rules in mind:

1. Never stretch the images vertically. Always scale uniformly so the original aspect ratio is preserved.
2. Use the light versions on white/neutral backgrounds (Material light surfaces) and the dark versions on purple/graphite backgrounds.
3. Leave horizontal padding equivalent to at least 8% of the rendered width so the logo does not feel cramped inside cards or app bars.
4. When placing the isotype next to text, align their baselines and maintain the optical spacing shown in the anatomy guide. The `PragmaLogoWidget` already applies this ratio.

## Export checklist

- [ ] Pick the correct variant for the surface (wordmark for hero areas, isotype for compact usages).
- [ ] Confirm the file is rendered at 1x scale and let Flutter handle pixel density (the assets are PNGs with transparent backgrounds).
- [ ] If the layout switches themes dynamically, prefer `PragmaLogoWidget` so the swap between light/dark logos happens automatically.
