# Pragma radio button

`PragmaRadioButtonWidget` permite seleccionar una única opción dentro de un grupo usando el glow morado característico y estados accesibles.

## Descripción

- Replica la cápsula circular de 24px con borde de 2px, sombra interna y glow en hover/pressed como indica el spec.
- Exponer label y descripción ayuda a contextualizar la decisión; el layout soporta densidades compactas.
- Se integra con formularios largos gracias al mismo sistema de espaciado (8/16/24) y tokens tipográficos de `PragmaTypography`.
- Acepta estados `selected`, `unselected`, `hover`, `pressed` y `disabled`, todos animados con `AnimatedContainer`.

## Anatomía

1. **Stroke**: 2px, color `#6429CD` (token `primary`).
2. **Inner circle**: 12px, relleno `primary`, sombra interior `rgba(189,189,255,0.7)`.
3. **Glow**: se activa en hover/pressed para resaltar el foco del usuario.
4. **Label**: `Poppins 14` bold, color `#330072` (onSurface).
5. **Descripción**: `Poppins 12` regular, `onSurfaceVariant`.

## Estados

| Estado     | Tratamiento                                                                 |
| ---------- | --------------------------------------------------------------------------- |
| Unselected | Borde `outlineVariant`, relleno transparente.                               |
| Selected   | Stroke y fill `primary`, inner circle de 12px, glow suave.                  |
| Hover      | Mantiene fill primario y agrega glow (blur 10px) en `primary`.              |
| Pressed    | Stroke/inner circle pasan a `secondary`, glow más intenso (blur 14px).      |
| Disabled   | Stroke y label bajan a `onSurfaceVariant 60%`, se reduce la opacidad total. |

## Buenas prácticas

1. Mantén la selección actual en `groupValue` y envía el nuevo valor a tu estado/Bloc/BLoC vía `onChanged`.
2. Coloca los radios dentro de un `Column` o `Wrap` con `PragmaSpacing.sm` para respetar el ritmo vertical.
3. Usa la propiedad `dense` cuando necesites filas más compactas dentro de tablas o paneles laterales.
4. Si requieres una opción "ninguna", agrega un radio con valor `null` y explica que limpia la selección.

## Implementación

```dart
String? level = 'full';

PragmaRadioButtonWidget<String>(
  value: 'full',
  groupValue: level,
  label: 'Acceso completo',
  description: 'Administra squads y edita entregables.',
  onChanged: (String? value) {
    setState(() => level = value);
  },
);
```

## Recursos

- Sección `_RadioButtonShowcase` en `example/lib/main.dart` con toggles para disabled, dense y helper text.
- Exportado automáticamente en `pragma_design_system.dart` para uso inmediato.
