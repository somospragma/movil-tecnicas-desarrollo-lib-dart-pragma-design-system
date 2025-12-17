# Pragma tables

`PragmaTableWidget` replica las tablas de filas moradas con glow del sistema y permite mezclar casillas, avatares, íconos y botones dentro de cada columna usando widgets de Flutter.

## Descripción

- Las tablas organizan conjuntos de datos en filas y columnas, priorizando legibilidad y estados claros.
- Cada fila puede alternar entre tonos claros u oscuros más un estado `hover` con degradado morado o `selected` para resaltar el registro activo.
- El widget acepta cualquier composable como celda, por lo que es sencillo combinar checkboxes, chips, botones o texto enriquecido.

## Anatomía

1. **Header**: fila superior con títulos alineados por columna (tipografía `labelLarge`, 16 dp de padding vertical).
2. **Row tokens**: altura de 56–64 dp, padding horizontal `PragmaSpacing.md` para alinear contenido con tarjetas.
3. **Glow track**: el estado `hover` usa gradiente primario + secundario y sombra externa de 32 dp para reflejar el riel morado.
4. **Controls**: casillas, iconos o botones pueden convivir en la misma fila porque cada celda recibe `Widget`.

## Componentes

| Variante      | Notas                                                         |
| ------------- | ------------------------------------------------------------- |
| Text + avatar | Resume al colaborador y rol asignado dentro del flujo.        |
| Text + icon   | Ideal para status o atajos a acciones rápidas.                |
| Checkbox      | Activa selección múltiple o bulk actions.                     |
| Icon button   | Coloca acciones compactas (ver, editar, eliminar).            |
| Button        | Usa `PragmaButtonSize.small` para respetar los 40 dp de alto. |
| Text only     | Útil para tags, identificadores o notas sin controles.        |

## Estados

- **Hover**: gradiente morado (`ColorScheme.primary` → mezcla con `secondary`) + sombra violeta y texto blanco.
- **Default-light**: fondo claro (`ColorScheme.surface`), texto en `onSurface` y divisores sutiles.
- **Default-dark**: fondo `primaryGray900` con texto blanco. Útil para headers oscuros o tablas sobre layouts neon.
- **Selected**: overlay secundario translúcido que marca la fila como activa sin perder legibilidad.

## Ejemplos

- **Table light**: filas claras con bordes suaves y botones outlined alineados a la derecha.
- **Table dark**: filas oscuro-gris con íconos claros y botones invertidos.
- **Row states**: combina `tone`, `state` y `compact` para mostrar hover, default y densidades tipo dashboard.

## Caso de uso

- Organizar y mostrar datos complejos (recursos, tareas, usuarios).
- Cuando el usuario necesita navegar a un registro específico dentro de un flujo.
- Visualizar todos los recursos asignados a una persona.
- Reemplazar aplicaciones de hoja de cálculo ligeras o embebidas.

## Implementación

```dart
final List<PragmaTableColumn> columns = <PragmaTableColumn>[
  const PragmaTableColumn(label: '', flex: 1),
  const PragmaTableColumn(label: 'Nombre', flex: 4),
  const PragmaTableColumn(label: 'Proyecto', flex: 3),
  const PragmaTableColumn(label: 'Acción', flex: 2, alignment: Alignment.centerRight),
];

PragmaTableWidget(
  columns: columns,
  rows: <PragmaTableRowData>[
    PragmaTableRowData(
      tone: PragmaTableRowTone.dark,
      state: PragmaTableRowState.hover,
      cells: <Widget>[
        Checkbox(value: true, onChanged: (_) {}),
        Row(
          children: <Widget>[
            const CircleAvatar(radius: 18, child: Text('AY')),
            const SizedBox(width: PragmaSpacing.xs),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text('Andreina Yajaira Francesca Serrano'),
                Text('Discovery Research'),
              ],
            ),
          ],
        ),
        const Text('Discovery Lab'),
        const Icon(Icons.auto_awesome_outlined),
        PragmaTertiaryButton(
          label: 'Ver ficha',
          size: PragmaButtonSize.small,
          onPressed: () {},
        ),
      ],
    ),
  ],
);
```

## Buenas prácticas

1. Alínea controles verticalmente para conservar ritmo visual (usa `Alignment.centerRight` en columnas de acción).
2. Limita el número de columnas visibles en mobile (3–4 máximo) y utiliza `compact: true` para dashboards densos.
3. Reutiliza `semanticLabel` en `PragmaTableRowData` cuando la fila combina íconos y texto sin contexto.
4. Mantén botones secundarios (`PragmaTertiaryButton` o `PragmaSecondaryButton`) para no competir con el glow morado.

## Recursos

- Playground en `example/lib/main.dart` (_TableShowcase_) con toggles para tono, estado hover y densidad.
- Exportado desde `pragma_design_system.dart`, basta importar el paquete principal.
