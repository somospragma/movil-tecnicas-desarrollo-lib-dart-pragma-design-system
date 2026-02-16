# DsSidebarMenuWidget

`DsSidebarMenuWidget` representa el menú lateral de navegación del sistema.
Está diseñado como un componente completamente controlado, predecible y desacoplado de estado interno.

---

## Naturaleza del componente

### Controlled Component

- Es **completamente controlado**.
- Implementado como `StatelessWidget`.
- **No muta internamente**:
  - `collapsed`
  - `activeId`

- Renderiza exclusivamente según props.
- Emite eventos vía callbacks.

Este diseño garantiza:

- Previsibilidad.
- Testeo simple.
- Integración limpia con ViewModel / Bloc / Notifier externo.

---

## Estado de colapsado

El estado siempre es externo.

### Escenario 1 — Toggle interno

Si:

```dart
showCollapseToggle = true
```

Se renderiza un botón interno en el header que ejecuta:

```dart
onCollapsedToggle(!collapsed)
```

El widget **no cambia estado por sí mismo**.

---

### Escenario 2 — Control externo

Si:

```dart
showCollapseToggle = false
```

El layout padre puede manejar el colapsado desde:

- Header global
- Botón externo
- Shortcut de teclado
- Layout responsivo

El componente solo refleja el valor recibido en `collapsed`.

---

## Scroll behavior

La lista de items usa:

```dart
ListView.separated
```

### Layout con alto acotado (`constraints.hasBoundedHeight == true`)

Estructura:

```
Column
 ├─ Header
 ├─ Expanded(ListView)
 └─ Footer (opcional)
```

- El header queda fijo arriba.
- El footer queda fijo abajo.
- Solo la lista scrollea.

---

### Layout no acotado

- `ListView` pasa a `shrinkWrap: true`
- `physics: NeverScrollableScrollPhysics`
- El scroll lo gestiona el contenedor padre.

Esto evita conflictos de scroll anidado.

---

## Modelo de navegación

Actualmente soporta:

```dart
List<ModelDsSidebarMenuItem>
```

Referencia detallada del modelo:
- [model_ds_sidebar_menu_item.md](model_ds_sidebar_menu_item.md)

### Tipo de navegación

- ✔ Lista plana
- ❌ No soporta:
  - Secciones
  - Agrupaciones
  - Submenús
  - Árbol jerárquico
  - Expansión por niveles

Debe considerarse explícitamente como:

> **Flat navigation only**

Si en el futuro se requiere jerarquía, deberá diseñarse otro componente o extender el modelo.

---

## Resolución de ancho

Props disponibles:

- `width` (default: `224`)
- `collapsedWidth` (default: `72`)

Ambos son configurables.

El header interno también adapta su layout para evitar overflow cuando el ancho es reducido.

---

## Iconografía

- `iconToken` es de tipo `DsSidebarIconToken` (enum).
- Se resuelve internamente mediante `_SidebarIconResolver`.
- Actualmente usa iconografía Material (`Icons.*`).
- No soporta SVG nativamente.

Si se migra a SVG o Design Tokens de íconos, deberá reemplazarse el resolver.

---

## Comportamiento cuando `activeId` no existe

Si el `activeId` recibido:

- No coincide con ningún item

El comportamiento es:

- No se marca ningún item como activo.
- No se lanza assert.
- No hay fallback automático al primer item.

Esto forma parte del contrato actual del componente.

---

## No hace

- No maneja rutas.
- No ejecuta navegación.
- No controla permisos.
- No sincroniza estado con URL.
- No persiste colapsado.
- No soporta jerarquía.

---

# Evaluación rápida

Esto ya está a nivel:

✔ Componente enterprise
✔ Predecible
✔ Testeable
✔ Clean Architecture friendly
✔ Compatible con tu filosofía de controlled widgets
