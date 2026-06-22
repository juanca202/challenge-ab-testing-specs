# Reporte de trazabilidad — Requerimiento A/B Testing Seguro Embebido BB

|               |                                                                                                                                 |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **Documento** | [requerimiento-ab-testing-seguro-embebido-bb.md](./requerimiento-ab-testing-seguro-embebido-bb.md)                              |
| **Historia vinculada** | [US-29912](./user-stories/US-29912-microfrontend/README.md) (implementación piloto)                                      |
| **Repositorios** | `challenge-ab-testing` (MFE) · `challenge-ab-testing-host` (contenedor) · casos ADO en este repo specs                    |
| **Fecha**     | 2026-06-19                                                                                                                      |
| **Veredicto** | **APROBADO CON OBSERVACIONES**                                                                                                  |
| **Cobertura** | 5 de 7 criterios de aceptación cubiertos · 2 parciales (71 % cubiertos plenamente; 100 % con prueba asociada)                 |

## Resumen

Los siete criterios de aceptación (`CA-01`–`CA-07`) del requerimiento piloto tienen trazabilidad verificable contra casos de prueba ADO (`TC-29935`–`TC-29953`), tests unitarios/integración (Vitest) y E2E (Playwright) en los repos MFE y host. Se ejecutaron **152** tests del MFE, **108** del host (100 % paso), cobertura **100 % ramas** en ambos, y **29** tests E2E de US-29912 (100 % paso; 3 omitidos por viewport). **CA-05** y **CA-06** quedan parciales: la cobertura de pruebas supera el umbral del repositorio (≥ 80 % ADR-005), pero SonarQube, análisis de seguridad y despliegue real S3/CloudFront no son verificables de forma automatizada desde el código en esta validación.

## Matriz de trazabilidad

| Criterio | Descripción | Reqs. relacionados | Caso(s) de prueba | Artefacto(s) (tipo) | Estado | Ejec. auto | Resultado | Observaciones |
| -------- | ----------- | ------------------ | ----------------- | ------------------- | ------ | ---------- | --------- | ------------- |
| CA-01 | Usuario en variante A ve pantalla control; usuario en variante B ve pantalla challenger (móvil y desktop) | RF-01 | TC-29935, TC-29936, TC-29937 | `challenge-ab-testing`: `VariantA.test.tsx`, `VariantB.test.tsx`, `CoverageList.test.tsx` (unit); `SeguroEmbebidoScreen.integration.test.tsx` (integración). `challenge-ab-testing-host`: `e2e/us-29912.spec.ts` (e2e) | Cubierto | Sí | Paso | Unit valida copy y coberturas por variante; E2E cubre móvil (TC-29935) y desktop (TC-29936) para A, y B (TC-29937) |
| CA-02 | La variante asignada se mantiene constante al salir y regresar en la misma sesión o en ingresos posteriores | RF-02, RF-03 | TC-29938, TC-29949, TC-29953 | `challenge-ab-testing`: `useVariantAssignment.test.tsx`, `variantSlice.test.ts`, `readVariantCookie.test.ts`, `insuranceSessionStorage.test.ts` (unit); `SeguroEmbebidoScreen.persistence.test.tsx` (integración). `challenge-ab-testing-host`: `e2e/us-29912.spec.ts` (e2e) | Cubierto | Sí | Paso | Cubre navegación, recarga y otra pestaña (TC-29953). «Ingresos posteriores» en sesión distinta no tiene caso E2E explícito; persistencia vía cookie/storage queda cubierta en unit |
| CA-03 | Los CTA cambian correctamente entre estado inicial y estado «solicitado» | RF-04, RF-05 | TC-29935, TC-29936, TC-29937, TC-29939, TC-29940, TC-29951 | `challenge-ab-testing`: `SeguroCtaBar.test.tsx`, `RequestedBanner.test.tsx` (unit); `SeguroEmbebidoScreen.decision.test.tsx` (integración). `challenge-ab-testing-host`: `e2e/us-29912.spec.ts` (e2e) | Cubierto | Sí | Paso | Unit cubre todas las combinaciones dispositivo × estado; E2E valida transición Solicitar → solicitado (TC-29939) y Anular → inicial (TC-29940) |
| CA-04 | El porcentaje de asignación entre variantes puede modificarse desde el administrador de feature flags sin redesplegar | RF-10 | TC-29945 | `challenge-ab-testing`: `mockClient.test.ts`, `readVariantCookie.test.ts` (unit). `challenge-ab-testing-host`: `e2e/us-29912.spec.ts` TC-29945, `e2e/ab-variant.spec.ts` (e2e) | Cubierto | Sí | Paso | En local el split se simula en harness; validación contra administrador real requiere staging con `E2E_FLAGS_API_KEY` |
| CA-05 | El microfrontend pasa SonarQube, análisis de seguridad y umbral de cobertura de pruebas | RNF-01, RNF-02, RNF-03 | — (verificación de pipeline) | `challenge-ab-testing` y `challenge-ab-testing-host`: `npm run test:coverage` (unit); scripts `npm run sonar:scan`, `Deploy.md` (manual) | Parcial | Parcial | Paso (cobertura) | Cobertura MFE: 100 % statements, 100 % branches (152 tests). Host: 100 % statements, 100 % branches (108 tests). ≥ 80 % ADR-005 cumplido. SonarQube y análisis de seguridad: proceso manual pre-PR; no ejecutables en esta validación |
| CA-06 | Despliegue correcto como sitio estático en S3 + CloudFront | RNF-06 | — (validación infra) | `challenge-ab-testing`: `next.config.ts` (`output: 'export'`), `Deploy.md`, `deploy.sh`/`deploy.ps1` (manual). `challenge-ab-testing-host`: equivalente en repo host | Parcial | No | No ejecutado | Build estático configurado y scripts documentados; no se ejecutó deploy real ni smoke post-despliegue en esta validación |
| CA-07 | La cotización se almacena en Redux para que el host conozca si el cliente aceptó o no el seguro ofertado | RF-06, RF-07 | TC-29941, TC-29948 | `challenge-ab-testing`: `consultarProducto.test.ts`, `cotizacion.test.ts`, `insuranceSlice.test.ts`, `store/selectors/insurance.test.ts`, `useSeguroProduct.test.tsx` (unit). `challenge-ab-testing-host`: `useInsuranceDecision.test.tsx`, `useLogCotizacionEnRedux.test.tsx`, `store/selectors/insurance.test.ts` (unit); `e2e/us-29912.spec.ts` TC-29941/TC-29948 (e2e) | Cubierto | Sí | Paso | E2E confirma persistencia de cotización en sesión y lectura de decisión por el host tras Continuar |

