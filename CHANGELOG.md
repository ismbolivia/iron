# Changelog

## [Unreleased]

### Fixed
- **Core**: Corregido error ortográfico en el enum de `PurchaseOrderLine`, cambiando `:recivido` por `:recibido`. Actualizadas todas las referencias en controladores y vistas para mantener la compatibilidad.

### Changed
- **Sales**: Implementada transacción de base de datos (`ActiveRecord::Base.transaction`) en `SaleDetailsController#create`. Esto asegura que la creación del detalle de venta y el descuento de stock sean atómicos (se guardan ambos o ninguno), previniendo inconsistencias en el inventario.
- **Inventory**: Agregado bloqueo pesimista (`lock(true)`) al consultar stocks disponibles (`to_discount`). Esto previene condiciones de carrera donde dos ventas simultáneas podrían intentar descontar del mismo lote de stock, causando inventarios negativos o corruptos.
- **Performance**: Optimización menor en `SaleDetailsController` para buscar detalles existentes usando `find_by` en lugar de iterar sobre toda la colección.
