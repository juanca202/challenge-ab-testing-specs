# Revisión de código — 2026-06-18

- **Historia:** US-29912 — Microfrontend de seguro embebido con experimentación A/B
- **Secuencial:** 001
- **Fecha de generación:** 2026-06-18
- **Repositorios auditados:** `challenge-ab-testing` (MFE), `challenge-ab-testing-host` (contenedor)
- **Modo:** default (tsc, eslint, tests unitarios, cobertura, build, e2e Playwright; sonar omitido por ausencia de `sonar-project.properties`)
- **Última actualización:** 2026-06-18 (cobertura 100% en ambos repos)

---

## challenge-ab-testing-host

- **Rama:** `develop` · **Commit:** `7a40357` · **Working tree:** sucio (9 archivos)

| # | Check | Estado | Detalle |
|---|--------|--------|---------|
| 1 | tsc | ✅ | 0 errores |
| 2 | eslint | ✅ | 0 errores, 1 warning (`baseURL` sin usar en e2e) |
| 3 | tests unitarios | ✅ | 101/101 |
| 4 | cobertura | ✅ | **100%** stmts/branches/funcs/lines |
| 5 | build | ✅ | Export estático OK |
| 6 | e2e (Playwright) | ✅ | **35 passed**, 3 skipped* (~2.4 min) |
| 7 | sonar | ⚠️ | SKIPPED (sin `sonar-project.properties`) |

**Veredicto: ✅ Apto**

\*Los 3 skipped son esperados: TC-29935/TC-29936/TC-29951 se omiten en el viewport que no les corresponde (desktop ↔ móvil).

---

## challenge-ab-testing (MFE)

- **Rama:** `develop` · **Commit:** `26cc585` · **Working tree:** sucio (4 archivos)

| # | Check | Estado | Detalle |
|---|--------|--------|---------|
| 1 | tsc | ✅ | 0 errores |
| 2 | eslint | ✅ | 0 errores |
| 3 | tests unitarios | ✅ | 133/133 |
| 4 | cobertura | ✅ | **100%** stmts/branches/funcs/lines |
| 5 | build | ✅ | Export estático OK |
| 6 | e2e | — | Ejecutados desde el host (Module Federation) |
| 7 | sonar | ⚠️ | SKIPPED |

**Veredicto: ✅ Apto**

---

## Cobertura de pruebas unitarias

Comando: `npm run test:coverage` (`vitest run --coverage`, provider v8).  
Umbral interno del repo y ADR-005: **100%** cumplido en ambos proyectos.

### challenge-ab-testing-host

- **Tests:** 101/101 passed · **Exit code:** 0
- **Duración:** ~5.9s

| Métrica | % | Cubierto |
|---------|---|----------|
| Statements | **100%** | 208/208 |
| Branches | **100%** | 136/136 |
| Functions | **100%** | 76/76 |
| Lines | **100%** | 201/201 |

**Tests añadidos para cobertura:** `config.test.ts`, `client.auth.test.ts`, ampliación de `validar.test.ts` y `apiAuthStorage.test.ts`.

### challenge-ab-testing (MFE)

- **Tests:** 133/133 passed · **Exit code:** 0
- **Duración:** ~8.6s

| Métrica | % | Cubierto |
|---------|---|----------|
| Statements | **100%** | 442/442 |
| Branches | **100%** | 262/262 |
| Functions | **100%** | 121/121 |
| Lines | **100%** | 427/427 |

**Tests añadidos para cobertura:** `rum.test.ts`, ampliación de `validar.test.ts`, `apiAuthStorage.test.ts`, `store/index.test.ts`, `useInsuranceActions.test.tsx`.

### Interpretación BR-07

| Criterio | Host | MFE | Estado |
|----------|------|-----|--------|
| Tests unitarios ejecutados | ✅ 101/101 | ✅ 133/133 | Cumple |
| Cobertura 100% (`vitest.config`) | ✅ | ✅ | Cumple |
| Ramas ≥80% (ADR-005) | ✅ 100% | ✅ 100% | Cumple |
| SonarQube | — | — | No ejecutado |

---

## Reporte de trazabilidad — US-29912

**Casos ADO:** 16/16 cubiertos en e2e

### Leyenda

| Símbolo | Significado |
|---------|-------------|
| ✅ | Cubierto y ejecutado con éxito en esta revisión |
| ⚠️ | Cubierto parcialmente o no verificado en esta corrida |
| — | No aplica directamente |

---

### Escenarios de aceptación (SC)

