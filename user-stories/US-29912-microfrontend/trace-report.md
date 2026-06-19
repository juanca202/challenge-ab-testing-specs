# Reporte de trazabilidad — US-29912 Microfrontend de seguro embebido con experimentación A/B

| | |
|--|--|
| **Historia** | [US-29912](./README.md) |
| **Rama** | `develop` (MFE y host al 2026-06-19) |
| **Fecha** | 2026-06-19 |
| **Veredicto** | **APROBADO CON OBSERVACIONES** |
| **Cobertura** | 11 de 12 criterios cubiertos (92 %) — 1 parcial |

## Resumen

La US-29912 mantiene trazabilidad sólida entre criterios `BR-XX`/`SC-XX`, casos ADO (`TC-29935`–`TC-29953`) y artefactos automatizados en `challenge-ab-testing` (MFE), `challenge-ab-testing-host` (contenedor) y la suite E2E Playwright `e2e/us-29912.spec.ts`. Se ejecutaron 151 tests unitarios/integración del MFE, 108 del host (100 % paso en ambos), cobertura al 100 % de ramas en MFE y host, y 29 tests E2E de US-29912 (100 % paso; 3 omitidos por viewport). **BR-07** queda parcial: scripts de despliegue S3/CloudFront documentados y cobertura verificada, pero SonarQube/análisis de seguridad no son ejecutables desde el repo en esta validación.

## Matriz de trazabilidad

| Criterio | Descripción | Caso(s) de prueba | Artefacto(s) (tipo) | Estado | Ejec. auto | Resultado | Observaciones |
|----------|-------------|-------------------|---------------------|--------|------------|-----------|---------------|
| BR-01 | Renderizar variantes A/B móvil/desktop sin controlar encabezado ni marco del host | TC-29944, TC-29935, TC-29936, TC-29937 | `challenge-ab-testing-host/e2e/us-29912.spec.ts` (e2e); `VariantA.test.tsx`, `VariantB.test.tsx` (unit); `RemoteSeguroEmbebido.test.tsx`, `MfeContentSlot.test.tsx` (unit host) | Cubierto | Sí | Paso | E2E valida marco del host intacto (`expectHostFrameIntact`) |
| BR-02 | Asignar exactamente una variante vía feature flags, persistente en sesión | TC-29938, TC-29949, TC-29950, TC-29953 | `e2e/us-29912.spec.ts` (e2e); `useVariantAssignment.test.tsx`, `variantSlice.test.ts`, `mockClient.test.ts`, `readVariantCookie.test.ts` (unit); `SeguroEmbebidoScreen.persistence.test.tsx` (integración) | Cubierto | Sí | Paso | Incluye fallback a A con cookie inválida (TC-29950) |
| BR-03 | CTAs correctos por dispositivo y estado (inicial / solicitado) | TC-29935, TC-29936, TC-29937, TC-29939, TC-29951 | `SeguroCtaBar.test.tsx` (unit); `e2e/us-29912.spec.ts` (e2e) | Cubierto | Sí | Paso | Unit cubre todas las combinaciones móvil/desktop × estado |
| BR-04 | Modificar porcentaje A/B desde administrador de flags sin redespliegue | TC-29945 | `e2e/us-29912.spec.ts` (e2e); `mockClient.test.ts`, `readVariantCookie.test.ts` (unit) | Cubierto | Sí | Paso | En local el split se simula en harness; en staging requiere `E2E_FLAGS_API_KEY` y gateway real |
| BR-05 | Consumir API de producto; cotización persistente en Redux para el host | TC-29941, TC-29942 | `e2e/us-29912.spec.ts` (e2e); `consultarProducto.test.ts`, `useSeguroProduct.test.tsx`, `insuranceSlice.test.ts`, `insurance.test.ts` (selectors, unit); `useInsuranceDecision.test.tsx` (unit host) | Cubierto | Sí | Paso | E2E intercepta API vía `e2e/support/seguroApi.ts` |
| BR-06 | «Solicitar» → estado solicitado; «Anular solicitud» → estado inicial | TC-29939, TC-29940 | `SeguroEmbebidoScreen.decision.test.tsx` (integración); `useInsuranceActions.test.tsx`, `RequestedBanner.test.tsx` (unit); `e2e/us-29912.spec.ts` (e2e) | Cubierto | Sí | Paso | — |
| BR-07 | Despliegue estático S3/CloudFront; SonarQube, seguridad y cobertura ≥ 80 % | — | `deploy.sh`, `deploy.ps1`, `Deploy.md` (manual); `npm run test:coverage` (unit MFE y host) | Parcial | Parcial | Paso (cobertura) | Cobertura MFE y host: 100 % ramas (≥ 80 % ADR-005). Scripts S3/CloudFront documentados. SonarQube/seguridad: verificación manual pre-PR, no automatizable en este repo |
| SC-01 | Variante A control en estado inicial (móvil y desktop) | TC-29935, TC-29936 | `VariantA.test.tsx` (unit); `e2e/us-29912.spec.ts` TC-29935/TC-29936 (e2e) | Cubierto | Sí | Paso | TC-29935 solo en proyecto mobile; TC-29936 solo desktop (skip intencional) |
| SC-02 | Variante B challenger en estado inicial | TC-29937 | `VariantB.test.tsx` (unit); `e2e/us-29912.spec.ts` TC-29937 (e2e) | Cubierto | Sí | Paso | — |
| SC-03 | Persistencia de variante al salir y regresar | TC-29938, TC-29949, TC-29953 | `SeguroEmbebidoScreen.persistence.test.tsx` (integración); `e2e/us-29912.spec.ts` (e2e) | Cubierto | Sí | Paso | Cubre navegación, recarga y otra pestaña |
| SC-04 | Transición solicitado y reversión con Anular | TC-29939, TC-29940 | `SeguroEmbebidoScreen.decision.test.tsx` (integración); `e2e/us-29912.spec.ts` (e2e) | Cubierto | Sí | Paso | — |
| SC-05 | Cambio de porcentaje A/B sin redespliegue | TC-29945 | `e2e/us-29912.spec.ts` TC-29945 (e2e); `ab-variant.spec.ts` (e2e complementario) | Cubierto | Sí | Paso | Validación estadística del split en harness local; staging usa PATCH vía `global-setup` |

