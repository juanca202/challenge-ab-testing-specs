# US-002: Ofertas complementarias durante la apertura de cuenta de ahorros

- Estado: Ready
- Fecha de creación: 2026-06-22
- Última actualización: 2026-06-22
- ADO Work Item: por asignar (placeholder; alinear secuencial al código ADO cuando exista)

## Descripción

**COMO** cliente de Banco Bolivariano que está abriendo una cuenta de ahorros online
**QUIERO** ver una pantalla de productos y servicios complementarios antes de la confirmación final
**PARA** poder contratar de forma opcional servicios adicionales sin interrumpir la apertura de mi cuenta

## Referencias

- **Requerimiento funcional (RQ-002):** [Ofertas complementarias durante la creación de cuenta de ahorros](../../requirements/RQ-002/servicios-opcionales.md)
- **Diseño de referencia (pantalla móvil):** ![Pantalla de ofertas complementarias](assets/servicios-cuenta.png)
- **Diseño desktop:** Sin diseño propio — reutiliza el mismo patrón responsivo de la pantalla de seguro embebido ([US-29912](../US-29912-microfrontend/README.md))
- **Contrato de API del catálogo:** [technical-docs/api-contracts/servicios-additionals.md](../../technical-docs/api-contracts/servicios-additionals.md) — `GET /services/additionals` (mock en esta fase)

## Criterios de aceptación

### Reglas de negocio

- **BR-01** — El sistema DEBE mostrar la pantalla de ofertas complementarias después de que el cliente complete el formulario de apertura y antes de la confirmación final de la cuenta.
- **BR-02** — La contratación de productos complementarios DEBE ser opcional: la ausencia de selección NO DEBE impedir ni bloquear la apertura de la cuenta.
- **BR-03** — La pantalla DEBE permitir seleccionar uno o varios productos mediante casillas de verificación.
- **BR-04** — Los productos mostrados DEBEN obtenerse de un catálogo del banco vía API REST externa consumida desde el Service Layer; el microfrontend NO DEBE mantener la lista de productos embebida en el código.
- **BR-05** — Cada producto DEBE mostrar sus costos y condiciones vigentes al momento de la consulta.
- **BR-06** — Las selecciones del cliente DEBEN persistir en el store Redux durante la sesión, de modo que la aplicación anfitriona (host) las envíe al backend y queden asociadas a la nueva cuenta al confirmar la apertura.
- **BR-07** — La pantalla DEBE presentarse de forma responsiva en vista móvil y desktop, reutilizando el mismo patrón de layout de la pantalla de seguro embebido; NO DEBE requerir un diseño desktop propio.

### Escenarios

```gherkin
Escenario: SC-01 - Visualización de la pantalla de ofertas complementarias
DADO que el cliente ha completado exitosamente el formulario de apertura de cuenta
CUANDO avanza al siguiente paso del proceso
ENTONCES el sistema muestra la pantalla de ofertas complementarias con los productos del catálogo
Y cada producto muestra su costo y condiciones vigentes

Escenario: SC-02 - Continuar sin seleccionar ningún producto
DADO que el cliente visualiza la pantalla de ofertas complementarias
CUANDO no selecciona ningún producto y presiona «Continuar»
ENTONCES el sistema avanza al siguiente paso sin bloquear la apertura de la cuenta

Escenario: SC-03 - Selección múltiple de productos
DADO que el cliente visualiza la pantalla de ofertas complementarias
CUANDO marca las casillas de uno o más productos
ENTONCES el sistema registra todas las selecciones para procesarlas durante la apertura

Escenario: SC-04 - Continuación del flujo tras seleccionar productos
DADO que el cliente ha marcado al menos un producto complementario
CUANDO presiona el botón «Continuar»
ENTONCES el sistema avanza al siguiente paso del proceso de apertura conservando las selecciones realizadas

Escenario: SC-05 - Asociación de las contrataciones a la nueva cuenta
DADO que el cliente seleccionó uno o más productos complementarios
Y las selecciones están persistidas en el store Redux
CUANDO el host confirma y finaliza exitosamente la apertura de la cuenta
ENTONCES el host envía las contrataciones seleccionadas al backend
Y estas quedan asociadas a la nueva cuenta según las reglas de negocio definidas

Escenario: SC-06 - Presentación responsiva en móvil y desktop
DADO que el cliente accede a la pantalla de ofertas complementarias
CUANDO la visualiza en un dispositivo móvil o en desktop
ENTONCES la pantalla adapta su disposición al tamaño de pantalla siguiendo el mismo patrón de layout de la pantalla de seguro embebido
Y mantiene la selección de productos y el botón «Continuar»
```

