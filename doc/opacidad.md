# Tokens de opacidad

## Propósito

Los overlays y estados hover del Design System deben conservar contraste sin
importar el fondo. Para lograrlo limitamos los niveles de transparencia a tres
intervalos: 8%, 30% y 60%. Estos valores funcionan tanto en superficies claras
como en temas oscuros, evitando inconsistencias en Storybook y en los productos.

## Implementación en Flutter

Desde Flutter 3.22 el API `Color.withOpacity` quedó deprecado en favor de
`Color.withValues`. Para mantenerse alineado se exponen helpers en el paquete:

```dart
final Color hover = PragmaOpacity.apply(
  scheme.primary,
  PragmaOpacityTokens.opacity08,
);

final Color disabledBorder = scheme.outlineVariant.withValues(
  alpha: PragmaOpacity.opacity60,
);
```

Usa `PragmaOpacityTokens` cuando necesites el descriptor completo (nombre y
porcentaje) y `PragmaOpacity` si solo requieres el valor decimal.

## Tabla de tokens

| Nombre     | Porcentaje | Token             | Valor decimal |
| ---------- | ---------- | ----------------- | ------------- |
| Opacity-8  | 8%         | `$pds-opacity-8`  | 0.08          |
| Opacity-30 | 30%        | `$pds-opacity-30` | 0.30          |
| Opacity-60 | 60%        | `$pds-opacity-60` | 0.60          |

> Si necesitas un valor distinto, vuelve al equipo de diseño para confirmar si
> debe añadirse a la escala o si se puede resolver con estos intervalos.
