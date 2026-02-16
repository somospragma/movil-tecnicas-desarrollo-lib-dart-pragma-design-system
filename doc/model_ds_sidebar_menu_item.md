# ModelDsSidebarMenuItem (versión refinada)

---

# ModelDsSidebarMenuItem

`ModelDsSidebarMenuItem` es el modelo de dominio que representa una entrada de navegación consumida por `DsSidebarMenuWidget`.

Define el contrato mínimo necesario para renderizar navegación lateral sin acoplar lógica de negocio al widget visual.

---

## Objetivo

- Definir un contrato **inmutable, tipado y serializable**.
- Separar reglas de negocio (qué items mostrar, habilitar o activar) del componente visual.
- Permitir interoperabilidad mediante JSON roundtrip.
- Garantizar igualdad estructural para comparaciones y tests.

---

## Naturaleza del modelo

- Es un **modelo puro de dominio**.
- No contiene lógica de navegación.
- No conoce rutas ni contexto UI.
- No depende de Flutter.

Esto permite:

- Test unitarios sin dependencia de UI.
- Persistencia o sincronización remota.
- Versionamiento estable del contrato.

---

## Estructura

- `id` (`String`)
  Identificador estable y único dentro del sidebar.

- `label` (`String`)
  Texto visible en modo expandido y usado como tooltip en modo colapsado.

- `iconToken` (`DsSidebarIconToken`)
  Token tipado que representa el ícono permitido por el Design System.

- `enabled` (`bool`)
  Define si el item es interactivo.

- `semanticLabel` (`String?`)
  Etiqueta opcional para accesibilidad. Si es `null`, puede derivarse de `label`.

---

## Icon tokens permitidos

Enum `DsSidebarIconToken` actualmente soporta:

- `dashboard`
- `projects`
- `reports`
- `settings`
- `back`
- `home`
- `analytics`
- `lock`

El conjunto de tokens es cerrado y controlado por el Design System.

---

## Comportamiento contractual

1. El modelo es completamente inmutable.
2. Implementa `toJson()` y `fromJson()`.
3. Implementa `copyWith()` para derivar variantes.
4. Si `fromJson(null)` es invocado, retorna `ModelDsSidebarMenuItem.empty`.
5. Si `iconToken` no coincide con un valor conocido, usa fallback `home`.
6. Dos instancias con mismas propiedades deben ser consideradas iguales (`==` y `hashCode` coherentes).

---

## Consideraciones importantes

### Identidad

- `id` debe ser estable.
- No debe derivarse de texto visible.
- No debe cambiar entre versiones si representa la misma funcionalidad.

### Validación

El modelo no valida permisos ni reglas de acceso.
Es responsabilidad de la capa de dominio o estado:

- Filtrar items.
- Marcar `enabled`.
- Determinar `activeId`.

---

## No hace

- No define rutas.
- No conoce navegación.
- No maneja jerarquías.
- No contiene estado UI.
- No resuelve iconos (eso es responsabilidad del widget).

---

## Ejemplo

```dart
final ModelDsSidebarMenuItem item = ModelDsSidebarMenuItem(
  id: 'reports',
  label: 'Reportes',
  iconToken: DsSidebarIconToken.reports,
  enabled: true,
  semanticLabel: 'Ir a reportes',
);

final Map<String, dynamic> json = item.toJson();
final ModelDsSidebarMenuItem restored = ModelDsSidebarMenuItem.fromJson(json);

assert(item == restored);
```

---

## Uso recomendado en apps

1. Mantener la lista de items en la capa de estado o dominio.
2. Resolver reglas de negocio (roles, ACL, feature flags) antes de renderizar.
3. Pasar al widget únicamente:
   - Lista final filtrada.
   - `activeId`.
   - `collapsed`.

4. Evitar lógica condicional dentro del widget.

---

# Evaluación honesta

Esto ya está en nivel:

✔ Dominio bien definido
✔ Compatible con Clean Architecture
✔ Compatible con JSON schema
✔ Test-friendly
✔ Evolutivo
