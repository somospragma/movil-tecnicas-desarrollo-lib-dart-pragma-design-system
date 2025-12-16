# Rounded corners

Establecer radios de borde consistentes ayuda a que las tarjetas, banners, inputs y avatares se vean familiares entre sí. Esta guía documenta los tokens soportados en Flutter, su correspondencia con las especificaciones de diseño y los casos de uso recomendados.

## Escala oficial

| Token                | Design token              | Valor (dp) | Uso sugerido                                                                    |
| -------------------- | ------------------------- | ---------- | ------------------------------------------------------------------------------- |
| `border-radius-s`    | `$pds-border-radius-s`    | 4          | Íconos, badges compactos, elementos dentro de tablas o chips densos.            |
| `border-radius-m`    | `$pds-border-radius-m`    | 8          | Controles táctiles regulares como botones, inputs y cards pequeñas.             |
| `border-radius-l`    | `$pds-border-radius-l`    | 16         | Superficies predominantes como cards de información, banners y modales.         |
| `border-radius-xl`   | `$pds-border-radius-xl`   | 24         | Componentes hero, mockups incrustados o layouts que necesitan aún más suavidad. |
| `border-radius-full` | `$pds-border-radius-full` | 9999       | Avatares circulares u otros elementos que deben ser perfectamente redondos.     |

> La escala avanza en incrementos de 4 y 8 dp. Si tu componente necesita un radio intermedio, elige el token más cercano para preservar el ritmo visual del sistema.

## Implementación en Flutter

Usa `PragmaBorderRadiusTokens` cuando necesites metadatos (nombre, design token y valor) o `PragmaBorderRadius` para atajos directos.

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: PragmaBorderRadiusTokens.l.toBorderRadius(),
  ),
);

final BorderRadius heroRadius =
    PragmaBorderRadius.circular(PragmaBorderRadius.xl);
```

Ambas clases viven en `package:pragma_design_system/pragma_design_system.dart`, por lo que solo necesitas importar la librería principal.

## Reglas de uso

1. **Mantén la progresión**: si un layout combina múltiples superficies, usa radios consecutivos (ej. `m` para tarjetas y `l` para contenedores principales) para evitar saltos abruptos.
2. **Cuadrícula de 4 dp**: los tokens se alinean con la cuadrícula base, así que evita valores arbitrarios como 10 o 18 dp.
3. **Componentes interactivos**: botones, inputs y listas deben emplear al menos el token `m` para cumplir con las guías táctiles.
4. **Superficies circulares**: para avatares o indicadores redondos, aplica `PragmaBorderRadiusTokens.full` o `ClipOval` dependiendo del layout.

## Checklist

- [ ] El valor elegido pertenece a la tabla de tokens.
- [ ] No hay mezclas de radios personalizados dentro del mismo componente.
- [ ] Se respeta la progresión 4 → 8 → 16 → 24 dp en superficies adyacentes.
- [ ] Los avatares o badges circulares usan `border-radius-full`.
