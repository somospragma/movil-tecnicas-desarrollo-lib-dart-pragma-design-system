# Pragma text area

`PragmaTextAreaWidget` permite capturar texto de varias líneas replicando el glow morado, los bordes redondeados y los estados documentados en el spec.

## Descripción

- Soporta copy extenso (briefs, acuerdos, retroalimentación) sin perder los tokens de espaciado y tipografía del sistema.
- Muestra un label superior, placeholder ligero y texto descriptivo configurable que alterna entre helper, error o success.
- El foco aplica el degradado morado y glow característico, mientras que los estados error/success usan fondos tonales (rojo/verde) para mejorar la legibilidad.
- Incluye un contador opcional sincronizado con `maxLength` para alinear validaciones en formularios o flujos QA.

## Anatomía

1. **Label**: `Poppins` bold 14, color primario (#330072) alineado al borde superior izquierdo.
2. **Contenedor**: cápsula con radio 24dp, borde de 1.5dp. En foco usa degradado (`primary` → `secondary`) y glow; en reposo aplica borde sólido.
3. **Área de texto**: `TextField` multi-línea con padding `PragmaSpacing.lg` x `PragmaSpacing.md` para asegurar ritmo vertical.
4. **Descripción**: texto guía (bodySmall) que cambia de color según el estado.
5. **Icono de estado**: `info`, `check` o `warning` acompañan a la descripción para reforzar el feedback.
6. **Contador**: opcional, se alinea al extremo derecho y muestra `valorActual/maxLength`.

## Componentes y estados

| Estado   | Notas                                                                |
| -------- | -------------------------------------------------------------------- |
| Default  | Fondo claro, borde morado (60% opacidad) y helper en color primario. |
| Filled   | Overlay suave (`primary` 5%) para indicar que existe contenido.      |
| Focus    | Glow morado + degradado exterior, cursor y borde alineados al spec.  |
| Error    | Fondo `errorContainer`, texto/ícono `error`, sin glow.               |
| Success  | Fondo `secondaryContainer`, ícono `check`, sin glow.                 |
| Disabled | Superficie `surfaceContainerHighest`, borde `outlineVariant`.        |

## Buenas prácticas

1. Mantén el ancho entre 360 y 480px en mobile y deja crecer verticalmente con `minLines`/`maxLines` según el caso.
2. Usa el contador sólo cuando exista un límite real (`maxLength`) para evitar ruido visual.
3. Evita mezclar `error` y `success` simultáneamente; la API prioriza el error cuando ambos textos están definidos.
4. Para formularios extensos, combina el text area con `PragmaTableWidget` o `PragmaDropdownListWidget` para documentar dependencias y responsables.

## Implementación

```dart
final TextEditingController controller = TextEditingController();

PragmaTextAreaWidget(
  label: 'Notas del requerimiento',
  controller: controller,
  placeholder: 'Describe alcance, riesgos y pendientes...',
  description: 'Comparte el contexto antes de pasarlo al squad dev.',
  maxLength: 320,
  minLines: 4,
  successText: 'Notas listas para compartir.',
  onChanged: (String value) {
    // Sincroniza la data con tu estado o backend.
  },
);
```

## Recursos

- Showcase interactivo en `example/lib/main.dart` (_TextAreaShowcase_) con toggles para disabled/error/success, contador y densidades.
- Exportado desde `pragma_design_system.dart`, basta importar el paquete principal para acceder a `PragmaTextAreaWidget`.
