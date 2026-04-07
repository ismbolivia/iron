class PurchasesV2::ReceptionsController < ApplicationController
  before_action :set_purchase_order, only: [:new, :print_labels]

  def new
    if Stock.where(purchase_order_line_id: @purchase_order.purchase_order_lines.pluck(:id)).any?
      return redirect_to purchase_order_path(@purchase_order), alert: "⛔ Esta orden ya ha sido recibida físicamente en inventarios."
    end
    @warehouses = Warehouse.all
  end

  def create
    @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
    
    begin
      ActiveRecord::Base.transaction do
        params[:items].each do |item_id, data|
          next if data[:entries].blank?

          po_line = @purchase_order.purchase_order_lines.find_by(item_id: item_id)
          
          # Actualizar costos y precios (se toma del ítem general o de la primera entrada)
          if po_line
            po_line.update!(
              price_unit: data[:price_unit].to_f,
              discount: data[:discount].to_f
            )

            if data[:price_id].present?
              Price.find(data[:price_id]).update!(
                price_purchase: po_line.final_cost,
                utility: data[:utility_pct].to_f,
                price_sale: data[:price_sale].to_f
              )
            end
          end

          total_qty_item = 0

          # Procesar cada desglose (Cajas, Paquetes, etc.)
          data[:entries].each do |entry|
            qty_input = entry[:qty].to_f
            next if qty_input <= 0

            factor = 1.0
            if entry[:presentation_id].present?
              presentation = Presentation.find(entry[:presentation_id])
              factor = presentation.qty.to_f if presentation
            end
            
            qty_base_unit = qty_input * factor
            total_qty_item += qty_base_unit
            
            warehouse_id = entry[:warehouse_id].presence || Warehouse.first.id
            lote_code = entry[:lote].presence || "AUTO-#{Time.now.to_i}"
            
            Stock.create!(
              item_id: item_id,
              warehouse_id: warehouse_id,
              qty_in: qty_base_unit,
              qty_out: 0,
              purchase_order_line_id: po_line&.id,
              state: :disponible,
              presentation_id: entry[:presentation_id],
              lote: lote_code
            )

            Movement.create!(
              qty_in: qty_base_unit,
              qty_out: 0,
              stock_id: Stock.last.id
            )
          end

          # Registrar la Recepción general para este ítem
          if po_line && total_qty_item > 0
            Reception.create!(
              purchase_order_line_id: po_line.id,
              qty_in: total_qty_item,
              warehouse_id: data[:entries].first[:warehouse_id].presence || Warehouse.first.id,
              fecha: Date.current,
              ob: "Recepción V2 multi-presentación"
            )
            
            # Actualizar estado de la línea
            po_line.qty_received # dispara calculo
            po_line.update!(state: (po_line.item_qty > po_line.qty_received ? 'parcial' : 'asignado'))
          end
        end
        @purchase_order.update!(state: 'confirmed')
      end

      # Redirigir directamente a la impresión de etiquetas después del éxito
      redirect_to print_labels_purchases_v2_reception_path(@purchase_order), notice: "✅ Recepción Exitosa. Generando etiquetas..."
    rescue => e
      redirect_to new_purchases_v2_reception_path(purchase_order_id: @purchase_order.id), alert: "Error en la recepción: #{e.message}"
    end
  end

  def print_labels
    @stocks = Stock.where(purchase_order_line_id: @purchase_order.purchase_order_lines.pluck(:id))
    
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Etiquetas_#{@purchase_order.name}",
               template: "purchases_v2/receptions/print_labels.pdf.erb",
               encoding: 'UTF-8',
               page_size: 'Letter',
               margin: { top: 10, bottom: 10, left: 10, right: 10 }
      end
    end
  end

  private

  def set_purchase_order
    @purchase_order = PurchaseOrder.find(params[:id] || params[:purchase_order_id])
  end
end
