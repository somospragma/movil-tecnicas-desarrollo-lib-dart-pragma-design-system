# Modelo de componentes (0.0.4)

## Objetivo

Representar los componentes entregados por diseño con un modelo consistente que
permita documentarlos, generar showcases y compartirlos entre squads.

## Estructura de carpetas

```
lib/
  src/
    domain/
      models/
        model_anatomy_attribute.dart
        model_pragma_component.dart
```

Los modelos viven dentro de `lib/src` para mantener el patrón de encapsulación
y se reexportan mediante `pragma_design_system.dart`.

## Modelos disponibles

### `ModelPragmaComponent`

| Propiedad        | Tipo                          | Descripción                             |
| ---------------- | ----------------------------- | --------------------------------------- |
| `titleComponent` | `String`                      | Nombre visible del componente en Figma. |
| `description`    | `String`                      | Resumen del propósito.                  |
| `anatomy`        | `List<ModelAnatomyAttribute>` | Elementos anatómicos destacados.        |
| `useCases`       | `List<String>`                | Casos de uso recomendados.              |
| `urlImages`      | `List<String>`                | Capturas de referencia / mockups.       |

### `ModelAnatomyAttribute`

| Propiedad     | Tipo     | Defecto | Descripción                             |
| ------------- | -------- | ------- | --------------------------------------- |
| `title`       | `String` | —       | Nombre del elemento anatómico.          |
| `description` | `String` | `''`    | Texto opcional que amplía el título.    |
| `value`       | `double` | `0.1`   | Indicador cuantitativo (por ejemplo %). |

Ambos modelos incluyen `copyWith`, `toJson` y `fromJson` para garantizar el
roundtrip JSON que alimenta los showcases.

## Ejemplo de JSON

```json
{
  "titleComponent": "PragmaAccordionWidget",
  "description": "Panel expandible con estados controlados",
  "anatomy": [
    { "title": "Header", "description": "Contenido clickeable", "value": 0.5 }
  ],
  "useCases": ["FAQs", "Documentación"],
  "urlImages": ["https://cdn.pragma.co/components/accordion.png"]
}
```

## Uso en Flutter

```dart
final Map<String, dynamic> json = ... // proveniente de Storybook o Figma
final ModelPragmaComponent component = ModelPragmaComponent.fromJson(json);

for (final ModelAnatomyAttribute item in component.anatomy) {
  debugPrint('${item.title}: ${item.description}');
}
```

## Guía de documentación en código

Incluye siempre comentarios de documentación que expliquen cómo se usan los
modelos, los contratos de inmutabilidad y un ejemplo funcional que pueda
copiarse en pruebas o snippets internos. Puedes usar la siguiente plantilla
para `ModelPragmaComponent`:

````dart
/// Document a UI component coming from Figma as an immutable value object.
///
/// This model stores the component title, a short description, a list of
/// anatomy attributes, recommended use cases, and image URLs.
///
/// Functional example:
/// ```dart
/// void main() {
///   final ModelPragmaComponent component = ModelPragmaComponent(
///     titleComponent: 'PragmaButton',
///     description: 'Primary call-to-action button',
///     anatomy: <ModelAnatomyAttribute>[
///       ModelAnatomyAttribute(title: 'Padding', value: 16.0),
///     ],
///     useCases: <String>['Submit form', 'Confirm dialog'],
///     urlImages: <String>['https://example.com/button.png'],
///   );
///
///   final Map<String, dynamic> json = component.toJson();
///   final ModelPragmaComponent decoded = ModelPragmaComponent.fromJson(json);
///
///   assert(component == decoded);
///   print(decoded.titleComponent);
/// }
/// ```
///
/// Contracts:
/// - The instance is immutable (lists are stored as unmodifiable).
/// - [fromJson] returns [ModelPragmaComponent.empty] when `json` is `null`.
````

Al implementar `empty`, define los literales de lista con `const` para dejar
claro que no se modifican durante la ejecución.

## Buenas prácticas

- Valida las URLs antes de mostrarlas en un `Image.network`, usa placeholders.
- Mantén los JSON en `doc/` o `test/fixtures` para compartirlos con otros
  equipos y alimentar ejemplos automáticos.
- Los valores numéricos (`value`) deben estar entre 0 y 1 para representar
  porcentajes relativos y ese contrato debe estar documentado en el modelo.

Con esta infraestructura se pueden construir catálogos y ejemplos dinámicos a
partir de los mismos metadatos, evitando divergencias entre Storybook y la app
de muestra.
