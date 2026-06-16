# Requerimiento — A/B Testing en seguro embebido (BB)

**Banco Bolivariano** · Workshop Gen IA · 2026  
**Versión:** 1.0 · Confidencial — Uso interno  
**Microfrontend:** Seguro embebido — Cuentas de ahorro online

> Fuente: `Requerimiento_AB_Testing_Seguro_Embebido_BB.docx` (piloto).

---

## 1. Introducción y objetivo

El Banco Bolivariano ofrece, dentro del flujo de contratación online de cuentas de ahorro digital, un producto de seguro embebido contra fraudes. Este seguro se presentará al cliente como una pantalla de oferta integrada en el onboarding de la cuenta, implementada como un **microfrontend**.

El presente documento especifica el requerimiento para incorporar una capa de **experimentación A/B** sobre dicho microfrontend, con el fin de medir el impacto de variantes de copy, layout y llamados a la acción (CTA) sobre la tasa de contratación del seguro, sin afectar la estabilidad del flujo actual.

### 1.1 Objetivo del requerimiento

- Construir el componente de la pantalla de seguro embebido y exponerlo como microfrontend.
- Agregar una capa de experimentación A/B: asignación de variante al usuario y persistencia de dicha asignación entre los distintos estados de navegación del flujo.
- Permitir la comparación entre la variante actual (control) y una variante challenger basada en el diseño de Figma compartido en las imágenes.
- Cumplir con los estándares de calidad y seguridad del SDLC del banco, incorporando la metodología SDD en todas las etapas del ciclo de desarrollo con agentes de IA.

---

## 2. Alcance

### 2.1 Dentro del alcance

- Pantalla de oferta del seguro embebido dentro del onboarding de cuentas de ahorro online, en versiones **móvil** y **web (desktop)**.
- Construcción del microfrontend que expone dicha pantalla.
- Mecanismo de asignación de variante (A/B) controlado por **feature flags**.
- Persistencia de la variante y del estado de la solicitud durante la navegación del usuario.
- Contrato de API para listar el producto a presentar y servicio de administración de feature flags.
- Todas las etapas del ciclo de desarrollo del piloto: Requerimiento, Diseño, Desarrollo, Pruebas y Despliegue.

### 2.2 Fuera del alcance

- Modificación del proceso de emisión o suscripción del seguro en sistemas core del banco.
- Cambios en el flujo de apertura de la cuenta de ahorro **fuera** de la pantalla de seguro.
- Persistencia transaccional de la cotización en base de datos (en esta fase la cotización se mantiene en memoria del microfrontend).

---

## 3. Contexto del negocio

| Aspecto                     | Detalle                                                                        |
| --------------------------- | ------------------------------------------------------------------------------ |
| **Flujo**                   | Contratación online de cuentas de ahorro digital del banco                     |
| **Producto**                | Seguro embebido contra fraudes, ofertado dentro del onboarding                 |
| **Implementación**          | Microfrontend en producción con pantalla de oferta del seguro                  |
| **Interacción al ingresar** | CTA «Solicitar / Omitir» en la primera vista                                   |
| **Interacción al regresar** | CTA «Continuar / Anular solicitud» si el usuario avanza y vuelve a la pantalla |

---

## 4. Entendimiento del flujo a experimentar

1. **Ingreso a la pantalla** — El usuario llega a la oferta del seguro dentro del onboarding de la cuenta de ahorro.
2. **Estado A (primera vista)** — Se muestran las coberturas y el costo, con los botones Solicitar / Omitir.
3. **Avanza y regresa** — Si el usuario sale y vuelve a la pantalla, los CTA cambian de estado según la acción previa.
4. **Estado B (al regresar)** — Se muestran los botones Continuar / Anular solicitud cuando el usuario ya había solicitado el seguro.

### 4.1 Estados de la pantalla

| Estado                | Contenido                              | CTA móvil                    | CTA desktop                          |
| --------------------- | -------------------------------------- | ---------------------------- | ------------------------------------ |
| **Inicial**           | Mensaje de oferta + coberturas + costo | Solicitar / Omitir           | Atrás / Omitir / Solicitar           |
| **Seguro solicitado** | Aviso «Ya solicitaste el seguro»       | Continuar / Anular solicitud | Atrás / Anular solicitud / Continuar |

---

## 5. Variantes del experimento A/B

El experimento contrasta dos variantes asignadas al usuario mediante feature flags, persistentes durante toda la navegación en el flujo.

