# 💎 Especificación Técnica: Módulo de Re-empaque y Clasificación de Lotes (V1)

Este documento detalla el plan de implementación para el nuevo módulo de re-clasificación de inventario en el sistema Iron, basado en el diseño **V1** aprobado por Reinaldo.

---

## 🎯 1. Objetivo General
Permitir que el usuario re-asigne la presentación (Caja, Paquete, Pieza, etc.) de un lote ya existente en stock, asegurando que la cantidad total de unidades base (piezas) permanezca inalterada (**Net-Zero Change**) y preservando la trazabilidad del lote original (FIFO).

---

## 🏗️ 2. Arquitectura de Datos (Backend)

### A. El Servicio de Re-empaque (`LotReclassificationService`)
Este servicio será el encargado de procesar la transformación.
*   **Input:** 
    *   `stock_id` (Lote de origen).
    *   `new_distributions` (Array de pares `presentation_id` y `quantity`).
*   **Proceso Atómico (Transaction):**
    1.  **Validar:** Sumar `total_base_qty` de la nueva distribución y comparar con el stock disponible del lote original.
    2.  **Salida:** Generar un movimiento de salida (`qty_out`) en el registro original de `Stock` para "vaciarlo" (o la parte que se esté re-empacando).
    3.  **Entrada:** Crear nuevos registros en la tabla `Stock` por cada nueva presentación, heredando el mismo `purchase_order_line_id`, `warehouse_id` e `item_id`.
    4.  **Kardex:** Registrar los `Movements` correspondientes vinculados a este proceso con un nuevo motivo: `Re-empaque / Clasificación`.

---

## 🖥️ 3. Interfaz de Usuario (Diseño V1)

### A. Flujo de Pantalla
1.  **Cabecera:** Selector de Ítem y Lote (POL). Muestra el **Balance Actual** en un card destacado.
2.  **Tabla de Distribución:**
    *   Fila dinámica con selector de **Presentación** y input de **Cantidad**.
    *   Columna de cálculo automático: `Cantidad * Factor de Presentación = Total Piezas`.
3.  **Barra de Validación (Footer):**
    *   Muestra la suma total de las nuevas presentaciones.
    *   Cambia a Verde cuando cuadra con el Balance de origen.
    *   Inhabilita el botón de acción si hay descuadre.

### B. Tecnología Frontend
*   **JS / jQuery:** Para la suma dinámica de filas sin recargar la página.
*   **Selección Dinámica:** Carga AJAX de lotes disponibles por almacén.

---

## 🚨 4. Reglas de Negocio Inviolables
*   **Preservación de Lote:** El ID de la recepción original (`purchase_order_line_id`) **NUNCA** cambia. Esto garantiza que el reporte de Utilidad FIFO por Lote siga siendo exacto.
*   **Inmutabilidad del Histórico:** No se borran movimientos antiguos; se crean nuevos de "Reclasificación" para dejar rastro de quién hizo el cambio y por qué.
*   **Cero Descuadre:** El sistema no aceptará ninguna distribución que sume más o menos de la cantidad original.

---

## 🚀 5. Roadmap de Despliegue al Servidor
Para cuando Reinaldo autorice la subida al servidor de intranet:
1.  **Migración:** Verificar si necesitamos una nueva columna `classification_id` o similar en la tabla `Movement` para agrupar estas operaciones.
2.  **Compilación de Assets:** Pre-compilar el JS de la tabla dinámica.
3.  **Deploy:** Copia quirúrgica de archivos del nuevo controlador y servicio.
4.  **Reinicio:** `systemctl restart iron` (o comando equivalente en intranet).

---
**Autor:** Antigravity AI  
**Aprobado por:** Reinaldo  
**Fecha:** 2026-04-04
