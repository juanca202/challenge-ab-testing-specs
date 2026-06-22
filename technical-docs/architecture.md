# Arquitectura del microfrontend — Seguro embebido A/B

Documento de referencia de la arquitectura del **remote** `challenge-ab-testing` (`seguroEmbebidoMfe`), integrado en el host `challenge-ab-testing-host`.

**Repositorios:**

| Repositorio | Rol | Puerto dev |
| ----------- | --- | ---------- |
| `challenge-ab-testing` | Remote — expone pantalla de seguro | 3001 |
| `challenge-ab-testing-host` | Host — embebe el MFE en onboarding | 3000 |

**ADRs relacionados** (en `challenge-ab-testing/docs/adr/`):

- [ADR-001](https://github.com/BayteqDev/challenge-ab-testing/blob/main/docs/adr/ADR-001-pages-router-only.md) — SPA estática, Pages Router
- [ADR-003](https://github.com/BayteqDev/challenge-ab-testing/blob/main/docs/adr/ADR-003-redux-state-management.md) — Redux Toolkit
- [ADR-004](https://github.com/BayteqDev/challenge-ab-testing/blob/main/docs/adr/ADR-004-feature-based-architecture.md) — Arquitectura por features
- [ADR-008](https://github.com/BayteqDev/challenge-ab-testing/blob/main/docs/adr/ADR-008-rest-service-layer.md) — Service Layer REST
- [ADR-009](https://github.com/BayteqDev/challenge-ab-testing/blob/main/docs/adr/ADR-009-module-federation-microfrontend.md) — Module Federation

---

## 1. Contexto del sistema

Vista de cómo el MFE se integra con el ecosistema externo.

```mermaid
flowchart TB
    subgraph Usuario
        U[👤 Usuario en onboarding]
    end

    subgraph CDN["CDN / CloudFront"]
        HCDN["Host estático<br/>challenge-ab-testing-host<br/>:3000 / out/"]
        MCDN["MFE estático<br/>challenge-ab-testing<br/>:3001 / out/"]
        COOKIE["Cookie mfe-variant<br/>(A | B)"]
    end

    subgraph Host["Host (contenedor)"]
        HL[OnboardingLayout]
        RSE[RemoteSeguroEmbebido<br/>dynamic + lazy]
        HREDUX[Redux host<br/>+ slices del MFE]
    end

    subgraph MFE["Microfrontend (remote)"]
        RE["remoteEntry.js"]
        SES[SeguroEmbebidoScreen]
        STORE["./store<br/>(reducers + actions)"]
    end

    subgraph APIs["Backends externos (REST)"]
        AUTH[Auth / JWT]
        PROD[Consultar producto]
        COT[Cotización]
    end

    U --> HCDN
    COOKIE -.->|inyectada por gateway| U
    HCDN --> HL
    HL --> RSE
    RSE -->|runtime import| RE
    RE --> SES
    RE --> STORE
    MCDN --> RE
    STORE -.->|registro federado| HREDUX
    SES -->|nextPage / backPage| HL
    SES --> AUTH
    SES --> PROD
    SES --> COT
```

---

## 2. Arquitectura interna (capas)

Estructura feature-based según ADR-004.

```mermaid
flowchart TB
    subgraph Pages["src/pages/ — Enrutamiento Next.js"]
        APP["_app.tsx<br/>Provider Redux + RUM + hydrate"]
        DOC["_document.tsx"]
        IDX["index.tsx — dev aislado"]
        SEG["seguro-embebido.tsx — deep-link"]
    end

    subgraph Feature["src/features/seguro-embebido/ — Dominio"]
        direction TB
        COMP["components/<br/>SeguroEmbebidoScreen, VariantA/B,<br/>SeguroCtaBar, CoverageList…"]
        HOOKS["hooks/<br/>useVariantAssignment,<br/>useSeguroProduct,<br/>useInsuranceActions"]
        SLICES["store/<br/>variantSlice + insuranceSlice<br/>selectors + sessionStorage"]
        UTILS["utils/ + constants/ + types.ts"]
    end

    subgraph Lib["src/lib/ — Infraestructura"]
        API["api/ — Service Layer REST<br/>client, auth, seguro/, featureFlags/"]
        STORE["store/ — configureStore + hooks"]
        MF["mf/federation.ts — constantes MF"]
        RUM["rum/rum.ts — telemetría"]
    end

    subgraph Shared["src/shared/ + src/styles/"]
        TEST["testing/renderWithProviders"]
        CSS["globals.css — Tailwind v4"]
    end

    subgraph Federation["Module Federation (cliente)"]
        EXPOSE1["./SeguroEmbebidoScreen"]
        EXPOSE2["./store"]
    end

    Pages --> Feature
    Feature --> Lib
    Feature --> Shared
    APP --> STORE
    COMP --> HOOKS
    HOOKS --> SLICES
    HOOKS --> API
    SLICES --> STORE
    COMP --> EXPOSE1
    SLICES --> EXPOSE2
```

### Reglas de ubicación

| Ubicación | Contenido |
| --------- | --------- |
| `src/pages/` | Solo enrutamiento Next.js; las páginas componen UI desde `features/` |
| `src/features/seguro-embebido/` | Dominio: componentes, hooks, slices Redux, tipos, validaciones |
| `src/shared/` | Código reutilizado por varias features |
| `src/components/` | UI agnóstica de dominio |
| `src/lib/` | Infraestructura: Service Layer REST, store, federation, RUM |
| `src/styles/` | Estilos globales (Tailwind v4) |

---

## 3. Flujo de datos en runtime

Secuencia desde el montaje hasta la decisión del usuario.

```mermaid
sequenceDiagram
    participant Host as Host (:3000)
    participant MF as SeguroEmbebidoScreen
    participant FF as FeatureFlagClient
    participant Cookie as Cookie mfe-variant
    participant Redux as Redux (variant + insurance)
    participant API as Service Layer
    participant SS as sessionStorage

    Host->>MF: mount(nextPage, backPage)
    MF->>FF: getAssignedVariant()
    FF->>Cookie: readVariantCookie()
    Cookie-->>FF: A | B | default A
    FF-->>Redux: variantAssigned

    MF->>API: consultarProducto()
    API-->>Redux: productLoaded

    par Renderizado A/B
        alt Variante A
            MF->>MF: VariantA + CoverageList
        else Variante B
            MF->>MF: VariantB + banner
        end
    end

    Note over MF: Usuario: Solicitar / Omitir / Anular
    MF->>Redux: solicitarSeguro | omitirSeguro | anularSolicitud
    Redux->>SS: persist insurance state
    MF->>API: cotizacion() (in-memory)
    API-->>Redux: quoteRegistered

    Note over MF: Usuario: Continuar / Atrás
    MF->>Host: router.push(nextPage | backPage)
```

---

## 4. Build y despliegue

SPA estática con Module Federation solo en el bundle cliente (ADR-001, ADR-009).

```mermaid
flowchart LR
    subgraph Dev["Desarrollo local"]
        DEV1["npm run dev<br/>PORT=3001"]
        DEV2["Host :3000 carga<br/>remoteEntry.js desde :3001"]
    end

    subgraph Build["npm run build"]
        NEXT["next build<br/>output: export"]
        WEBPACK["NextFederationPlugin<br/>(solo cliente)"]
        OUT["out/<br/>HTML + JS estático<br/>remoteEntry.js"]
    end

    subgraph Prod["Producción"]
        S3MFE["S3 + CloudFront<br/>MFE_PUBLIC_URL"]
        S3HOST["S3 + CloudFront<br/>HOST_PUBLIC_URL"]
        ENV["NEXT_PUBLIC_MFE_REMOTE_URL<br/>en build del host"]
    end

    DEV1 --> DEV2
    NEXT --> WEBPACK --> OUT
    OUT --> S3MFE
    S3MFE --> ENV
    ENV --> S3HOST
```

### Flujo de desarrollo local

1. Levantar el MFE: `cd challenge-ab-testing && npm run dev`
2. Levantar el host: `cd challenge-ab-testing-host && npm run dev`
3. Abrir `http://localhost:3000` — el host carga `remoteEntry.js` desde `http://localhost:3001`

---

## 5. Contratos expuestos al host

| Expose | Origen | Propósito |
| ------ | ------ | --------- |
| `./SeguroEmbebidoScreen` | `SeguroEmbebidoScreen.tsx` | UI del piloto A/B embebida en `/onboarding/seguro` |
| `./store` | `features/seguro-embebido/store/index.ts` | Reducers, actions y selectors para Redux compartido |

### Props host → MFE

| Prop | Tipo | Descripción |
| ---- | ---- | ----------- |
| `nextPage` | `string?` | Ruta tras completar el flujo (demo: `/onboarding/despues`) |
| `backPage` | `string?` | Ruta del botón Atrás (demo: `/onboarding/antes`) |

### Salidas MFE → host

| Mecanismo | Contenido |
| --------- | --------- |
| Redux | Slices `variant` e `insurance` |
| Navegación | `router.push(nextPage \| backPage)` cuando aplica |

### Responsabilidades visuales

| Zona | Owner |
| ---- | ----- |
| Encabezado, logo, salir | Host |
| Oferta, variantes A/B, CTAs internos | MFE |
| Loading/error de producto o flags | MFE |

---

## 6. Estado Redux

```mermaid
stateDiagram-v2
    [*] --> Inicial: mount

    state variant {
        [*] --> Asignando
        Asignando --> Asignada: cookie A|B (default A)
    }

    state insurance {
        [*] --> SinDecision
        SinDecision --> Solicitado: solicitarSeguro
        SinDecision --> Omitido: omitirSeguro
        Solicitado --> SinDecision: anularSolicitud
        Solicitado --> Cotizado: quoteRegistered
        Omitido --> Cotizado: quoteRegistered
    }

    Inicial --> variant
    variant --> insurance
```

### Slices

| Slice | Responsabilidad |
| ----- | --------------- |
| `variant` | Variante A/B asignada (`A` \| `B`) |
| `insurance` | Decisión del usuario, producto cargado, cotización |

La decisión de seguro se persiste en `sessionStorage` para sobrevivir recargas de página.

---

## 7. Asignación de variante A/B

| Aspecto | Contrato |
| ------- | -------- |
| Cookie | `mfe-variant` con valor `A` o `B` |
| Escritura | CDN/gateway según administrador de feature flags |
| Lectura | MFE vía `FeatureFlagClient` (sin API directa de flags) |
| Ausente o inválida | Variante A (control) por defecto |

---

## 8. Stack tecnológico

| Aspecto | Decisión |
| ------- | -------- |
| Framework | Next.js 15 Pages Router, React 19, TypeScript |
| Despliegue | SPA estática (`out/`), sin servidor Node en producción |
| Integración | Module Federation (`seguroEmbebidoMfe`) |
| Dominio | Feature `seguro-embebido` con variantes A/B |
| Estado | Redux Toolkit + `sessionStorage` para persistencia |
| APIs | Service Layer en `src/lib/api/` (cliente → REST externo) |
| A/B | Cookie `mfe-variant` (CDN/gateway), default variante A |
| UI | Tailwind v4 + Base UI + Heroicons |
| Tests | Vitest co-located, TDD, cobertura ramas ≥ 80 % |

---

## Referencias

- Contrato host ↔ MFE: `challenge-ab-testing/specs/001-mfe-embedded-insurance/contracts/host-mfe-integration.md`
- Contratos API (mocks): [api-contracts/README.md](./api-contracts/README.md)
- Historia de usuario: [US-29912](../user-stories/US-29912-microfrontend/README.md)
