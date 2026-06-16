# Contratos de API — Mocks

Mocks de referencia para desarrollo y pruebas del microfrontend de seguro embebido. Los paths finales se definirán en la capa `src/lib/api/` según [ADR-008](../../../adr/ADR-008-rest-service-layer.md).

## Archivos

| Archivo                                                        | Operación                 | Uso                                                                          |
| -------------------------------------------------------------- | ------------------------- | ---------------------------------------------------------------------------- |
| [consultar-producto.mock.json](./consultar-producto.mock.json) | POST — consultar producto | Lista el seguro, coberturas, precio y documentos para renderizar la pantalla |
| [cotizacion.mock.json](./cotizacion.mock.json)                 | POST — cotización         | Registra la intención al pulsar **Solicitar** u **Omitir**                   |

## Consultar producto

**Request** — identifica al cliente y el contexto del widget:

| Campo                | Ejemplo                 | Descripción                |
| -------------------- | ----------------------- | -------------------------- |
| `identification`     | `09XXXXXXXX`            | Identificación del cliente |
| `identificationType` | `C`                     | Tipo de identificación     |
| `channel`            | `WAP`                   | Canal de origen            |
| `birthDate`          | `2000-10-03`            | Fecha de nacimiento        |
| `systemCode`         | `BB_WIDGET_SEGUROS_CTA` | Código del widget          |
| `associatedProduct`  | `CUENTA`                | Producto bancario asociado |

**Response** — array `data.products[]` con coberturas, precio (`price.amount`, `frequencyPayment: "M"`) y documentos legales.

## Cotización

El MFE recibe del host los datos del **request** como props, más las acciones de navegación:

- `nextPage` — ruta tras completar el flujo de seguros
- `backPage` — ruta del botón «Atrás»

Campos relevantes del request:

| Campo              | Notas                                      |
| ------------------ | ------------------------------------------ |
| `generaLead`       | `true` solo si el cliente acepta el seguro |
| `aceptaSeguro`     | Indica si el usuario aceptó la oferta      |
| `productoSelected` | Producto y plan elegidos en pantalla       |
| `metaData.journey` | Ej.: `CUENTA_AHORRO_ONLINE`                |

**Response** — identificadores de sesión: `quoteId`, `sessionId`, `transactionId`.

## Persistencia

En esta fase la cotización se mantiene en **memoria del microfrontend** (Redux). No hay persistencia transaccional en base de datos (ver requerimiento, sección 2.2).
