# Pragma tooltip

`PragmaTooltipWidget` replica el tooltip del spec de Pragma: una cápsula glow/tonal con título opcional, ícono, botón interno y una flecha que apunta al componente objetivo.

## Descripción

- Construido para mostrar copy breve cuando el usuario hace hover, focus o tap prolongado sobre un control.
- Ofrece dos superficies: `dark` (gradiente morado) y `light` (surface neutra con borde suave).
- Permite combinar título + texto, ícono inicial y un botón terciario comprimido para accesos directos.
- Incluye flecha (`arrow`) en las cuatro direcciones (`top`, `bottom`, `left`, `right`).

## Caso de uso

Ideal para explicar acciones de íconos, abreviaturas o botones críticos sin saturar la interfaz. Se activa al apuntar con el cursor, enfocar con teclado o realizar un tap en mobile, y desaparece tras unos segundos o al salir del área activa.

## Anatomía

1. **Cápsula:** contenedor de 16dp con gradiente (dark) o surface clara + borde (`#E6E0E9`).
2. **Contenido:** título opcional (Poppins Semibold 14) y copy principal (Poppins 14 regular, color `#FFFFFF` en dark / `#1D1B20` en light).
3. **Icono:** refuerzo visual ubicado antes del texto (opcional).
4. **Botón interno:** acción secundaria terciaria (opcional, tamaño small).
5. **Arrow:** triángulo de 18px que apunta al objetivo. Puede colocarse arriba, abajo, izquierda o derecha.

## Estados

| Estado   | Tratamiento                                                                   |
| -------- | ----------------------------------------------------------------------------- |
| Default  | Cápsula con sombra/glow. Texto 90% opacidad en dark, `onSurface` en light.    |
| Hover    | Mantiene glow y bloquea el auto-hide mientras el cursor se mantiene dentro.   |
| Focus    | Se muestra si el usuario navega con teclado y enfoca el objetivo.             |
| Disabled | El tooltip no aparece cuando el target está deshabilitado o no tiene handler. |

## Comportamiento

1. `showDelay` ~180ms: evita flicker cuando el cursor solo pasa por encima.
2. `hideDelay` ~120ms: da tiempo al usuario para mover el cursor entre el target y la burbuja.
3. En dispositivos touch, el tooltip permanece visible durante `autoHideDuration` (4s por defecto) y puede cerrarse tocando el target nuevamente.
4. La flecha se alinea automáticamente según `placement` y mantiene un gap de 8px.

## Buenas prácticas

1. Mantén el mensaje debajo de los 120 caracteres; usa `longCopy` únicamente para explicar shortcuts o flujos complejos.
2. Evita más de una acción dentro del tooltip. Si necesitas dos botones, usa un modal o sheet.
3. En fondos oscuros o sobre gradientes, usa `tone: PragmaTooltipTone.light` para preservar el contraste.
4. Usa `Semantics.tooltip` (ya incluido) para describir el contenido en lectores de pantalla.

## Implementación

```dart
class _TooltipPreview extends StatelessWidget {
  const _TooltipPreview();

  @override
  Widget build(BuildContext context) {
    return PragmaTooltipWidget(
      title: 'Título opcional',
      message: 'Texto descriptivo que explica la acción.',
      icon: Icons.info_outline,
      action: PragmaTooltipAction(
        label: 'Button',
        onPressed: () => debugPrint('Action invocada'),
      ),
      tone: PragmaTooltipTone.dark,
      placement: PragmaTooltipPlacement.right,
      child: PragmaButton.icon(
        label: 'Hover me',
        icon: Icons.touch_app,
        hierarchy: PragmaButtonHierarchy.secondary,
        size: PragmaButtonSize.small,
        onPressed: () {},
      ),
    );
  }
}
```

## Recursos

- Showcase `_TooltipShowcase` en `example/lib/main.dart` con toggles para tono, contenido y longitud del copy.
- Snippet en `README.md` y export público via `pragma_design_system.dart`.