## Complejidad sugerida

- **Story points:** 3
- **Justificación:** Pantalla acotada de selección múltiple con casillas, consumo de un catálogo de productos configurable y registro de las selecciones para su posterior asociación a la cuenta. El alcance de UI es contenido y los estados son simples; la incertidumbre principal proviene del contrato del catálogo y del mecanismo de asociación, aún por definir.

## Unidades de trabajo

- `challenge-ab-testing` — microfrontend Next.js estático (Pages Router, Redux, Tailwind v4, Base UI) donde se implementa la pantalla de ofertas complementarias.

## Validación

### INVEST

| Letra | Criterio      | Resultado | Notas                                                                                                                                                  |
| ----- | ------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **I** | Independiente | Parcial   | La pantalla depende del flujo de apertura del host (paso previo y confirmación); puede avanzar de forma autónoma con el mock del catálogo.              |
| **N** | Negociable    | Cumple    | Los productos provienen de un catálogo externo y el copy/CTA admiten ajuste con el PO sin cambio de alcance.                                            |
| **V** | Valiosa       | Cumple    | Habilita cross-sell de productos complementarios durante el onboarding sin añadir fricción a la apertura de la cuenta.                                   |
| **E** | Estimable     | Cumple    | Comportamiento funcional (SC-01 a SC-06), arquitectura (API REST en Service Layer, persistencia Redux→host) y contrato del catálogo (`/services/additionals`) definidos. |
| **S** | Pequeña       | Cumple    | 3 puntos: una pantalla con selección múltiple y persistencia de selección.                                                                              |
| **T** | Testeable     | Cumple    | Todos los criterios tienen escenarios Gherkin verificables (SC-01 a SC-06) y reglas con condiciones observables.                                        |

### Definition of Ready (DoR)

| Criterio DoR                       | Estado    | Notas                                                                                                                                          |
| ---------------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Dependencias listas                | Cumple    | Diseño móvil (`servicios-cuenta.png`) y contrato del catálogo (mock) disponibles; el desktop reutiliza el patrón de la pantalla de seguro.       |
| Inputs/outputs claros              | Cumple    | Entrada: `GET /services/additionals` (`id, name, description, icon, cost`). Salida: selecciones en Redux que el host envía al confirmar.         |
| Unidades de trabajo definidas      | Cumple    | Microfrontend `challenge-ab-testing`.                                                                                                          |
| Sin decisiones técnicas pendientes | Cumple    | Catálogo vía API REST en el Service Layer (ADR-008) con contrato `/services/additionals` definido; persistencia Redux→host (ADR-003).           |
| Referencias de UI                  | Cumple    | Diseño móvil `assets/servicios-cuenta.png`; el layout desktop reutiliza el patrón responsivo de la pantalla de seguro embebido (US-29912).      |
| Sin aclaraciones pendientes        | Cumple    | Ninguna aclaración funcional abierta; el contrato real de `/services/additionals` queda como dependencia de backend que no bloquea el desarrollo. |

## Observaciones

- **Contrato del catálogo:** el catálogo se consume vía `GET /services/additionals` (`id, name, description, icon, cost`) desde el Service Layer (ADR-008). En esta fase se usa un **mock** ([technical-docs/api-contracts/servicios-additionals.md](../../technical-docs/api-contracts/servicios-additionals.md)); el backend real es una dependencia que no bloquea el desarrollo. Se añadió el campo `cost` para satisfacer BR-05 (el contrato inicial solo traía `id, name, description, icon`).
- **Diseño desktop:** no habrá diseño desktop propio; la vista desktop reutiliza el mismo patrón responsivo de la pantalla de seguro embebido ([US-29912](../US-29912-microfrontend/README.md)) (BR-07, SC-06).
- **Asociación a la cuenta (CA-05):** las selecciones se persisten en el store Redux y el host las envía al backend al confirmar la apertura, de forma análoga a la cotización del seguro en [US-29912](../US-29912-microfrontend/README.md).
- **Integración con el host:** la pantalla se inserta entre el formulario de apertura y la confirmación final; la coordinación del punto de integración exacto se gestiona en `work-plan` junto al equipo del `challenge-ab-testing-host` (dependencia de integración, no aclaración funcional pendiente).
