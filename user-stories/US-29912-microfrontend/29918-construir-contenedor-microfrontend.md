# 29918: Construir contenedor de microfrontend

- Estado: Ready
- Historia: [US-29912: Microfrontend de seguro embebido con experimentación A/B](./README.md)
- Unidad de trabajo: `challenge-ab-testing-host`
- Asignado a: Juan Carlos Altamirano
- ADO Work Item: [#29918](https://dev.azure.com/BayteqDev/Reto%20BBolivariano/_workitems/edit/29918)

## Descripción

Construir el contenedor (host) que embebe el microfrontend de seguro dentro del onboarding de la aplicación anfitriona, y preparar el artefacto estático para su despliegue en S3 + CloudFront. Al término de esta tarea:

- Existe una configuración de host que integra el microfrontend del seguro embebido sin tomar control del encabezado ni del marco general de la aplicación anfitriona.
- El artefacto estático generado por `next build` (`output: 'export'`) es desplegable en un bucket S3 servido vía CloudFront.
- La integración del store Redux del microfrontend con el host permite que la aplicación anfitriona conozca la decisión del cliente (aceptó o rechazó el seguro).
- Existe documentación de la configuración de despliegue y del contrato de integración host ↔ microfrontend.

## Dependencias

- **TK-29917** — El módulo `src/features/seguro-embebido/` y su store Redux deben estar disponibles para integrarse en el contenedor.
- **Next.js `output: 'export'`** — Configuración de build estático activa en `next.config.js` (ADR-001).
- **Redux Provider** — `Provider` en `_app.tsx` que engloba el árbol de componentes incluyendo el MFE (ADR-003).
- **Tailwind v4** — Estilos del contenedor alineados con el sistema de diseño del host (ADR-002).
- **S3 + CloudFront** — Infraestructura provista por la tarea ADO #29913 (Pipeline de despliegue) y #29914 (Scripts de infraestructura), ambas asignadas a Eduardo Portilla.
- **Pipeline CI/CD** — Dependencia con ADO #29913 para el pipeline de despliegue automático del artefacto `out/`.

## Referencias

- **Arquitectura — SPA estática y `output: 'export'`:** [ADR-001](../../../../docs/adr/ADR-001-pages-router-only.md)
- **Arquitectura — Styling:** [ADR-002](../../../../docs/adr/ADR-002-tailwind-ui-styling.md)
- **Arquitectura — Estado Redux:** [ADR-003](../../../../docs/adr/ADR-003-redux-state-management.md)
- **Arquitectura — Feature-based:** [ADR-004](../../../../docs/adr/ADR-004-feature-based-architecture.md)
- **Arquitectura — Testing:** [ADR-005](../../../../docs/adr/ADR-005-unit-testing-strategy.md)
- **Diseño — Delimitación MFE móvil:** ![Delimitación MFE móvil](../../../assets/requerimiento/image6.png)
- **Diseño — Delimitación MFE desktop:** ![Delimitación MFE desktop](../../../assets/requerimiento/image7.png)
- **Requerimiento funcional — RNF-06 (S3 + CloudFront):** [requerimiento-ab-testing-seguro-embebido-bb.md](../../requerimiento-ab-testing-seguro-embebido-bb.md)
- **Documentación técnica — Contratos de API:** [technical-docs/api-contracts/README.md](../../technical-docs/api-contracts/README.md)

## Observaciones

- Esta tarea depende de TK-29917 en el repositorio `challenge-ab-testing`: el módulo `seguro-embebido` debe estar implementado antes de integrarlo en el contenedor. Se puede avanzar en paralelo con la definición del contrato host ↔ MFE (paso 1).
- La infraestructura S3 + CloudFront es responsabilidad de las tareas ADO #29913 y #29914 (Eduardo Portilla). Coordinar para obtener el ARN del bucket y la distribución CloudFront antes de ejecutar el primer despliegue real.
- El pipeline de despliegue (ADO #29913) debe referenciar el directorio `out/` como artefacto de publicación.
- Si el API Gateway del backend (ADO #29919, Héctor Andrade) no está disponible al momento del despliegue, el contenedor debe poder operar con los mocks de API definidos en `docs/specs/technical-docs/api-contracts/`.
