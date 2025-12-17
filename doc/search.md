# Pragma search

`PragmaSearchWidget` replica el campo de busqueda con glow morado, dos tonos base (light/dark) y el boton circular que intercambia la accion de limpiar o ejecutar la busqueda.

## Descripcion

- Nace como variante del `PragmaInputWidget` enfocada en busquedas globales o destacadas.
- Combina halo degradado, fondo translucido y boton flotante acorde al spec mobile.
- Admite controles antes/despues del texto (`leading`/`trailing`) para chips, filtros rapidos o acciones personalizadas.
- Se integra con overlays o listas de sugerencias (`Dropdown list`) al reaccionar al evento `onChanged`.

## Anatomia

1. **Glow frame**: contenedor externo con degradado primario + secundario mas sombra suave de 32 px.
2. **Track**: superficie interna que alterna fondo translucido (dark) o claro (light) y alberga el texto.
3. **Leading slot**: opcional, ideal para chips de etiquetas o filtros activos.
4. **Input text**: `TextField` compacto que fuerza `TextInputAction.search` y cursor morado.
5. **Action button**: circulo con icono de buscar/cerrar que cambia segun haya query y estado de disabled.
6. **Info text**: leyenda inferior que explica atajos, comandos o comportamiento del dropdown.

## Estados

- **Default light**: superficie clara, texto oscuro y placeholder en `onSurfaceVariant`.
- **Default dark**: superficie translucida y texto blanco para overlays, manteniendo el glow morado.
- **Hover/focus**: activa el degradado exterior y la sombra neon; se comparte con el estado filled.
- **Filled**: conserva el glow mientras exista texto (`_hasValue`).
- **Disabled**: baja la opacidad del fondo interno, texto e icono, ademas apaga el glow.
- **Info text**: conserva color diferencial (blanco 70% en dark, primario en light) para no competir con el contenido.

## Interacciones

- `onChanged` permite alimentar sugerencias mientras el usuario escribe (ej. `Dropdown list`).
- `onSubmitted` ejecuta la busqueda con el contenido actual o se invoca tocando el boton circular cuando no hay query.
- `onClear` borra el texto y es util para sincronizar filtros externos.
- La propiedad `infoText` debe describir atajos: "Usa palabras clave" o "Presiona Enter para comandos".
- Usa `leading` para chips de filtro rapido (estado seleccionado, persona, proyecto) sin desplazar el placeholder.

## Implementacion

```dart
final TextEditingController controller = TextEditingController();

PragmaSearchWidget(
  controller: controller,
  placeholder: 'Busca squads o features',
  tone: PragmaSearchTone.dark,
  size: PragmaSearchSize.large,
  infoText: 'Escribe un termino o abre el dropdown con long press.',
  onChanged: (String value) {
    // Actualiza la lista de sugerencias o dropdown list
  },
  onSubmitted: (String query) {
    debugPrint('Buscar: $query');
  },
  onClear: () {
    debugPrint('Busqueda reiniciada');
  },
);
```

## Buenas practicas

1. Limita el ancho entre 320 y 400 px en mobile para conservar la proporcion del glow.
2. Prefiere `PragmaSearchSize.small` en toolbars densas o filtros secundarios.
3. Cuando muestres sugerencias, reutiliza `PragmaDropdownListWidget` o un panel personalizado alineado al borde inferior.
4. Coloca `Semantics` adicionales si el `leading` usa chips no textuales (por ejemplo, estados con iconos).

## Recursos

- Playground en `example/lib/main.dart` (_SearchShowcase_) con toggles para tono, tamano, disabled e info text.
- Exportado desde `pragma_design_system.dart`, solo importa el paquete principal y usa `PragmaSearchWidget`.
