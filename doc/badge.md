# Pragma badge

`PragmaBadgeWidget` resalta estados o etiquetas usando las cápsulas moradas de Pragma, disponibles en variantes light/dark.

## Descripción

- Pensado para estados de lectura (no es interactivo); combina texto breve con color de fondo.
- Acepta íconos opcionales, modo compacto (`dense`) y soporta hasta cinco tonos listos para usar (brand, success, warning, info, neutral).
- Puede renderizarse como badge claro o sobre fondos oscuros gracias a `PragmaBadgeBrightness`.

## Anatomía

1. **Contenedor**: radio full (9999), alto mínimo 24px, borde 1dp en el color del tono.
2. **Tipografía**: `Poppins` 12/11 bold, color contrastante (blanco en dark, `#330072` en light).
3. **Ícono** (opcional): `Icons` de 16px alineado a la izquierda.

## Estados

| Variante | Uso                                                |
| -------- | -------------------------------------------------- |
| Brand    | Estados destacados, "Nuevo", "Beta".               |
| Success  | Éxitos, QA aprobado, despliegue completo.          |
| Warning  | Riesgos, recordatorios, acciones pendientes.       |
| Info     | Mensajes neutrales o etiquetas contextuales.       |
| Neutral  | Metadatos o contadores sin importancia jerárquica. |

## Buenas prácticas

1. Mantén el texto corto (máximo 20 caracteres) para evitar que el badge pierda forma.
2. Si necesitas badges clicables, combínalos con `PragmaTagWidget` o botones terciarios; este componente es sólo informativo.
3. Usa la variante dark únicamente sobre superficies oscuras para asegurar contraste.
4. Para dashboards, agrupa badges dentro de `Wrap` con `PragmaSpacing.xs` para permitir saltos de línea limpios.

## Implementación

```dart
Wrap(
  spacing: PragmaSpacing.xs,
  children: const <Widget>[
    PragmaBadgeWidget(label: 'Nuevo', icon: Icons.bolt),
    PragmaBadgeWidget(
      label: 'QA',
      tone: PragmaBadgeTone.success,
      brightness: PragmaBadgeBrightness.dark,
    ),
    PragmaBadgeWidget(
      label: 'Risk',
      tone: PragmaBadgeTone.warning,
    ),
  ],
);
```

## Recursos

- Showcase `_BadgeShowcase` en `example/lib/main.dart` para alternar tono, densidad, icono y brillo.
- Exportado desde `pragma_design_system.dart`, listo para importarse desde el paquete principal.
