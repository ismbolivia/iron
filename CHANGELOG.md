# Changelog

## [Unreleased]

### Fixed
- **Core**: Corregido error ortográfico en el enum de `PurchaseOrderLine`, cambiando `:recivido` por `:recibido`. Actualizadas todas las referencias en controladores y vistas para mantener la compatibilidad.

### Changed
- **Sales**: Implementada transacción de base de datos (`ActiveRecord::Base.transaction`) en `SaleDetailsController#create`. Esto asegura que la creación del detalle de venta y el descuento de stock sean atómicos (se guardan ambos o ninguno), previniendo inconsistencias en el inventario.
- **Inventory**: Agregado bloqueo pesimista (`lock(true)`) al consultar stocks disponibles (`to_discount`). Esto previene condiciones de carrera donde dos ventas simultáneas podrían intentar descontar del mismo lote de stock, causando inventarios negativos o corruptos.
- **Performance**: Optimización menor en `SaleDetailsController` para buscar detalles existentes usando `find_by` en lugar de iterar sobre toda la colección.

### Optimización Warehouses y Reportes (2026-02-04)
- **Warehouses**: Implementada arquitectura de "Modal Único" (Singleton) en las vistas de acceso al almacén. Reemplaza la generación de cientos de modales ocultos por uno solo reutilizable, mejorando drásticamente el rendimiento de carga y la respuesta de la interfaz.
- **Warehouses**: Agregado script de "Limpieza Profunda" en `transfer_item.js.erb` para remover forzosamente los backdrops y clases bloqueantes (`modal-scrollable`) que causaban el congelamiento de la UI tras las transferencias.
- **Reports**: Solucionado error `Bad wkhtmltopdf's path` en `wicked_pdf`. Se actualizó la configuración para usar la ruta dinámica del binario (`Gem.bin_path`) en lugar de una ruta absoluta inexistente.
- **Reports**: Corregida la extensión del partial `pdf_header` a `.html.erb` y actualizado el controlador `WarehousesController` para referenciar explícitamente los templates `.pdf.erb` y `.html.erb`, resolviendo problemas de renderizado de PDFs.
