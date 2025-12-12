# Utilitarios de grilla responsiva

Esta guía explica cómo aprovechar los tokens y helpers introducidos en `pragma_design_system` para construir layouts consistentes y cómo usar `PragmaGridContainer` como overlay de depuración.

## Viewports y tokens disponibles

El motor expone cuatro breakpoints alineados con Material Design. Cada uno define columnas, gutters y márgenes mínimos que puedes consultar en `PragmaGridTokens`.

| Viewport  | Ancho de referencia | Columnas | Gutter | Margen mínimo |
| --------- | ------------------- | -------- | ------ | ------------- |
| `mobile`  | hasta 599 px        | 4        | 16 dp  | 32 dp         |
| `tablet`  | 600-1023 px         | 8        | 16 dp  | 32 dp         |
| `desktop` | 1024-1919 px        | 12       | 24 dp  | 100 dp        |
| `tv`      | 1920+ px            | 12       | 24 dp  | 100 dp        |

## Obtener la configuración de grilla

`lib/src/layout/pragma_grid.dart` expone funciones para convertir el ancho disponible en una configuración de grilla reutilizable.

```dart
final PragmaGridConfig grid = getGridConfigFromContext(context);

return Padding(
  padding: EdgeInsets.symmetric(horizontal: grid.margin),
  child: Row(
    children: <Widget>[
      SizedBox(width: grid.columnWidth, child: const _ModuleCard()),
      SizedBox(width: grid.gutter),
      // ...
    ],
  ),
);
```

Cuando necesitas calcularlo sin un `BuildContext` (por ejemplo, en tests o servicios de layout), usa `getGridConfigFromWidth(double width)`.

## Detectar el viewport

Puedes mapear cualquier ancho a un `PragmaViewportEnum` para ejecutar lógica condicional (mostrar/ocultar widgets, ajustar densidades, etc.).

```dart
final PragmaViewportEnum viewport = getViewportFromContext(context);
if (viewport == PragmaViewportEnum.mobile) {
  // Simplifica el layout o reduce columnas
}
```

## Usar `PragmaGridContainer`

`PragmaGridContainer` es un widget utilitario que pinta columnas, gutters y márgenes sobre su `child`. Al estar basado en `CustomPainter`, solo se muestra en pantalla y no afecta la interacción.

```dart
return PragmaGridContainer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: const <Widget>[
      _ModuleCard(),
    ],
  ),
);
```

El overlay incluye un badge flotante con métricas en tiempo real. Puedes personalizar colores pasando `columnColor`, `gutterColor`, `marginColor` o `infoBackgroundColor`.

## Flujo recomendado para implementadores

1. **Configura Poppins offline** siguiendo la guía `doc/poppins_offline.md` y ejecuta la app de ejemplo para validar que todo compila.
2. **Integra los helpers**: reemplaza márgenes mágicos por `grid.margin`, `grid.columnWidth` y `grid.gutter`. Esto garantiza que los componentes siempre coincidan con la grilla oficial.
3. **Activa el overlay** en las pantallas que estés maquetando. Envuelve tu `Scaffold` (o cualquier rama del árbol) con `PragmaGridContainer` y navega por distintos tamaños para validar.
4. **Verifica las métricas** usando el badge inferior: asegúrate de que el viewport reportado coincida con el diseño en Figma y que los márgenes/columnas esperados estén presentes.
5. **Desactiva el overlay** antes de liberar la build final. El widget está pensado para entornos de desarrollo o QA.

## Recursos adicionales

- Revisa la página `Grid debugger` dentro de `example/lib/main.dart` para ver una implementación completa, incluyendo navegación desde la `AppBar`.
- Las pruebas ubicadas en `test/pragma_grid_test.dart` son una referencia mínima de cómo validar los cálculos ante cambios futuros.
