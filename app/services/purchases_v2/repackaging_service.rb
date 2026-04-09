module PurchasesV2
  class RepackagingService
    def initialize(params, user)
      @stock_id = params[:stock_id]
      @item_id = params[:item_id]
      @warehouse_id = params[:warehouse_id]
      @entries = params[:entries] || []
      @auto_adjust = params[:auto_adjust_diff] == 'true' || params[:auto_adjust_diff] == true
      @adjustment_reason = params[:adjustment_reason]
      @user = user
    end

    def process!
      # 1. Buscar el stock de origen
      @origin_stock = Stock.find(@stock_id)
      @item = Item.find(@item_id)
      
      # 2. Calcular balance total (considerando todos los movimientos del mismo lote)
      @related_stocks = Stock.where(
        item_id: @item_id,
        warehouse_id: @warehouse_id,
        presentation_id: @origin_stock.presentation_id,
        purchase_order_line_id: @origin_stock.purchase_order_line_id,
        lote: @origin_stock.lote
      )
      
      available_qty = @related_stocks.sum { |s| s.qty_in.to_f - s.qty_out.to_f }.round(2)
      
      new_total_qty = 0
      @entries.each do |entry|
        qty = entry[:qty].to_f
        factor = 1.0
        if entry[:presentation_id].present?
          pres = Presentation.find(entry[:presentation_id])
          factor = pres.qty.to_f
        end
        new_total_qty += (qty * factor)
      end

      # 3. Cálculo de Diferencia
      diff = available_qty - new_total_qty
      has_diff = diff.abs > 0.0001

      # Validación: Si hay diferencia y NO se marcó el auto_adjust, lanzamos error
      if has_diff && !@auto_adjust
        raise "Error de Cuadre: El stock original (#{available_qty} pzs) no coincide con la nueva clasificación (#{new_total_qty} pzs). Por favor, activa el ajuste automático o corrige las cantidades."
      end

      # Validación: Si hay diferencia y se marcó auto_adjust, DEBE haber un motivo
      if has_diff && @auto_adjust && @adjustment_reason.blank?
        raise "Es obligatorio seleccionar un MOTIVO para el ajuste por descuadre."
      end

      # 4. Transacción Atómica
      ActiveRecord::Base.transaction do
        # Crear el registro maestro de la sesión de Re-empaque
        @repacking = Repacking.create!(
          item_id: @item_id,
          warehouse_id: @warehouse_id,
          origin_stock_id: @origin_stock.id,
          user_id: @user&.id,
          notes: @adjustment_reason
        )

        # A. Si hay diferencia y se autorizó el ajuste, realizamos el ajuste previo
        if has_diff && @auto_adjust
          # Creamos el StockAdjustment para que quede registrado oficialmente
          adj_type = diff > 0 ? 'salida' : 'entrada'
          adj_qty = diff.abs
          
          # Nota: Aquí usamos el factor 1 porque la diferencia ya está en unidades base (piezas)
          adjustment = StockAdjustment.create!(
            item_id: @item_id,
            warehouse_id: @warehouse_id,
            quantity: adj_qty, # En piezas sueltas
            adjustment_type: adj_type,
            reason: "AUTO-AJUSTE EN RE-EMPAQUE: #{@adjustment_reason}",
            user_id: @user&.id,
            purchase_order_line_id: @origin_stock.purchase_order_line_id
          )
          
          # Actualizamos el available_qty que usaremos para el movimiento de re-empaque
          available_qty = new_total_qty
        end

        # B. Vaciar el stock de origen del lote completo (Todos los registros relacionados)
        @related_stocks.each do |s|
          # Setteamos qty_out igual a qty_in para dejar el saldo de cada registro en cero
          s.update!(qty_out: s.qty_in, state: :agotado)
        end
        
        # C. Registrar movimiento de salida en Kardex (consolidado)
        Movement.create!(
          stock_id: @origin_stock.id,
          qty_out: available_qty,
          qty_in: 0,
          user_id: @user&.id,
          description: "Salida por Re-empaque / Clasificación Final de Lote (Saldo Consolidado)"
        )

        # C. Crear los nuevos registros de Stock por cada presentación
        @entries.each do |entry|
          qty = entry[:qty].to_f
          factor = 1.0
          if entry[:presentation_id].present?
            pres = Presentation.find(entry[:presentation_id])
            factor = pres.qty.to_f
          end
          
          base_qty = qty * factor
          
          # Creamos el nuevo registro de Stock heredando el Lote y Fecha de Vencimiento
          new_stock = Stock.create!(
            item_id: @item_id,
            warehouse_id: @warehouse_id,
            qty_in: base_qty,
            qty_out: 0,
            presentation_id: entry[:presentation_id],
            purchase_order_line_id: @origin_stock.purchase_order_line_id,
            lote: @origin_stock.lote,
            expiration_date: @origin_stock.expiration_date,
            repacking_id: @repacking.id,
            state: :disponible
          )

          # Movimiento de entrada en Kardex con descripción y usuario
          Movement.create!(
            stock_id: new_stock.id,
            qty_in: base_qty,
            qty_out: 0,
            user_id: @user&.id,
            description: "Entrada por Re-empaque: #{entry[:presentation_id].present? ? Presentation.find(entry[:presentation_id]).name : 'Unidades Sueltas'}"
          )
        end
      end
      
      { success: true, message: "Lote re-clasificado exitosamente." }
    rescue => e
      { success: false, message: e.message }
    end
  end
end
