# Typography and font licensing

Pragma Design System standardizes the use of the **Poppins** typeface to keep UI surfaces aligned with the marketing site. The package provides helpers for online and offline consumption, plus licensing references for legal reviews.

## Default typography stack

| Context                 | Font family | Weight range | Source                                                                   |
| ----------------------- | ----------- | ------------ | ------------------------------------------------------------------------ |
| Headlines, buttons      | Poppins     | 500–700      | [Google Fonts API](https://fonts.google.com/specimen/Poppins)            |
| Body copy, captions     | Poppins     | 400–500      | Same as above                                                            |
| Offline/air-gapped apps | Poppins     | 400–700      | Local assets described in [`doc/poppins_offline.md`](poppins_offline.md) |

`PragmaTypography` in the package already maps the standard Material text styles (displayLarge → labelSmall) to these weights, so you only need to set it once inside your `ThemeData`.

```dart
MaterialApp(
  theme: ThemeData(
    textTheme: PragmaTypography.lightTextTheme,
  ),
);
```

## Loading fonts through Google Fonts

1. Ensure the `google_fonts` dependency is available in your app (already added in the example app).
2. Call `PragmaTypography.resolve(context)` which fetches the correct `TextTheme` based on brightness and locale.
3. For apps with custom theming, reuse `PragmaTypography.buildTextTheme(baseTheme)` to extend your own tokens without redefining every style.

The Google Fonts API hosts the Poppins family under the SIL Open Font License (OFL). Remote loading is safe for production use as long as you comply with the SIL license terms (attribution and redistribution clauses summarized in the next section).

## Licensing summary

- **License**: SIL Open Font License 1.1.
- **Allowed**: commercial usage, modification, bundling with apps, and redistribution as long as the OFL text stays intact.
- **Restricted**: do not sell the fonts on their own and do not rename the font family unless creating a reserved name exception.
- The full license text ships with the font download on Google Fonts and is mirrored in the offline bundle instructions.

## Offline distribution

If your environment cannot reach Google Fonts, follow [`doc/poppins_offline.md`](poppins_offline.md) to bundle the `.ttf` files inside your Flutter assets. The document explains:

- Folder structure (`assets/fonts/poppins/`).
- Updates to `pubspec.yaml` to declare the assets.
- How to point `PragmaTypography.offline()` to the packaged fonts.

## Verification checklist

- [ ] `PragmaTypography` is referenced by your `ThemeData`.
- [ ] `google_fonts` is available or the offline assets exist (never mix both sources in the same build flavor).
- [ ] The SIL Open Font License text is preserved when redistributing the font files.
