# Contrato de API — Servicios adicionales (ofertas complementarias)

Contrato de referencia para la pantalla de **ofertas complementarias** durante la apertura de cuenta de ahorros ([US-002](../../user-stories/US-002-ofertas-complementarias-apertura-cuenta/README.md)). El path final se resuelve en la capa `src/lib/api/` según [ADR-008](../../../adr/ADR-008-rest-service-layer.md).

> **Fase actual:** se consume un **mock** ([servicios-additionals.mock.json](./servicios-additionals.mock.json)). El backend real de `/services/additionals` aún no está disponible.

## Consultar servicios adicionales

- **Operación:** `GET /services/additionals`
- **Uso:** lista los productos/servicios complementarios configurables del banco para renderizar las casillas de selección de la pantalla.

**Response** — array `data.additionals[]`:

| Campo         | Tipo     | Ejemplo                                  | Descripción                                                                 |
| ------------- | -------- | ---------------------------------------- | --------------------------------------------------------------------------- |
| `id`          | `string` | `AVISOS24_PREMIUM`                       | Identificador único del servicio adicional.                                 |
| `name`        | `string` | `Activa Avisos24 Premium`                | Nombre visible del producto en la tarjeta de selección.                     |
| `description` | `string` | `Mantente informado de todos…`           | Descripción del beneficio mostrado bajo el nombre.                          |
| `icon`        | `string` | `bell`                                   | Identificador del icono asociado (mapea a un Heroicon, [ADR-010](../../../adr/ADR-010-heroicons-icon-library.md)). |
| `cost`        | `number` | `1.75`                                   | Costo mensual del servicio. `0` indica «sin costos adicionales».            |

## Persistencia de la selección

La selección del cliente **no** se envía desde este microfrontend. Las casillas marcadas se mantienen en el store **Redux** ([ADR-003](../../../adr/ADR-003-redux-state-management.md)) y la aplicación anfitriona (host) las envía al backend al confirmar la apertura de la cuenta, de forma análoga a la cotización del seguro en [US-29912](../../user-stories/US-29912-microfrontend/README.md).
