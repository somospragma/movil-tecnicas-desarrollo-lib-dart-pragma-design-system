# DS Models

Este documento centraliza los modelos de dominio del Design System incluidos en la librería `pragma_design_system`.

## Objetivo

- Definir contratos serializables para tokens, tema y metadatos de componentes.
- Separar la representación del DS de la lógica de negocio de cada app consumidora.
- Garantizar roundtrip JSON (`toJson` / `fromJson`) como base de interoperabilidad.

## Principios de modelado

- Los modelos son inmutables.
- Los modelos son serializables.
- Los modelos no contienen lógica de negocio de aplicación.
- Los modelos no ejecutan side-effects.
- Los modelos base priorizan desacoplamiento de widgets cuando es posible.

## Estabilidad del contrato

- Cambios de estructura en modelos o keys JSON pueden ser breaking changes.
- Los payloads JSON deben versionarse cuando cambien forma o significado.
- Se recomienda mantener compatibilidad hacia atrás en `fromJson` cuando sea viable.

## Dependencia con Flutter

- Algunos modelos actúan como adaptadores hacia `ThemeData` (`ModelDesignSystem`, `ModelThemeData`).
- Otros modelos son contratos de tokens y datos de dominio (`DsExtendedTokens`, `ModelTypographyTokens`, `ModelSemanticColors`, `ModelDataVizPalette`, `ModelDsComponentAnatomy`, `ModelDsSidebarMenuItem`).
- La capa visual (`widgets`) consume estos modelos; no al revés.

## No hace

- No gestiona estado de aplicación (auth, ACL, router).
- No implementa navegación de app.
- No define layout final de pantallas.
- No reemplaza componentes visuales.
- No contiene reglas de negocio de cada módulo consumidor.

## Modelos principales

## `ModelDesignSystem`

Agregado raíz del DS y punto único de composición del sistema de diseño.

Incluye:
- `theme` (`ModelThemeData`)
- `tokens` (`DsExtendedTokens`)
- `semanticLight` / `semanticDark` (`ModelSemanticColors`)
- `dataViz` (`ModelDataVizPalette`)
- `typographyTokens` (`ModelTypographyTokens`)

Métodos clave:
- `ModelDesignSystem.pragmaDefault()`
- `toJson()` / `fromJson()`
- `toThemeData(brightness: ...)`
- `copyWith(...)`

Diagrama mental:

```text
ModelDesignSystem
 ├── ModelThemeData
 ├── DsExtendedTokens
 ├── ModelTypographyTokens
 ├── ModelSemanticColors (light/dark)
 ├── ModelDataVizPalette
 └── ModelDsComponentAnatomy
```

## `ModelThemeData`

Modelo de tema base para light/dark.

Incluye:
- `lightScheme`, `darkScheme` (`ColorScheme`)
- `lightTextTheme`, `darkTextTheme` (`TextTheme`)
- `useMaterial3`

Métodos:
- `ModelThemeData.pragmaDefault()`
- `fromThemeData(...)`
- `toThemeData(...)`
- `toJson()` / `fromJson()`

## `DsExtendedTokens`

Escalas de tokens extendidos del DS:
- spacing (`xs`..`xxl`)
- border radius (`xs`..`xxl`)
- elevation (`xs`..`xxl`)
- alpha (`withAlpha*`)
- durations de animación

Métodos:
- `const DsExtendedTokens()`
- `DsExtendedTokens.fromFactor(...)`
- `toJson()` / `fromJson()`

## `ModelTypographyTokens`

Modelo tipográfico de dominio desacoplado de Flutter UI.

Incluye 15 slots compatibles con `TextTheme`:
- `displayLarge`, `displayMedium`, `displaySmall`
- `headlineLarge`, `headlineMedium`, `headlineSmall`
- `titleLarge`, `titleMedium`, `titleSmall`
- `bodyLarge`, `bodyMedium`, `bodySmall`
- `labelLarge`, `labelMedium`, `labelSmall`

Cada slot usa `ModelTypographyTokenStyle` con:
- `fontSize`
- `lineHeight`
- `fontWeight`
- `letterSpacing` (opcional)

Relación con `PragmaTypography`:
- `PragmaTypography.textThemeFromTokens(...)` transforma este modelo en `TextTheme`.

## `ModelSemanticColors`

Paletas semánticas para estados de dominio:
- success
- warning
- info

Incluye pares `color / onColor` y `container / onContainer` para light y dark.

Métodos:
- `fallbackLight()`
- `fallbackDark()`
- `fromColorScheme(...)`
- `toJson()` / `fromJson()`

## `ModelDataVizPalette`

Modelo para visualización de datos:
- `categorical` (series discretas)
- `sequential` (escala continua)

Métodos:
- `fallback()`
- `categoricalAt(int)`
- `sequentialAt(double)`
- `toJson()` / `fromJson()`

## `ModelDsComponentAnatomy`

Metamodelo para documentar anatomía de componentes del DS.

Incluye:
- metadatos (`id`, `name`, `description`, `status`, `platforms`)
- tags
- links
- slots anatómicos (`ModelDsComponentSlot`)

## `ModelDsSidebarMenuItem`

Modelo de entrada de navegación para `DsSidebarMenuWidget`.

Incluye:
- `id`
- `label`
- `iconToken`
- `enabled`
- `semanticLabel` opcional

Detalle completo del modelo:
- [model_ds_sidebar_menu_item.md](model_ds_sidebar_menu_item.md)

## Extensiones de tema

Para recuperar modelos del DS desde `ThemeData`:
- `DsExtendedTokensExtension`
- `DsSemanticColorsExtension`
- `DsDataVizPaletteExtension`

Helper extension:
- `theme.dsTokens`
- `theme.dsSemantic`
- `theme.dsDataViz`

## Ejemplo de uso integral

```dart
final ModelDesignSystem ds = ModelDesignSystem.pragmaDefault();

final ThemeData light = ds.toThemeData(
  brightness: Brightness.light,
);

final ModelDesignSystem tuned = ds.copyWith(
  typographyTokens: ds.typographyTokens.copyWith(
    bodyMedium: ds.typographyTokens.bodyMedium.copyWith(fontSize: 18),
  ),
);

final Map<String, dynamic> payload = tuned.toJson();
final ModelDesignSystem restored = ModelDesignSystem.fromJson(payload);

assert(restored == tuned);
```

## Recomendaciones para apps consumidoras

1. Mantén reglas de negocio fuera de widgets DS y opera sobre estos modelos antes de renderizar.
2. Versiona payloads JSON en backend/config para trazabilidad de cambios de diseño.
3. Reutiliza `ModelDesignSystem` como punto único de composición para evitar divergencias entre módulos.
