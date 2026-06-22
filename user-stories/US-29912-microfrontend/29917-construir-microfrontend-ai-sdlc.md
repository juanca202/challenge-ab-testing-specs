# 29917: Construir el microfrontend con AI SDLC

- Estado: Ready
- Historia: [US-29912: Microfrontend de seguro embebido con experimentación A/B](./README.md)
- Unidad de trabajo: `challenge-ab-testing`
- Asignado a: Juan Carlos Altamirano
- ADO Work Item: [#29917](https://dev.azure.com/BayteqDev/Reto%20BBolivariano/_workitems/edit/29917)

## Descripción

Implementar el microfrontend de la pantalla de oferta del seguro embebido siguiendo la metodología SDD (Specification-Driven Development) asistida con IA. Al término de esta tarea el microfrontend debe:

- Renderizar las variantes A (control) y B (challenger) para móvil y desktop según los diseños de referencia.
- Gestionar los dos estados de pantalla (inicial y «solicitado») con los CTAs correctos por dispositivo.
- Consumir el contrato de API de producto (seguro) y persistir la cotización y variante asignada en el store Redux.
- Integrar la lógica de asignación de variante por feature flags.
- Cumplir con los criterios de calidad del SDLC: análisis estático SonarQube, análisis de seguridad y cobertura de pruebas unitarias ≥ 80% de ramas (ADR-005).
- Incluir documentación de la fase de desarrollo integrando SDD + IA (RNF-07).

## Dependencias

- **Feature de dominio** — módulo bajo `src/features/` (a crear) para la pantalla de seguro embebido con sus variantes A/B y estados.
- **Redux Toolkit** — slices para: variante asignada y estado de solicitud (contratado / no contratado); `Provider` ya configurado en `_app.tsx` (ADR-003).
- **Service Layer** (`src/lib/api/`) — cliente HTTP para el endpoint de consulta de producto; mock JSON disponible en `docs/specs/technical-docs/api-contracts/consultar-producto.mock.json`.
- **Feature flag client** — integración con el Feature flag manager API para leer la variante asignada al usuario (RF-02, RF-10).
- **Tailwind v4 + Base UI** — sistema de diseño para composición de componentes responsivos (ADR-002, ADR-006).
- **Vitest** — suite de pruebas unitarias co-located con los componentes (ADR-005).
- **Next.js Pages Router** con `output: 'export'` — página de entrada del microfrontend bajo `src/pages/` (ADR-001).

## Referencias

- **Arquitectura — SPA estática:** [ADR-001](../../../../docs/adr/ADR-001-pages-router-only.md)
- **Arquitectura — Styling:** [ADR-002](../../../../docs/adr/ADR-002-tailwind-ui-styling.md)
- **Arquitectura — Estado Redux:** [ADR-003](../../../../docs/adr/ADR-003-redux-state-management.md)
- **Arquitectura — Feature-based:** [ADR-004](../../../../docs/adr/ADR-004-feature-based-architecture.md)
- **Arquitectura — Testing:** [ADR-005](../../../../docs/adr/ADR-005-unit-testing-strategy.md)
- **Arquitectura — Base UI:** [ADR-006](../../../../docs/adr/ADR-006-base-ui-component-library.md)
- **Arquitectura — TSDoc:** [ADR-007](../../../../docs/adr/ADR-007-tsdoc-api-documentation.md)
- **Arquitectura — Service Layer:** [ADR-008](../../../../docs/adr/ADR-008-rest-service-layer.md)
- **Documentación técnica — Contratos de API:** [technical-docs/api-contracts/README.md](../../technical-docs/api-contracts/README.md)
- **Mock consultar producto:** [consultar-producto.mock.json](../../technical-docs/api-contracts/consultar-producto.mock.json)
- **Mock cotización:** [cotizacion.mock.json](../../technical-docs/api-contracts/cotizacion.mock.json)
- **Diseño — Variante A móvil inicial:** ![Variante A móvil inicial](../../../assets/requerimiento/image1.png)
- **Diseño — Variante A móvil solicitado:** ![Variante A móvil solicitado](../../../assets/requerimiento/image2.png)
- **Diseño — Variante A desktop inicial:** ![Variante A desktop inicial](../../../assets/requerimiento/image3.png)
- **Diseño — Variante A desktop solicitado:** ![Variante A desktop solicitado](../../../assets/requerimiento/image4.png)
- **Diseño — Variante B móvil:** ![Variante B móvil](../../../assets/requerimiento/image5.png)
- **Diseño — Delimitación MFE móvil:** ![Delimitación MFE móvil](../../../assets/requerimiento/image6.png)
- **Diseño — Delimitación MFE desktop:** ![Delimitación MFE desktop](../../../assets/requerimiento/image7.png)
- **Requerimiento funcional completo:** [requerimiento-ab-testing-seguro-embebido-bb.md](../../requerimiento-ab-testing-seguro-embebido-bb.md)

## Observaciones

- Confirmar con el Product Owner el umbral de cobertura de pruebas: el requerimiento original indica 100% mientras que ADR-005 establece ≥ 80% de ramas. Esta tarea asume ≥ 80%.
- La tarea TK-29918 (contenedor/host) vive en el repositorio `challenge-ab-testing-host` y es una dependencia de integración: el microfrontend puede desarrollarse y probarse de forma aislada con mocks antes de que el contenedor esté disponible.
- El cliente de Feature flags requiere coordinación con la tarea ADO #29915 (Implementar Feature Flags en AWS, asignada a Eduardo Portilla). Usar mock del feature flag client mientras la infraestructura no esté disponible.
- El Service Layer de cotización es in-memory (RF-07, sección 2.2 del requerimiento); no se persiste en base de datos en esta fase.
