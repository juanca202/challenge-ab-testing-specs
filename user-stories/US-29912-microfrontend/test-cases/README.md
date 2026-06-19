# Casos de prueba — US-29912

Casos de prueba extraídos de Azure DevOps (proyecto **Reto BBolivariano**) y vinculados a la historia [US-29912](../README.md) mediante la relación *Tested By*.

- **Origen:** [Azure DevOps — work item #29912](https://dev.azure.com/BayteqDev/Reto%20BBolivariano/_workitems/edit/29912)
- **Total:** 16 casos de prueba
- **Última extracción:** 2026-06-18

## Índice

| ID | Criterio | Prioridad | Estado | Título |
| --- | --- | --- | --- | --- |
| [TC-29935](./TC-29935.md) | SC-01 | 1 | Design | Dado que el usuario es asignado a variante A por feature flags cuando ingresa... |
| [TC-29936](./TC-29936.md) | SC-01 | 1 | Design | Dado que el usuario es asignado a variante A por feature flags cuando ingresa... |
| [TC-29937](./TC-29937.md) | SC-02 | 1 | Design | Dado que el usuario es asignado a variante B por feature flags cuando ingresa... |
| [TC-29938](./TC-29938.md) | SC-03 | 1 | Design | Dado que el usuario ya recibió una variante por feature flags cuando navega p... |
| [TC-29939](./TC-29939.md) | SC-04 | 1 | Design | Dado que estoy en estado inicial cuando hago clic en Solicitar entonces se re... |
| [TC-29940](./TC-29940.md) | SC-04 | 1 | Design | Dado que estoy en estado solicitado cuando hago clic en Anular solicitud ento... |
| [TC-29941](./TC-29941.md) | BR-05 / CA-07 | 1 | Design | Dado que el MFE consume el API de producto cuando la respuesta es exitosa ent... |
| [TC-29942](./TC-29942.md) | — | 1 | Design | Dado que el API de producto falla cuando cargo la pantalla de oferta entonces... |
| [TC-29944](./TC-29944.md) | BR-01 | 2 | Design | Dado que el MFE está embebido en el host cuando renderiza la oferta entonces ... |
| [TC-29945](./TC-29945.md) | SC-05 | 2 | Design | Dado que el administrador cambia el porcentaje A/B en feature flags cuando un... |
| [TC-29947](./TC-29947.md) | — | 2 | Design | Dado que estoy en estado inicial cuando hago clic en Omitir entonces continúo... |
| [TC-29948](./TC-29948.md) | — | 3 | Design | Dado que estoy en estado solicitado cuando hago clic en Continuar entonces el... |
| [TC-29949](./TC-29949.md) | BR-02 | 3 | Design | Dado que el usuario recarga la página de la oferta durante la sesión cuando e... |
| [TC-29950](./TC-29950.md) | — | 4 | Design | Dado que el feature flag no está disponible o retorna valor inválido cuando c... |
| [TC-29951](./TC-29951.md) | BR-03 | 2 | Design | Dado que estoy en desktop en estado inicial cuando hago clic en Atrás entonce... |
| [TC-29953](./TC-29953.md) | BR-02 | 3 | Design | Dado que un usuario ya tiene variante asignada cuando abre el flujo en otra p... |

## Trazabilidad con escenarios de aceptación

| Escenario US | Casos de prueba ADO |
| --- | --- |
| SC-01 — Variante A (control) | TC-29935 (móvil), TC-29936 (desktop) |
| SC-02 — Variante B (challenger) | TC-29937 |
| SC-03 — Persistencia de variante | TC-29938, TC-29949, TC-29953 |
| SC-04 — Estado solicitado y reversión | TC-29939, TC-29940 |
| SC-05 — Cambio de porcentaje A/B | TC-29945 |
| BR-01 — Delimitación MFE / host | TC-29944 |
| BR-02 — Persistencia de variante | TC-29938, TC-29949, TC-29950, TC-29953 |
| BR-03 — CTAs por dispositivo | TC-29935, TC-29936, TC-29937, TC-29939, TC-29951 |
| BR-05 — API producto y Redux | TC-29941, TC-29942 |
| Flujos adicionales | TC-29947 (Omitir), TC-29948 (Continuar) |

## Notas

- Los IDs `TC-XXXXX` coinciden con el work item de tipo *Test Case* en Azure DevOps.
- Para re-sincronizar desde ADO, volver a ejecutar la extracción sobre los work items vinculados a #29912.