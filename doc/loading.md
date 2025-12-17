# Pragma loading widgets

Los indicadores de carga comunican que una solicitud sigue en curso, sobre todo cuando un cálculo o consulta tardará más de tres segundos. `PragmaLoadingWidget` replica el relleno morado con resplandor interno descrito en las guías para mantener la estética neon del sistema.

## Descripción

- **Circular:** mantiene el porcentaje centrado dentro del anillo y combina un trazo base gris con un arco degradado que incluye brillo interior y sombra externa.
- **Progress bar:** usa un track suave y un relleno con gradiente morado que proyecta una sombra violeta tenue para reforzar el efecto de luz.
- Ambos estilos interpolan con `TweenAnimationBuilder` para que los cambios de estado no sean bruscos cuando se reciben nuevos avances desde el backend.

## Anatomía

### Circular

1. **Track** (onSurfaceVariant al 20% de opacidad) para dejar referencia del 100%.
2. **Fill neon**: degradado morado (`ColorScheme.primary` → mezcla con `secondary`) + `MaskFilter.blur` para lograr luz interna.
3. **Glow externo**: segundo trazo con blur y `BlurStyle.outer`.
4. **Label**: porcentaje en `titleMedium`, centrado.

### Progress bar

1. **Track** redondeado de 14 dp que usa el mismo color neutro.
2. **Fill** con gradiente lineal y dos `BoxShadow` que generan la luz tenue.
3. **Label flotante**: badge compacto sobre el relleno para mostrar el porcentaje, con `border-radius-m`.

## Componentes

| Variante | Sugerencias                                                                                              |
| -------- | -------------------------------------------------------------------------------------------------------- |
| Circular | Tamaños entre 96 y 144 dp, `strokeWidth` recomendado: 10–14 dp. Ideal para paneles de estado.            |
| Linear   | Alto de 12–16 dp con `linearWidth` fijo (por ejemplo 240 dp) cuando se alinea en formularios o tarjetas. |

## Caso de uso

- Úsalos cuando una petición sepa que tardará más de tres segundos.
- No muestran el detalle del cálculo, pero tranquilizan al usuario confirmando que la acción sigue viva.
- Prefiere el indicador circular para modales o hero cards y la barra lineal para flujos de formularios, listas y secciones contextuales.

## Implementación

```dart
PragmaLoadingWidget(
  value: controller.progress, // double 0..1
  caption: 'Circular',
);

PragmaLoadingWidget(
  variant: PragmaLoadingVariant.linear,
  value: controller.progress,
  linearWidth: 260,
  caption: 'Progress bar',
);
```

### Propiedades clave

| Propiedad                      | Descripción                                                                    |
| ------------------------------ | ------------------------------------------------------------------------------ |
| `value`                        | Avance entre 0 y 1. Se clamp-ea automáticamente para evitar valores inválidos. |
| `variant`                      | `circular` o `linear`.                                                         |
| `showPercentageLabel`          | Oculta el porcentaje integrado cuando se requiere un indicador sin texto.      |
| `caption`                      | Texto auxiliar colocado debajo del componente.                                 |
| `linearWidth` / `linearHeight` | Ajustan las dimensiones cuando se usa la barra.                                |
| `size` / `strokeWidth`         | Controlan el diámetro y grosor del anillo.                                     |

### Buenas prácticas

1. Sincroniza el valor cada vez que tu capa de datos entregue progreso real (por ejemplo, chunks descargados, pasos de un workflow, etc.).
2. Si el progreso es desconocido, usa un `CircularProgressIndicator` estándar; `PragmaLoadingWidget` se centra en estados determinísticos.
3. En layouts oscuros mantén suficiente padding (≥ PragmaSpacing.sm) para que el brillo no colisione con otros componentes.

### Recursos

- Demo en `example/lib/main.dart` (_Loading widgets_) para ver el slider que modifica ambos estilos en tiempo real.
- Incluido en `pragma_design_system.dart`, por lo que basta importar el paquete principal.