| Escenario | Criterio Gherkin (resumen) | E2E | Unitarios MFE | Unitarios Host |
|-----------|---------------------------|-----|---------------|----------------|
| **SC-01** Variante A control | Mensaje control, coberturas, $4.99, CTAs móvil/desktop | ✅ TC-29935 (móvil), TC-29936 (desktop) | `VariantA.test.tsx`, `CoverageList.test.tsx`, `SeguroEmbebidoScreen.integration.test.tsx` | `smoke.spec.ts` |
| **SC-02** Variante B challenger | Banner, beneficios, mismos CTAs | ✅ TC-29937 | `VariantB.test.tsx`, `SeguroEmbebidoScreen.integration.test.tsx` | — |
| **SC-03** Persistencia al salir/regresar | Misma variante al reingresar | ✅ TC-29938, TC-29949, TC-29953 + `ab-variant.spec` (persistencia) | `SeguroEmbebidoScreen.persistence.test.tsx`, `useVariantAssignment.test.tsx`, `variantSlice.test.ts`, `readVariantCookie.test.ts` | `lib/store/index.test.ts` (hydrate sesión) |
| **SC-04** Estado solicitado y reversión | Solicitar → solicitado; Anular → inicial | ✅ TC-29939, TC-29940 | `insuranceSlice.test.ts`, `useInsuranceActions.test.tsx`, `SeguroEmbebidoScreen.decision.test.tsx`, `RequestedBanner.test.tsx` | `insuranceStub.test.ts` |
| **SC-05** Cambio de split sin redespliegue | Nuevos usuarios según % A/B | ✅ TC-29945 + `ab-variant.spec` (reparto según split) | `mockClient.test.ts`, `readVariantCookie.test.ts` | `e2e/global-setup.ts` (PATCH flags en staging) |

---

### Reglas de negocio (BR)

| BR | Descripción | E2E | Unitarios MFE | Unitarios Host | Estado |
|----|-------------|-----|---------------|----------------|--------|
| **BR-01** | MFE no controla encabezado/marco del host | ✅ TC-29944 (+ aserciones en varios TC) | `useSeguroNavigation.test.ts` (navegación inyectada) | `RemoteSeguroEmbebido.test.tsx`, `onboarding/seguro.test.tsx` | ✅ |
| **BR-02** | Asignación única y persistente en sesión | ✅ TC-29938, TC-29949, TC-29950, TC-29953 | `useVariantAssignment.test.tsx`, `variantSlice.test.ts`, `insuranceSessionStorage.test.ts` | `lib/store/index.test.ts` | ✅ |
| **BR-03** | CTAs correctos por estado y dispositivo | ✅ TC-29935, TC-29936, TC-29937, TC-29939, TC-29951 | `SeguroCtaBar.test.tsx`, `useInsuranceActions.test.tsx` | — | ✅ |
| **BR-04** | Split modificable sin redespliegue | ✅ TC-29945, `ab-variant.spec` | `mockClient.test.ts` | Harness `abGateway.ts` | ✅ |
| **BR-05** | API producto + persistencia Redux | ✅ TC-29941, TC-29942 | `consultarProducto.test.ts`, `cotizacion.test.ts`, `useSeguroProduct.test.tsx`, `insuranceSessionStorage.test.ts` | `validar.test.ts`, `useLogCotizacionEnRedux.test.tsx` | ✅ |
| **BR-06** | Solicitar / Anular solicitud | ✅ TC-29939, TC-29940 | `insuranceSlice.test.ts`, `useInsuranceActions.test.tsx`, `SeguroEmbebidoScreen.decision.test.tsx` | `insuranceStub.test.ts` | ✅ |
| **BR-07** | Estático S3/CloudFront + calidad SDLC | Build estático ✅ · cobertura **100%** | 133 tests · cobertura **100%** | 101 tests + 35 e2e · cobertura **100%** | ⚠️ Sonar pendiente |

---

### Casos de prueba ADO (TC) → automatización

