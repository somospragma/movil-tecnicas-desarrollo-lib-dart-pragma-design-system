# Pragma tags

`PragmaTagWidget` etiqueta usuarios, squads o tópicos usando cápsulas moradas con opción de removerlos desde un ícono X.

## Descripción

- Replica el glow degradado morado con radios de 24dp y borde de 1.5dp para mantener consistencia con los search inputs.
- Acepta avatars o iniciales antes del texto para representar personas, equipos o archivos referenciados.
- Incluye botón de cierre accesible (tooltip + `Semantics`) que permite al usuario limpiar selección sin abandonar el formulario.
- Cambia automáticamente entre estados active/hover/pressed/disabled manteniendo contraste AA sobre fondos claros u oscuros.

## Anatomía

1. **Cápsula**: alto mínimo 40px, radio full, borde 1.5dp. En active usa gradiente `primary` → `secondary`; en disabled aplica `surfaceContainerHighest`.
2. **Avatar / ícono**: círculo de 28px opcional para fotos o iniciales. Se alinea centrado verticalmente.
3. **Label**: `Poppins 12/14`, peso 600, color blanco sobre gradiente o `onSurfaceVariant` cuando está deshabilitado.
4. **Remove**: ícono `close` dentro de botón circular compacto (28px) con tooltip. El relleno usa `primary` al 20%.

## Estados

| Estado   | Tratamiento                                                                  |
| -------- | ---------------------------------------------------------------------------- |
| Active   | Gradiente primario, texto blanco y contorno transparente.                    |
| Hover    | Mantiene gradiente pero agrega glow suave (blur 20px) para imitar neon.      |
| Pressed  | Gradiente más intenso + glow amplio (blur 32px) que refuerza el tap.         |
| Disabled | Fondo gris (`surfaceContainerHighest`), texto/iconos `onSurfaceVariant 60%`. |

## Casos de uso

- Listar responsables de un entregable o squad dentro de formularios multi-step.
- Mostrar etiquetas de filtros activos y permitir quitarlas sin recargar la vista.
- Construir input chips que convierten texto en entities (emails, áreas o tags semánticos).

## Buenas prácticas

1. Limita el ancho del contenedor a `Wrap` + `runSpacing` para que las etiquetas hagan reflow en pantallas estrechas.
2. Usa el botón de remover sólo cuando la etiqueta represente una selección editable; en listas de lectura deja el tag sin X.
3. Mapea cada interacción (tap o remove) a callbacks visibles para que Analytics pueda medir uso.
4. Evita combinar iconos leading y trailing personalizados sin respetar el radio completo (usa `PragmaTagWidget.leading`).

## Implementación

```dart
final List<String> squads = <String>[
  'eugenia.sarmiento@pragma.com.co',
  'growth@pragma.com',
];

Wrap(
  spacing: PragmaSpacing.xs,
  runSpacing: PragmaSpacing.xs,
  children: squads.map((String email) {
    return PragmaTagWidget(
      label: email,
      leading: SizedBox(
        width: 28,
        height: 28,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Text(email.substring(0, 2).toUpperCase()),
        ),
      ),
      onPressed: () => debugPrint('Abrir: $email'),
      onRemove: () => debugPrint('Remover: $email'),
    );
  }).toList(),
);
```

## Recursos

- Showcase interactivo `_TagShowcase` dentro de `example/lib/main.dart` con toggles para avatar, remove y disabled.
- Exportado desde `pragma_design_system.dart`, disponible con `import 'package:pragma_design_system/pragma_design_system.dart';`.