## Artefactos de prueba automatizada disponibles

| Tipo | Presente | Artefactos |
|------|----------|------------|
| Unit | Sí | **MFE** (`challenge-ab-testing`): 33 archivos en `src/features/seguro-embebido/`, `src/lib/api/`, `src/lib/rum/` — p. ej. `VariantA.test.tsx`, `SeguroCtaBar.test.tsx`, `useVariantAssignment.test.tsx`, `consultarProducto.test.ts`. **Host**: 33 archivos — p. ej. `RemoteSeguroEmbebido.test.tsx`, `useInsuranceDecision.test.tsx`, `OnboardingLayout.test.tsx`, `HostHeader.test.tsx` |
| Integración | Sí | **MFE**: `SeguroEmbebidoScreen.integration.test.tsx`, `SeguroEmbebidoScreen.persistence.test.tsx`, `SeguroEmbebidoScreen.decision.test.tsx`. **Host**: `demo-flow.integration.test.tsx` |
| E2E | Sí | **Host**: `e2e/us-29912.spec.ts` (16 casos TC mapeados), `e2e/ab-variant.spec.ts`, `e2e/smoke.spec.ts` |

## Ejecución automática

| | |
|--|--|
| **Runner detectado** | Vitest (unit/integración MFE y host); Playwright (E2E host) |
| **Comando ejecutado** | `cd challenge-ab-testing && npm run test:run` · `npm run test:coverage` · `cd challenge-ab-testing-host && npm run test:run` · `npm run test:coverage` · `npm run test:e2e -- e2e/us-29912.spec.ts` |
| **Resultado global** | MFE: 151/151 pasaron. Cobertura MFE: 100 % statements, 100 % branches. Host unit: 108/108 pasaron. Cobertura host: 100 % statements, 100 % branches. E2E US-29912: 29 pasaron, 3 omitidos (viewport), 0 fallos |

## Observaciones y pendientes

- **BR-07:** Confirmar ejecución de SonarQube y análisis de seguridad en pipeline ADO o sesión manual pre-merge; no hay artefacto automatizado en el repo que lo valide.
- **BR-07:** El despliegue S3/CloudFront está documentado (`Deploy.md`, `deploy.sh`/`deploy.ps1`) pero no se ejecutó un deploy real en esta validación.
- **SC-05 / BR-04:** En entorno local el cambio de split se simula; validación contra administrador real de feature flags requiere staging con `E2E_FLAGS_API_KEY`.
- **Casos adicionales ADO** (TC-29947 Omitir, TC-29948 Continuar, TC-29942 error API, TC-29950 fallback) tienen cobertura E2E en `us-29912.spec.ts` aunque no correspondan a un `SC-XX` explícito de la US.
