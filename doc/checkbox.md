# Pragma checkbox

`PragmaCheckboxWidget` permite seleccionar múltiples elementos o representar estados indeterminados usando los tokens oficiales de Pragma.

## Descripción

- Mantiene el cuadro de 24px con borde de 2px, esquinas de 8dp y glow morado cuando el puntero pasa por encima.
- Soporta los tres estados del spec: unchecked, checked e indeterminate (mezcla); el último se activa con `tristate: true` y `value: null`.
- Incluye label + descripción para documentar permisos o tareas, respetando la escala `Poppins 14/12`.
- El modo denso reduce el padding vertical para encajar en tablas, paneles laterales o listas largas.

## Anatomía

1. **Caja base**: 24x24, radio 8dp, borde 2dp. En default usa `outlineVariant`; en hover se activa glow.
2. **Icono**: check de 16px en `#FFFFFF` cuando está seleccionado.
3. **Indeterminate**: barra horizontal de 10px centrada, color `#FFFFFF` y radio 2dp.
4. **Label**: `Poppins` bold 14 (`onSurface`).
5. **Descripción**: `Poppins` regular 12 (`onSurfaceVariant`).

## Estados

| Estado        | Tratamiento                                                                               |
| ------------- | ----------------------------------------------------------------------------------------- |
| Unchecked     | Fondo `surface`, borde `outlineVariant`.                                                  |
| Hover         | Glow morado (blur 12) más relleno `primary` al 8% cuando está desmarcado.                 |
| Checked       | Fondo `primary`, ícono blanco, glow suave.                                                |
| Indeterminate | Mismo relleno que checked pero con barra horizontal blanca.                               |
| Pressed       | Stroke y relleno cambian a `secondary` con glow más intenso.                              |
| Disabled      | Caja `surface`, borde e iconografía `onSurfaceVariant` al 60%, texto con menor contraste. |

## Buenas prácticas

1. Usa `tristate` sólo cuando necesites reflejar selecciones parciales (por ejemplo, "Seleccionar todos").
2. Si presentas más de cuatro opciones, agrupa los checkboxes en una tarjeta o list tile y mantén `PragmaSpacing.sm` entre filas.
3. Combina checkboxes con `PragmaTagWidget` para mostrar chips persistentes cuando el usuario confirme su selección.
4. Evita mezclar varios tamaños: mantén el cuadro en 24px para conservar consistencia con los iconos restantes.

## Implementación

```dart
bool notifications = true;
bool weeklyDigest = false;

PragmaCheckboxWidget(
  value: notifications,
  label: 'Notificaciones push',
  description: 'Alertas inmediatas después de cada despliegue.',
  onChanged: (bool? value) {
    setState(() => notifications = value ?? false);
  },
);

PragmaCheckboxWidget(
  value: weeklyDigest,
  label: 'Resumen semanal',
  onChanged: (bool? value) {
    setState(() => weeklyDigest = value ?? false);
  },
);
```

## Recursos

- Showcase interactivo `_CheckboxShowcase` dentro de `example/lib/main.dart` con toggles para densidad, disabled y estado maestro.
- Disponible vía `import 'package:pragma_design_system/pragma_design_system.dart';` al exportarse desde la biblioteca principal.