### 5.1 Variante A — Control

Corresponde a la pantalla actual del seguro embebido, sin cambios. Presenta el mensaje «¡Te ayudamos a proteger tu dinero!», el detalle de coberturas y el costo mensual.

**Coberturas y costo (variante control):**

- Transferencias no reconocidas por robo desde tu cuenta hasta **$1.500**.
- Transacciones con tu tarjeta no reconocidas por robo, clonación o falsificación hasta **$1,000**.
- Secuestro exprés: restitución hasta **$600**.
- Muerte accidental por robo en cajero hasta **$3,000**.
- **Costo:** $4.99 mensual (precio incluido impuestos).

**Diseños de referencia — Variante A:**

| Vista                                       | Archivo                                                              |
| ------------------------------------------- | -------------------------------------------------------------------- |
| Móvil — estado inicial (Solicitar / Omitir) | ![Variante A móvil inicial](../assets/requerimiento/image1.png)      |
| Móvil — «Ya solicitaste el seguro»          | ![Variante A móvil solicitado](../assets/requerimiento/image2.png)   |
| Desktop — estado inicial                    | ![Variante A desktop inicial](../assets/requerimiento/image3.png)    |
| Desktop — «Ya solicitaste el seguro»        | ![Variante A desktop solicitado](../assets/requerimiento/image4.png) |

### 5.2 Variante B — Challenger

Variante con hipótesis de mejora basada en diseño Figma. Introduce banner promocional, copy orientado a beneficios y lenguaje en segunda persona, manteniendo las mismas coberturas y costo.

**Banner promocional:** «Cuenta protegida — Agrega una protección extra para tu dinero» con CTA «Actívala aquí».

**Copy orientado a beneficios:**

- Título: «Disfruta de estos beneficios»
- Si te fuerzan a transferir desde tu celular recuperas hasta $1.500.
- Recupera hasta $1,000 si te clonan la tarjeta.
- Si sufres secuestro exprés, recuperas hasta $600.
- Y si lo peor ocurre, como fallecimiento, tus seres queridos están protegidos hasta $3,000.

**Diseño de referencia — Variante B (móvil):**

![Variante B móvil](../assets/requerimiento/image5.png)

### 5.3 Delimitación del microfrontend

El componente a exponer como microfrontend corresponde al recuadro destacado en las capturas. Se integra dentro del onboarding **sin** tomar control del encabezado ni del marco general de la aplicación anfitriona.

| Vista                | Archivo                                                         |
| -------------------- | --------------------------------------------------------------- |
| Delimitación móvil   | ![Delimitación MFE móvil](../assets/requerimiento/image6.png)   |
| Delimitación desktop | ![Delimitación MFE desktop](../assets/requerimiento/image7.png) |

---

## 6. Requerimientos funcionales

| ID    | Requerimiento                                                                                                                                                                                  | Prioridad |
| ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| RF-01 | El microfrontend debe renderizar la pantalla de oferta del seguro embebido en versiones móvil y desktop, según el diseño de Figma de cada variante.                                            | Alta      |
| RF-02 | El sistema debe asignar a cada usuario una variante (A o B) del experimento, controlada por feature flags.                                                                                     | Alta      |
| RF-03 | La variante asignada debe permanecer persistente durante toda la navegación del usuario en el flujo.                                                                                           | Alta      |
| RF-04 | En el estado inicial, el microfrontend debe mostrar los CTA Solicitar / Omitir (móvil) y Atrás / Omitir / Solicitar (desktop).                                                                 | Alta      |
| RF-05 | Al regresar tras haber solicitado el seguro, debe mostrar el aviso «Ya solicitaste el seguro» y los CTA Continuar / Anular solicitud (móvil) y Atrás / Anular solicitud / Continuar (desktop). | Alta      |
| RF-06 | El microfrontend debe consumir un contrato de API para listar el producto (seguro) a presentar en la pantalla.                                                                                 | Alta      |
| RF-07 | La cotización seleccionada debe persistir en memoria del microfrontend durante la sesión de navegación.                                                                                        | Media     |
| RF-08 | La acción Solicitar debe registrar la intención de contratación y transicionar la pantalla al estado «solicitado».                                                                             | Alta      |
| RF-09 | La acción Anular solicitud debe revertir el estado «solicitado» al estado inicial.                                                                                                             | Media     |
| RF-10 | Las variantes deben poder activarse, desactivarse y ajustar su porcentaje de asignación mediante el administrador de feature flags, sin nuevo despliegue.                                      | Alta      |

