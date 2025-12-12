# Component modeling (0.0.5)

## Goal

Represent the components delivered by design with a consistent model that keeps documentation, showcases, and squads aligned.

## Folder structure

```
lib/
  src/
    domain/
      models/
        model_anatomy_attribute.dart
        model_pragma_component.dart
```

Models live inside `lib/src` to preserve the encapsulation pattern and are re-exported through `pragma_design_system.dart`.

## Available models

### `ModelPragmaComponent`

| Property         | Type                          | Description                                            |
| ---------------- | ----------------------------- | ------------------------------------------------------ |
| `titleComponent` | `String`                      | Component name, aligned with the Figma source.         |
| `description`    | `String`                      | Short summary that explains the intent.                |
| `anatomy`        | `List<ModelAnatomyAttribute>` | Highlighted anatomy entries for the documentation.     |
| `useCases`       | `List<String>`                | Recommended use cases.                                 |
| `urlImages`      | `List<String>`                | Screenshots or mockups hosted in a CDN of your choice. |

### `ModelAnatomyAttribute`

| Property      | Type     | Default | Description                                                 |
| ------------- | -------- | ------- | ----------------------------------------------------------- |
| `title`       | `String` | —       | Visible name of the anatomy element.                        |
| `description` | `String` | `''`    | Optional text that expands the title.                       |
| `value`       | `double` | `0.1`   | Quantitative indicator (for example a relative percentage). |

Both models ship `copyWith`, `toJson`, and `fromJson` to guarantee the JSON roundtrip required by the showcases.

## JSON example

```json
{
  "titleComponent": "PragmaAccordionWidget",
  "description": "Expandable panel with controlled states",
  "anatomy": [
    { "title": "Header", "description": "Clickable content", "value": 0.5 }
  ],
  "useCases": ["FAQs", "Documentation"],
  "urlImages": ["https://cdn.pragma.co/components/accordion.png"]
}
```

## Flutter usage

```dart
final Map<String, dynamic> json = ... // provided by Storybook or Figma
final ModelPragmaComponent component = ModelPragmaComponent.fromJson(json);

for (final ModelAnatomyAttribute item in component.anatomy) {
  debugPrint('${item.title}: ${item.description}');
}
```

## In-code documentation guide

Always include documentation comments that explain how the models are used, the immutability contract, and a functional example that can be copied into tests. Use the following template for `ModelPragmaComponent`:

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

When implementing `empty`, declare the list literals as `const` to make the immutability contract explicit.

## Best practices

- Validate URLs before feeding them into `Image.network` and keep placeholders ready.
- Store the JSON files inside `doc/` or `test/fixtures` to share them with other teams and power automated examples.
- Numeric values (`value`) must stay within the 0–1 range to represent relative percentages, and that contract should be documented in the model itself.

This infrastructure lets you build catalogs and live examples from the same metadata, preventing divergences between Storybook and the showcase app.
