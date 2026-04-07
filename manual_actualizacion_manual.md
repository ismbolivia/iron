# 🚀 Manual de Actualización Manual (FIFO & Lotes)
Este documento resume los cambios realizados para blindar la trazabilidad FIFO por lote, implementar jerarquías de empaque y el desglose automático en recepciones.

---

## 🏗️ 1. Base de Datos (Crucial)
Ejecutar la siguiente migración en el servidor de intranet para habilitar la reversión de ajustes:

**Archivo:** `db/migrate/20260403002518_add_stock_id_to_stock_adjustments.rb`
```ruby
class AddStockIdToStockAdjustments < ActiveRecord::Migration[5.2]
  def change
    add_column :stock_adjustments, :stock_id, :integer
  end
end
```
*(Luego ejecutar `rails db:migrate` en la terminal del servidor)*

---

## ⚙️ 2. Modelos (Lógica de Negocio)

### **A. Stock (`app/models/stock.rb`)**
Añadir `dependent: :destroy` a movimientos:
```ruby
has_many :movements, dependent: :destroy
```

### **B. Ajuste de Stock (`app/models/stock_adjustment.rb`)**
Actualizar para capturar el `stock_id` y permitir la reversión:
```ruby
after_create :apply_stock_change
before_destroy :reverse_stock_change

def apply_stock_change
  # ... (lógica de factor de conversión) ...
  stock = Stock.create!(...)
  self.update_column(:stock_id, stock.id) # Guardar vínculo
  # ... 
end

def reverse_stock_change
  Stock.find_by(id: self.stock_id)&.destroy
end
```

### **C. Traspaso (`app/models/transfer.rb`)**
Actualizar `add_destination_stock!` para copiar `purchase_order_line_id` y `presentation_id`.

---

## 🕹️ 3. Controladores y Rutas

### **Rutas (`config/routes.rb`)**
Habilitar las acciones de "Borrado" y "Consulta":
```ruby
resources :branches do
  member { get :warehouses }
end
resources :stock_adjustments, only: [:create, :new, :destroy]
```

### **Parámetros (`app/controllers/transfers_controller.rb`)**
Permitir `origin_warehouse_id`, `destination_warehouse_id` y los IDs de lote/presentación en los detalles.

---

## 🖥️ 4. Vistas Clave (UX Modernizado)

### **A. Recepción de Compra (`app/views/purchases_v2/receptions/new.html.erb`)**
*   Botón Morado: `DESGLOSE AUTO` (Añadir lógica JS `handleAutoSplit`).
*   Selector de Presentation con clase `presentation-select`.

### **B. Lista de Artículos (`app/views/items/_results_search.html.erb`)**
Reemplazar columna de stock por el bloque de **Agrupación por Lote** (Badges).

### **C. Traspasos (`app/views/transfers/_form.html.erb`)**
Incluir selectores dinámicos de **Almacén** y filtrado automático por sucursal.

---

> [!IMPORTANT]
> Recuerda reiniciar el servidor Rails en la Intranet después de aplicar los cambios para que se cargue la nueva lógica en memoria.
