# Documentación de producto — A/B Testing Seguro Embebido BB

Material de referencia del piloto **A/B Testing en el flujo de contratación de seguro embebido** (Banco Bolivariano). Sirve como base para historias de usuario, tareas técnicas e implementación del microfrontend.

## Índice

| Documento                                                                   | Descripción                                                                                   |
| --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| [Requerimiento funcional](./requerimiento-ab-testing-seguro-embebido-bb.md) | Especificación completa del piloto (alcance, variantes A/B, RF, RNF, criterios de aceptación) |
| [Arquitectura del microfrontend](./technical-docs/architecture.md)            | Diagramas de contexto, capas internas, flujo de datos y despliegue del remote MFE             |
| [Contratos de API (mocks)](./technical-docs/api-contracts/README.md)        | Payloads de consulta de producto y cotización                                                 |
| [Glosario](./glossary.md)                                                   | Términos del dominio                                                                          |
| [US-29912 — Casos de prueba](./user-stories/US-29912-microfrontend/test-cases/README.md) | 16 test cases extraídos de Azure DevOps (vinculados a #29912)                    |

## Origen

Los artefactos provienen del paquete de piloto _Piloto - AB_Testing_Seguro_Embebido_BB_:

- `Requerimiento_AB_Testing_Seguro_Embebido_BB.docx`
- `REQUEST_MOCK_PRODUCTO.json`
- `REQUEST_MOCK_COTIZACION.json`

## Relación con ADRs del repositorio

| Tema del requerimiento                         | ADR vigente                                                                                              |
| ---------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| SPA estática, Pages Router, `output: 'export'` | [ADR-001](../adr/ADR-001-pages-router-only.md)                                                           |
| Tailwind + Base UI                             | [ADR-002](../adr/ADR-002-tailwind-ui-styling.md), [ADR-006](../adr/ADR-006-base-ui-component-library.md) |
| Redux (variante A/B y estado de solicitud)     | [ADR-003](../adr/ADR-003-redux-state-management.md)                                                      |
| Arquitectura feature-based                     | [ADR-004](../adr/ADR-004-feature-based-architecture.md)                                                  |
| Pruebas unitarias                              | [ADR-005](../adr/ADR-005-unit-testing-strategy.md)                                                       |
| Service Layer REST                             | [ADR-008](../adr/ADR-008-rest-service-layer.md)                                                          |
