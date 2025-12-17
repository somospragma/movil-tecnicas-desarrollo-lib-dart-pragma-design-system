# Pragma calendar guidelines

`PragmaCalendarWidget` entrega un calendario interactivo alineado con los tokens y patrones del diseño Pragma. Soporta selección única o por rangos, límites dinámicos y distintos niveles de zoom (mes, año y década) dentro de la misma superficie.

## Enfoque

1. **Control centralizado**: `PragmaCalendarController` concentra mes activo, modo de visualización y selección vigente para que la vista pueda sincronizarse con formularios, filtros o atajos externos.
2. **Estados consistentes**: la cuadrícula de días, los chips anuales y las tarjetas se renderizan con los radios y espaciados definidos en `PragmaBorderRadius` y `PragmaSpacing`, evitando ajustes manuales.
3. **Accesibilidad integrada**: se respetan los `MaterialLocalizations` del contexto para formatear fechas, calcular el primer día de la semana y anunciar las selecciones con semántica correcta.
4. **Niveles de exploración**: la cabecera incorpora un `SegmentedButton` que alterna entre vista mensual, anual o por décadas para facilitar saltos rápidos sin abandonar la página.

## Casos de uso

| Escenario                    | Recomendación                                                                                  | Ejemplo                                                 |
| ---------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| Selección puntual (pickers)  | Usa `PragmaCalendarSelectionMode.single` y fija `initialStartDate`.                            | Formularios de vacaciones, fecha de nacimiento.         |
| Rangos analíticos            | Habilita modo `range` y expone atajos (hoy, semana, mes actual) desde un `PragmaCard`.         | Dashboards, reportes comparativos, filtros de cohortes. |
| Disponibilidad limitada      | Define `minDate` y `maxDate` en tiempo real (por ejemplo desde backend).                       | Agenda de citas, reservas con disponibilidad recortada. |
| Navegación histórica extensa | Cambia el `displayMode` inicial del controlador a `PragmaCalendarDisplayMode.year` o `decade`. | Administración de logs, auditorías, releases antiguos.  |

## Implementación

### Bloques esenciales

```dart
final PragmaCalendarController controller = PragmaCalendarController(
  initialMonth: DateTime(2025, 1),
  startDate: DateTime(2025, 1, 10),
  endDate: DateTime(2025, 1, 24),
);

PragmaCalendarWidget(
  controller: controller,
  selectionMode: PragmaCalendarSelectionMode.range,
  minDate: DateTime(2024, 12, 1),
  maxDate: DateTime(2025, 3, 31),
  onSelectionChanged: (PragmaCalendarSelection value) {
    // Actualiza filtros, guarda en un form, etc.
  },
);
```

### Escenario 1: selección única embebida en formularios

- Configura `selectionMode` en `single` y pasa `initialStartDate` (o `startDate` del controlador) para precargar el valor guardado.
- Cada vez que `onSelectionChanged` emite un valor, convierte la fecha a tu modelo (por ejemplo, un `TextEditingController` con formato corto) para mantener bidireccionalidad.
- Si necesitas validar contra límites legales (edad mínima), define `minDate`/`maxDate` y usa `controller.setSelection` cuando el formulario cambie.

### Escenario 2: selección de rangos con atajos

- Mantén un único controlador compartido entre el calendario y los botones de atajo.
- Crea utilitarios que calculen rangos relativos (hoy, últimos 7 días, mes fiscal) y llama a `controller.setSelection` + `controller.setMonth` para alinear la vista.
- Muestra el resumen activo en un `PragmaCard.section`, similar a la pantalla `CalendarDemoPage`, para que el usuario entienda qué intervalo está aplicando antes de ejecutar un filtro costoso.

### Escenario 3: disponibilidad restringida por backend

- Obtén las fechas válidas desde tu API y mapea la respuesta a `DateTime` truncado (`DateUtils.dateOnly`).
- Asigna `minDate` y `maxDate` al widget y escucha `onSelectionChanged`. Si el backend retorna huecos no contiguos, deshabilita manualmente los días aplicando lógica adicional en un fork del widget o encapsulándolo.
- Cuando cambien los límites, recuerda llamar a `controller.clearSelection()` si la selección previa cae fuera del rango permitido.

### Buenas prácticas

- Mantén una sola instancia del controlador por calendario para aprovechar `ChangeNotifier` y evitar fugas.
- Siempre muestra feedback textual de la selección para accesibilidad (por ejemplo, usando `MaterialLocalizations.formatFullDate`).
- Si la pantalla ofrece opciones avanzadas, encapsula los controles en `PragmaCard.section` para heredar los tokens del sistema y conservar consistencia visual.

### Recursos adicionales

- Demo interactiva en `example/lib/calendar_demo_page.dart` (incluye atajos, copiado al portapapeles y límites dinámicos).
- `PragmaCalendarWidget` está exportado desde `pragma_design_system.dart`, por lo que basta con `import 'package:pragma_design_system/pragma_design_system.dart';` en apps consumidoras.
