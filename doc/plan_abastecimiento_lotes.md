# 📂 Plan de Abastecimiento por Lote y Presentaciones Dinámicas

## 🎯 Objetivos Principales
1.  **Lotes por Recepción**: Cada ingreso (Orden de Compra / Importación) genera un lote único con su propia configuración de empaque.
2.  **Presentaciones Anidadas/Jerárquicas**: Capacidad de definir que una Caja Grande contiene N Paquetes, y que cada Paquete contiene N Piezas Base.
3.  **Venta Secuencial (FIFO)**: El sistema habilita para la venta únicamente el lote más antiguo con stock. Al agotarse, habilita automáticamente el siguiente.
4.  **Ajustes de Lote**: Los ajustes de inventario deben identificar el lote y la presentación específica para mantener la integridad de los datos.

---

## 🏗️ Estructura de Datos (Lógica de Tablas)

### 1. RECEPCIÓN (Captura de Datos)
| Lote (OC/Import.) | Presentación Mayor | Relación Interna | Presentación Menor | Unidad Base |
| :--- | :--- | :--- | :--- | :--- |
| **L-001 (Agosto)** | Caja Grande (1,0000 pz) | = 25 paq. de | Paquete (400 pz) | Pieza (Base) |
| **L-002 (Sept.)** | (Sin empaque mayor) | (Directo) | Paquete (1,500 pz) | Pieza (Base) |

### 2. ESTADO DEL ALMACÉN (Cola de Lotes)
| ID Lote | Fecha Ingreso | Estado | Configuración Activa | Stock Restante (Pzs) |
| :--- | :--- | :--- | :--- | :--- |
| **L-001** | 01/08/2026 | **HABILITADO** | Caja 10k / Paq 400 | > 0 |
| **L-002** | 15/09/2026 | **ESPERA** | Paquete 1500 | 15,000 |

---

## ⚙️ Hitos Técnicos (Pasos a Seguir)

### 🚀 Paso 1: Interfaz de Recepción Dinámica
- **Objetivo**: Modificar `purchases_v2/receptions/new.html.erb` para que el usuario pueda agregar múltiples filas de stock for un mismo ítem.
- **Jerarquías**: Añadir botón "Agregar Sub-Presentación" para anidar (Caja -> Paquete).
- **Controlador**: Actualizar el `create` para generar registros de `Presentation` al vuelo si los valores de cantidad no existen actualmente.

### 🔍 Paso 2: Filtro de Lote Activo (Venta FIFO)
- **Cerebro del Sistema**: Crear un método global en `Item` para devolver el `current_batch_available`.
- **UI Ventas**: Restringir las opciones del selector de productos para que solo muestre las presentaciones y el stock del lote habilitado.
- **Cruce Automático**: Implementar lógica para que si la venta excede el stock del lote actual, el sistema consuma el resto del siguiente lote cronológico.

### 🔧 Paso 3: Ajustes de Stock Unificados
- **Formulario de Ajuste**: Obligatoriedad de elegir el Lote (PurchaseOrderLine) y una Presentación asociada.
- **Trazabilidad**: Asegurar que cada `StockAdjustment` genere un movimiento real en la tabla `Stock` respetando las piezas base.

---

## 📋 Conclusión
Este plan garantiza que el inventario sea un reflejo exacto de la realidad física del almacén, manejando la variabilidad de empaques de los proveedores sin perder el control de costos y cantidades base.

---
**Documento Generado por:** Antigravity (AI)
**Fecha:** 2026-04-02