| TC | Escenario / BR | Prueba automatizada | Tipo | Resultado |
|----|----------------|---------------------|------|-----------|
| TC-29935 | SC-01 / BR-03 | `e2e/us-29912.spec.ts` — variante A móvil | E2E | ✅ (mobile-chrome) |
| TC-29936 | SC-01 / BR-03 | `e2e/us-29912.spec.ts` — variante A desktop | E2E | ✅ (chromium-desktop) |
| TC-29937 | SC-02 / BR-03 | `e2e/us-29912.spec.ts` — variante B | E2E | ✅ |
| TC-29938 | SC-03 / BR-02 | `e2e/us-29912.spec.ts` — salir y reingresar | E2E | ✅ |
| TC-29939 | SC-04 / BR-03 / BR-06 | `e2e/us-29912.spec.ts` — Solicitar | E2E | ✅ |
| TC-29940 | SC-04 / BR-06 | `e2e/us-29912.spec.ts` — Anular solicitud | E2E | ✅ |
| TC-29941 | BR-05 | `e2e/us-29912.spec.ts` — API exitosa | E2E | ✅ |
| TC-29942 | BR-05 | `e2e/us-29912.spec.ts` — API fallida | E2E | ✅ |
| TC-29944 | BR-01 | `e2e/us-29912.spec.ts` — marco del host intacto | E2E | ✅ |
| TC-29945 | SC-05 / BR-04 | `e2e/us-29912.spec.ts` — split A/B | E2E | ✅ |
| TC-29947 | Flujo Omitir | `e2e/us-29912.spec.ts` — Omitir | E2E | ✅ |
| TC-29948 | Flujo Continuar | `e2e/us-29912.spec.ts` — Continuar | E2E | ✅ |
| TC-29949 | SC-03 / BR-02 | `e2e/us-29912.spec.ts` — recarga de página | E2E | ✅ |
| TC-29950 | BR-02 (fallback) | `e2e/us-29912.spec.ts` — cookie inválida → A | E2E | ✅ |
| TC-29951 | BR-03 | `e2e/us-29912.spec.ts` — Atrás desktop | E2E | ✅ (chromium-desktop) |
| TC-29953 | SC-03 / BR-02 | `e2e/us-29912.spec.ts` — otra pestaña | E2E | ✅ |

**Cobertura ADO:** 16/16 TC mapeados a `challenge-ab-testing-host/e2e/us-29912.spec.ts` — todos ejecutados y pasando en el viewport correspondiente.

---

### Pirámide de pruebas por capa

```
                    ┌─────────────────────┐
                    │  E2E Playwright     │  38 specs (35 ejecutados + 3 skip viewport)
                    │  host + MFE real    │  16 TC ADO + smoke + ab-variant
                    └──────────┬──────────┘
                               │
              ┌────────────────┴────────────────┐
              │  Integración / componentes MFE   │  ~15 tests (flujos, persistencia, API)
              └────────────────┬────────────────┘
                               │
         ┌─────────────────────┴─────────────────────┐
         │  Unitarios MFE (133) + Host (101) = 234   │  slices, hooks, API, navegación
         └───────────────────────────────────────────┘
```

---

### Resumen ejecutivo

| Área | Cobertura | Observación |
|------|-----------|-------------|
| Escenarios SC-01 a SC-05 | **5/5** | Validados en e2e + respaldo unitario |
| Reglas BR-01 a BR-06 | **6/6** | Completas |
| Reglas BR-07 (SDLC) | **Parcial** | Cobertura 100% en ambos repos; falta Sonar |
| Casos ADO TC-29935…TC-29953 | **16/16** | Todos automatizados en Playwright |

**Conclusión:** La implementación cumple los criterios funcionales de US-29912 con trazabilidad completa escenario ↔ TC ↔ prueba automatizada. **BR-07** queda parcial únicamente por SonarQube no ejecutado; cobertura unitaria al **100%** en host y MFE.

---

### Correcciones aplicadas antes de esta revisión

| Repositorio | Cambio |
|-------------|--------|
| `challenge-ab-testing-host` | `vitest.setup.ts`: `NEXT_PUBLIC_USE_API_MOCK=true` para evitar `fetch('/validar')` inválido en tests de `_app` |
| `challenge-ab-testing-host` | `e2e/us-29912.spec.ts`: tipado `TestInfo` en `viewportMode` |
| `challenge-ab-testing` | Mock de `next/router` con `push` en export default (3 archivos de test) |
| `challenge-ab-testing` | `useInsuranceActions.test.tsx`: `await` en test de `anular` (acción async con delay) |

### Ampliación de cobertura (100%)

| Repositorio | Tests nuevos / ampliados | Ajustes de código |
|-------------|--------------------------|-------------------|
| **host** | `config.test.ts`, `client.auth.test.ts`, `validar.test.ts`, `apiAuthStorage.test.ts` | Simplificación `finally` en `validar.ts` (deduplicación in-flight) |
| **MFE** | `rum.test.ts`, `validar.test.ts`, `apiAuthStorage.test.ts`, `store/index.test.ts`, `useInsuranceActions.test.tsx` | `resetRumClientForTests()` en `rum.ts`; simplificación `finally` en `validar.ts` y `consultarProducto.ts` |

---

### Próximas acciones sugeridas

1. Ejecutar SonarQube para cerrar **BR-07**.
2. Opcional: eliminar `baseURL` no usado en `challenge-ab-testing-host/e2e/us-29912.spec.ts:232` (warning eslint).
3. Re-ejecutar e2e en staging con `E2E_BASE_URL` para validar gateway real de feature flags.