## Trazabilidad requerimientos funcionales → pruebas

| Req. | Descripción breve | Cobertura principal |
| ---- | ------------------- | ------------------- |
| RF-01 | Render móvil/desktop por variante | CA-01 → `VariantA/B.test.tsx`, E2E TC-29935–37 |
| RF-02 | Asignación variante vía feature flags | CA-02 → `useVariantAssignment.test.tsx`, `mockClient.test.ts` |
| RF-03 | Persistencia de variante en navegación | CA-02 → `SeguroEmbebidoScreen.persistence.test.tsx`, E2E TC-29938/49/53 |
| RF-04 | CTAs estado inicial | CA-03 → `SeguroCtaBar.test.tsx` |
| RF-05 | CTAs estado solicitado | CA-03 → `RequestedBanner.test.tsx`, E2E TC-29939/40 |
| RF-06 | Consumo API producto | CA-07 → `consultarProducto.test.ts`, E2E TC-29941/42 |
| RF-07 | Cotización en memoria (Redux) | CA-07 → `insuranceSlice.test.ts`, `useInsuranceDecision.test.tsx` |
| RF-08 | Solicitar → estado solicitado | CA-03 → `SeguroEmbebidoScreen.decision.test.tsx`, E2E TC-29939 |
| RF-09 | Anular → estado inicial | CA-03 → `useInsuranceActions.test.tsx`, E2E TC-29940 |
| RF-10 | Ajuste split sin redespliegue | CA-04 → E2E TC-29945, `ab-variant.spec.ts` |

## Artefactos de prueba automatizada disponibles

| Tipo        | Presente | Artefactos |
| ----------- | -------- | ---------- |
| Unit        | Sí       | **MFE** (33 archivos): `src/features/seguro-embebido/`, `src/lib/api/`, `src/lib/rum/`. **Host** (33 archivos): `RemoteSeguroEmbebido.test.tsx`, `useInsuranceDecision.test.tsx`, `OnboardingLayout.test.tsx`, etc. |
| Integración | Sí       | **MFE**: `SeguroEmbebidoScreen.integration.test.tsx`, `SeguroEmbebidoScreen.persistence.test.tsx`, `SeguroEmbebidoScreen.decision.test.tsx`. **Host**: `demo-flow.integration.test.tsx` |
| E2E         | Sí       | **Host**: `e2e/us-29912.spec.ts` (16 casos TC mapeados a US-29912/CA), `e2e/ab-variant.spec.ts`, `e2e/smoke.spec.ts` |
| Manual      | Sí       | Casos ADO en [test-cases/US-29912](./user-stories/US-29912-microfrontend/test-cases/README.md); despliegue (`Deploy.md`); SonarQube pre-PR |

## Ejecución automática

|                       |                                                                                                                                 |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **Runner detectado**  | Vitest (unit/integración MFE y host); Playwright (E2E host)                                                                     |
| **Comando ejecutado** | `cd challenge-ab-testing && npm run test:run && npm run test:coverage` · `cd challenge-ab-testing-host && npm run test:run && npm run test:coverage` · `cd challenge-ab-testing-host && npm run test:e2e -- e2e/us-29912.spec.ts` |
| **Resultado global**  | MFE: 152/152 pasaron · cobertura 100 % ramas. Host unit: 108/108 pasaron · cobertura 100 % ramas. E2E US-29912: 29 pasaron, 3 omitidos (viewport), 0 fallos |

## Observaciones y pendientes

- **CA-05:** Confirmar ejecución de SonarQube y análisis de seguridad en pipeline ADO o sesión manual pre-merge; el requerimiento origen cita 100 % de cobertura pero el ADR-005 del repo exige ≥ 80 % ramas (cumplido al 100 %).
- **CA-06:** Validar deploy real a S3 + CloudFront en entorno staging/producción; la configuración `output: 'export'` y scripts están presentes pero no se verificó un despliegue en esta sesión.
- **CA-04:** En entorno local el cambio de split A/B se simula; contra administrador real de feature flags requiere staging con credenciales (`E2E_FLAGS_API_KEY`).
- **CA-02:** «Ingresos posteriores» en sesión nueva no tiene escenario E2E dedicado; la persistencia vía cookie queda cubierta en unit/E2E de recarga y otra pestaña.
- **Casos ADO adicionales** (TC-29942 error API, TC-29947 Omitir, TC-29950 fallback cookie) refuerzan RF-06/RF-08 aunque no mapeen a un `CA-XX` explícito del requerimiento.
