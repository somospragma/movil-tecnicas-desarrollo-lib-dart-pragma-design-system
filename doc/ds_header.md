# DsHeaderWidget

`DsHeaderWidget` define la franja superior de contexto para páginas internas del sistema. Presenta un título principal a la izquierda y un área de acciones composables a la derecha, manteniendo coherencia visual y responsividad.

---

## Objetivo

- Estandarizar encabezados de pantallas tipo workspace.
- Permitir acciones heterogéneas (botones, avatar, chips, toggles, superficies informativas).
- Mantener una composición estable en desktop y compacta en anchos reducidos.
- Evitar que cada equipo implemente su propio header ad-hoc.

---

## Naturaleza del widget

`DsHeaderWidget` es un widget declarativo y sin estado interno.

- No administra lógica de negocio.
- No gestiona navegación.
- No controla el estado del sidebar.
- Toda su variación visual depende de sus props y del layout disponible.

---

## Anatomía

1. **Título principal** (lado izquierdo).
2. **Área de acciones** (lado derecho, disposición horizontal).
3. **Superficies auxiliares opcionales** mediante `DsHeaderActionSurface`.

---

## Props principales

- `title` (`String`)
  Texto principal del encabezado.

- `actions` (`List<Widget>`)
  Conjunto de widgets que se renderizan en el lado derecho.

- `compactBreakpoint` (`double`, default recomendado: `960`)
  Ancho en logical pixels a partir del cual el header cambia a modo compacto.

- `padding` (`EdgeInsetsGeometry`)
  Espaciado interno del header.

---

## Composición de acciones

Se recomienda la siguiente jerarquía visual:

- **Acciones primarias:** `IconButton` o `TextButton.icon`.
- **Identidad / usuario:** `PragmaAvatarWidget`.
- **Bloques informativos o contextuales:** `DsHeaderActionSurface`.
- **Acciones destructivas:** deben explicitar semántica y tooltip.

Evitar:

- Acciones puramente icónicas sin `tooltip`.
- Lógica de negocio directamente dentro de callbacks complejos.

---

## Responsividad

### En ancho amplio

- Distribución horizontal estable.
- Título alineado a la izquierda.
- Acciones visibles en línea.
- Sin wrapping salvo overflow explícito.

### En ancho compacto

- Se prioriza la legibilidad del título.
- El título puede aplicar `ellipsis` si es necesario.
- Las acciones pueden usar `Wrap` o ajuste dinámico para evitar overflow.
- El padding puede reducirse según constraints.

---

## Accesibilidad

- Utiliza controles nativos (`IconButton`, `TextButton`) para soporte de foco y teclado.
- Define `tooltip` o labels descriptivos en iconografía.
- Evita acciones sin nombre semántico.
- Mantén contraste adecuado según el tema activo.

---

## Integración arquitectónica

- Debe utilizarse exclusivamente en la capa **UI**.
- No debe recibir entidades de dominio directamente.
- Transformaciones o mapeos deben realizarse en Presenter / ViewModel.
- No debe contener lógica condicional basada en roles o ACL.

---

## No hace

- No implementa navegación.
- No gestiona scroll.
- No aplica elevación dinámica.
- No controla el estado del sidebar.
- No administra permisos.

---

## Ejemplo

```dart
DsHeaderWidget(
  title: 'Área de trabajo',
  actions: <Widget>[
    DsHeaderActionSurface(
      child: const Text('Ambiente: demo'),
    ),
    IconButton(
      tooltip: 'Buscar',
      onPressed: () {},
      icon: const Icon(Icons.search),
    ),
    TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.keyboard_double_arrow_left),
      label: const Text('Contraer'),
    ),
    const PragmaAvatarWidget(
      radius: PragmaSpacing.sm,
      initials: 'PD',
    ),
  ],
)
```
