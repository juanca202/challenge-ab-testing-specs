# Glosario — Seguro embebido A/B Testing

| Término                                    | Definición                                                                                                                                                   |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **MFE / Microfrontend**                    | Componente de la pantalla de oferta del seguro embebido, integrable en el onboarding de cuentas de ahorro online del host.                                   |
| **Variante A (control)**                   | Pantalla actual del seguro embebido, sin cambios de copy ni layout.                                                                                          |
| **Variante B (challenger)**                | Variante experimental con banner promocional y copy orientado a beneficios en segunda persona.                                                               |
| **Feature flag**                           | Mecanismo que asigna y persiste la variante A o B; configurable sin redespliegue.                                                                            |
| **Estado inicial**                         | Seguro no solicitado. CTA móvil: Solicitar / Omitir. CTA desktop: Atrás / Omitir / Solicitar.                                                                |
| **Estado solicitado**                      | Usuario ya solicitó el seguro. Aviso «Ya solicitaste el seguro». CTA móvil: Continuar / Anular solicitud. CTA desktop: Atrás / Anular solicitud / Continuar. |
| **Cotización**                             | Registro en memoria (Redux) de la intención de contratación; el host consulta si el cliente aceptó u omitió el seguro.                                       |
| **`systemCode`**                           | Identificador del widget: `BB_WIDGET_SEGUROS_CTA`.                                                                                                           |
| **`associatedProduct` / `contextProduct`** | Producto bancario asociado (p. ej. cuenta de ahorros).                                                                                                       |
