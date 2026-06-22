# Ofertas complementarias durante la creación de cuenta de ahorros

## Objetivo

Mostrar al cliente una pantalla de selección de productos complementarios antes de finalizar la creación de una cuenta de ahorros, permitiéndole contratar servicios adicionales de manera opcional.

## Descripción

Una vez que el cliente complete los datos requeridos para la apertura de la cuenta de ahorros y antes de mostrar la confirmación final, el sistema deberá presentar una pantalla con productos y servicios complementarios disponibles para contratación.

La pantalla deberá permitir seleccionar uno o varios productos mediante casillas de verificación y continuar con el flujo de apertura de cuenta.

## Diseño de Referencia

[Pantalla de ofertas complementarias](servicios-cuenta.png)
<img
  src="servicios-cuenta.png"
  alt="Pantalla de ofertas complementarias"
  width="300"
/>

## Criterios de Aceptación

### CA-01: Visualización de la pantalla

**Dado** que el cliente ha completado exitosamente el formulario de apertura de cuenta
**Cuando** avance al siguiente paso
**Entonces** el sistema deberá mostrar la pantalla de ofertas complementarias.

### CA-02: Selección opcional

**Dado** que el cliente visualiza la pantalla
**Cuando** no seleccione ningún producto
**Entonces** deberá poder continuar con el proceso normalmente.

### CA-03: Selección múltiple

**Dado** que el cliente visualiza la pantalla
**Cuando** seleccione uno o más productos
**Entonces** el sistema deberá registrar las selecciones para ser procesadas durante la apertura de la cuenta.

### CA-04: Continuación del flujo

**Dado** que el cliente ha realizado o no selecciones
**Cuando** presione el botón **Continuar**
**Entonces** el sistema deberá avanzar al siguiente paso del proceso de apertura de cuenta.

### CA-05: Persistencia de selección

**Dado** que el cliente seleccionó productos adicionales
**Cuando** finalice exitosamente la apertura de la cuenta
**Entonces** las contrataciones seleccionadas deberán quedar asociadas a la nueva cuenta según las reglas de negocio definidas.

## Reglas de Negocio

* La contratación de productos complementarios es opcional.
* El cliente puede seleccionar más de un producto.
* Los productos mostrados deben ser configurables desde el catálogo de productos del banco.
* Los costos y condiciones deben mostrarse actualizados al momento de la consulta.
* La ausencia de selección no debe impedir la apertura de la cuenta.

## Flujo

1. Cliente completa datos de apertura.
2. Sistema muestra pantalla de ofertas complementarias.
3. Cliente selecciona productos opcionales.
4. Cliente presiona **Continuar**.
5. Sistema registra las selecciones.
6. Sistema continúa con la confirmación y apertura de la cuenta.