---

## 7. Requerimientos no funcionales

| ID     | Requerimiento                                                                                | Prioridad |
| ------ | -------------------------------------------------------------------------------------------- | --------- |
| RNF-01 | Código conforme a estándares del banco; análisis estático con SonarQube.                     | Alta      |
| RNF-02 | Análisis de seguridad sobre el código del microfrontend y del backend serverless.            | Alta      |
| RNF-03 | Cobertura de pruebas unitarias según umbrales SDLC del banco (100 % en el documento origen). | Alta      |
| RNF-04 | Microfrontend responsivo; consistencia visual móvil/desktop según Figma.                     | Alta      |
| RNF-05 | La asignación de variante no debe degradar perceptiblemente el tiempo de carga.              | Media     |
| RNF-06 | Despliegue como contenido estático en bucket S3 servido vía CloudFront.                      | Alta      |
| RNF-07 | Documentar la integración de la metodología SDD + IA en la fase de desarrollo.               | Media     |

---

## 8. Arquitectura y stack tecnológico

| Capa              | Tecnología                                                                       |
| ----------------- | -------------------------------------------------------------------------------- |
| **Microfrontend** | Next.js (Pages Router) v15.x con `output: 'export'`, estático en S3 + CloudFront |
| **Estado**        | Redux — variante asignada y estado de solicitud                                  |
| **Backend**       | AWS Lambda (Node.js + TypeScript), serverless                                    |
| **IaC**           | AWS CDK                                                                          |
| **Feature flags** | Feature flag manager API                                                         |
| **Cotización**    | En memoria del microfrontend durante la sesión                                   |

---

## 9. Contratos de API y mocks

- Contrato de API para listar el producto (seguro) con coberturas y costo.
- Servicio Feature flag manager API para crear y administrar feature flags.
- Mocks de las APIs para desarrollo y pruebas independientes del microfrontend.

Ver [technical-docs/api-contracts/README.md](./technical-docs/api-contracts/README.md):

- [consultar-producto.mock.json](./technical-docs/api-contracts/consultar-producto.mock.json)
- [cotizacion.mock.json](./technical-docs/api-contracts/cotizacion.mock.json)

---

## 10. Cumplimiento SDLC + IA

- Análisis estático de código con SonarQube.
- Análisis de seguridad del código.
- Cobertura de pruebas unitarias según umbrales del banco.
- Aplicación y documentación de SDD (Specification-Driven Development) integrada con IA.

---

## 11. Precondiciones

- Diseño de Figma para móvil y web (variantes A y B); imágenes incluidas en [assets/requerimiento/](./assets/requerimiento/).
- Contrato de las APIs y mocks disponibles para el desarrollo.

---

## 12. Entregables al cierre

- Microfrontend con split A/B (variantes A y B) controladas por feature flags.
- Feature flag manager API.
- Cumplimiento SDLC + IA (SonarQube, seguridad, cobertura de pruebas).
- Explicación de la fase de desarrollo integrando SDD + IA.

---

## 13. Criterios de aceptación

| ID    | Criterio                                                                                                               | Prioridad |
| ----- | ---------------------------------------------------------------------------------------------------------------------- | --------- |
| CA-01 | Usuario en variante A ve pantalla control; usuario en variante B ve pantalla challenger (móvil y desktop).             | Alta      |
| CA-02 | La variante asignada se mantiene constante al salir y regresar en la misma sesión o en ingresos posteriores.           | Alta      |
| CA-03 | Los CTA cambian correctamente entre estado inicial y estado «solicitado».                                              | Alta      |
| CA-04 | El porcentaje de asignación entre variantes puede modificarse desde el administrador de feature flags sin redesplegar. | Alta      |
| CA-05 | El microfrontend pasa SonarQube, análisis de seguridad y umbral de cobertura de pruebas.                               | Alta      |
| CA-06 | Despliegue correcto como sitio estático en S3 + CloudFront.                                                            | Media     |
| CA-07 | La cotización se almacena en Redux para que el host conozca si el cliente aceptó o no el seguro ofertado.              | Media     |

---

## Observaciones

- La imagen `image8.png` en assets corresponde al paquete original del DOCX; no se referencia explícitamente en el texto extraído. Conservada por trazabilidad.
- El umbral de cobertura del documento origen (100 %) puede diferir del ADR-005 del repositorio (≥ 80 % ramas). Resolver en planificación de tareas si aplica.
