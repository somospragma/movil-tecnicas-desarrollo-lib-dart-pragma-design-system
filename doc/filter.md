# Pragma filter

`PragmaFilterWidget` replica los filtros de tabla morados que aparecen en el spec de Pragma. Permiten abrir un panel flotante, seleccionar múltiples parámetros y mostrar las selecciones activas como tags.

## Descripción

- Cada filtro funciona como una "cápsula" con contador. Al tocarlo se despliega el panel y el estado pasa a _open_.
- El panel permite marcar varias opciones con checkboxes, muestra cuántos parámetros están activos y ofrece acciones "Filtrar" y "Limpiar".
- Las selecciones se resumen como tags fuera de la tabla para recordar con qué criterios se está consultando la data.
- Disponible en dos superficies: `dark` (gradiente morado) y `light` (surface neutra) para adaptarse a fondos claros u oscuros.

## Anatomía

1. **Filtro collapsed**: cápsula 48px de alto, padding 12/8, borde de 1.5dp y glow morado cuando está activo/hover.
2. **Conteo**: etiqueta `Poppins 14` bold con contador en paréntesis cuando existen selecciones.
3. **Chevron**: ícono `expand_more` que rota al desplegarse.
4. **Panel**: contenedor 320px+ con borde redondeado (24dp), overlay oscuro/ligero y scroll interno.
5. **Opciones**: lista de checkboxes `Poppins 14/12` más etiquetas secundarias para metadatos.
6. **Footer**: botones "Limpiar" (terciario) y "Filtrar" (primario small).
7. **Tags**: `PragmaTagWidget` con botón de cerrado para eliminar parámetros aplicados.

## Estados

| Estado   | Tratamiento                                                                       |
| -------- | --------------------------------------------------------------------------------- |
| Default  | Cápsula con stroke morado al 60%, texto `onSurface` (light) u `onPrimary` (dark). |
| Hover    | Glow suave + gradiente más intenso en dark.                                       |
| Open     | Mantiene el glow y deja el panel anclado bajo el filtro.                          |
| Disabled | Stroke y texto usan `onSurfaceVariant`, no abre el panel.                         |

## Comportamiento

1. Estado inicial `default` sin chips activos, texto "Nombre filtro".
2. Hover sobre la cápsula -> se pinta el glow y aparece el panel flotante.
3. Al seleccionar opciones, el nombre del filtro muestra el contador `(n)` y se habilita el botón de aplicar.
4. Tras aplicar, las selecciones se convierten en tags externos con botón "Limpiar filtros" para volver al estado base.

## Buenas prácticas

1. Agrupa cada parámetro en un filtro distinto; evita colocar más de 6 filtros por fila.
2. Usa `summaryLabel` para recordar al usuario que puede eliminar tags individuales.
3. Prefiere el modo `dark` sobre listas densas o tablas con fondos oscuros; en tarjetas claras utiliza `PragmaFilterTone.light`.
4. Cuando existan más de cuatro opciones, incluye descripciones cortas para guiar la selección.

## Implementación

```dart
final List<PragmaFilterOption> squadOptions = <PragmaFilterOption>[
  const PragmaFilterOption(value: 'atlas', label: 'Squad Atlas'),
  const PragmaFilterOption(value: 'cosmos', label: 'Squad Cosmos'),
  const PragmaFilterOption(value: 'orbit', label: 'Squad Orbit'),
];

class _TableFiltersState extends State<_TableFilters> {
  Set<String> squads = <String>{'atlas'};

  @override
  Widget build(BuildContext context) {
    return PragmaFilterWidget(
      label: 'Squads',
      options: squadOptions,
      selectedValues: squads,
      onChanged: (Set<String> values) {
        setState(() => squads = values);
        _refetchData();
      },
      summaryLabel: 'Filtros activos',
      helperText: 'Selecciona squads para acotar el listado.',
    );
  }

  void _refetchData() {
    // Ejecuta la consulta filtrada.
  }
}
```

## Recursos

- Showcase `_FilterShowcase` dentro de `example/lib/main.dart` con controles para cambiar tonos, helper text y filtros aplicados.
- Exportado en `pragma_design_system.dart`, por lo que basta con importar el paquete principal.
