# Pragma pagination

`PragmaPaginationWidget` replica la cápsula glow utilizada en tablas extensas de Pragma. Combina flechas, páginas numeradas, dropdown "por página" y summary accesible para describir los rangos cargados.

## Descripción

- Funciona como un **pager compacto**: flechas laterales, números y estados selected/disabled.
- Incluye un **dropdown comprimido** para elegir cuántos registros se muestran por página (10/25/50/100 por defecto).
- Muestra un **summary accesible** (`Página X de Y` o `1-25 de 240 resultados`). Puede personalizarse con `summaryBuilder`.
- Soporta dos superficies: `PragmaPaginationTone.dark` (gradiente morado) y `PragmaPaginationTone.light` (surface neutra).
- El selector y el resumen son opcionales; basta con omitir `onItemsPerPageChanged` o `showSummary` para esconderlos.

## Anatomía

1. **Capsule**: contenedor 56px alto, padding 16/12, borde full-radius y gradiente (dark) o superficie clara (light).
2. **Arrow buttons**: `IconButton` compactos (`chevron_left` y `chevron_right`) que respetan disabled cuando se llega al extremo.
3. **Page chips**: `TextButton` rounded de 44px con estilos default/hover/selected/disabled.
4. **Gap**: separador `…` automático cuando hay más de 6 páginas.
5. **Per page selector**: botón comprimido con `PopupMenuButton` para elegir registros.
6. **Summary**: texto `Poppins 14/12` que describe el rango y ayuda a usuarios de lector de pantalla.

## Estados

| Estado   | Tratamiento                                                                |
| -------- | -------------------------------------------------------------------------- |
| Default  | Texto `onPrimary` (dark) u `onSurface` (light), fondo sólido/transparente. |
| Hover    | Resalta el botón con fill semitransparente y mantiene el gradiente activo. |
| Selected | Chip blanco (dark) o primario translúcido (light) con texto `primary`.     |
| Disabled | Íconos y texto bajan a 35% de opacidad, no responden a `onPressed`.        |

## Comportamiento

1. Calcular `totalPages` a partir de registros / perPage y clamp `currentPage` entre `1..total`.
2. Al tocar flechas o números se llama `onPageChanged(page)` y el contenedor actualiza el dataset.
3. El dropdown dispara `onItemsPerPageChanged(value)` y usualmente resetea la página actual.
4. El summary se recalcula automáticamente con la info disponible y puede personalizarse.

## Buenas prácticas

1. Mantén `itemsPerPageOptions` ordenado (10/25/50/100) y evita más de 4 opciones.
2. Si muestras menos de 6 páginas no fuerces gaps; el widget lo resuelve internamente.
3. Cuando conectes datos reales, actualiza también la tabla/lista para que coincida con el summary.
4. Usa `tone: PragmaPaginationTone.light` sobre tarjetas blancas o paneles neutrales; reserva el modo dark para layouts oscuros o gradientes.

## Implementación

```dart
class _MembersPagination extends StatefulWidget {
  const _MembersPagination();

  @override
  State<_MembersPagination> createState() => _MembersPaginationState();
}

class _MembersPaginationState extends State<_MembersPagination> {
  static const List<int> perPageOptions = <int>[10, 25, 50, 100];
  int currentPage = 1;
  int itemsPerPage = 25;
  final int totalItems = 280;

  int get totalPages => (totalItems / itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return PragmaPaginationWidget(
      currentPage: currentPage,
      totalPages: totalPages,
      itemsPerPage: itemsPerPage,
      itemsPerPageOptions: perPageOptions,
      totalItems: totalItems,
      onPageChanged: (int page) {
        setState(() => currentPage = page);
        _fetchPage();
      },
      onItemsPerPageChanged: (int value) {
        setState(() {
          itemsPerPage = value;
          currentPage = 1;
        });
        _fetchPage();
      },
    );
  }

  void _fetchPage() {
    // Refresca la tabla/lista con los nuevos parámetros.
  }
}
```

## Recursos

- Showcase `_PaginationShowcase` en `example/lib/main.dart` con slider de registros y vista previa.
- Exportado desde `pragma_design_system.dart`; basta `import 'package:pragma_design_system/pragma_design_system.dart';`.
