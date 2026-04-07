module PurchasesV2
  class ImportingService
    def initialize(importacion)
      @importacion = importacion
    end

    # Calcula el Costo Landed Unitario de todos los productos agrupados
    # Retorna un Array de Hashes con el desglose por línea de órden de compra
    def calculate_landed_costs
      total_fob = @importacion.total_fob
      total_vol = @importacion.total_volume_m3
      total_weight = @importacion.total_weight_kg

      # Acumulador de costos extras prorrateados de cada línea: { line_id => monto_total_gastos }
      added_costs = {}

      @importacion.gastos_importaciones.each do |gasto|
        monto_gasto = gasto.amount.to_f
        metodo = gasto.prorrateo_method.to_s

        @importacion.purchase_orders.each do |po|
          po.purchase_order_lines.each do |line|
            factor = 0.0

            case metodo
            when 'por_fob'
              line_fob = line.item_qty.to_f * line.price_unit.to_f
              factor = line_fob / total_fob if total_fob > 0
            when 'por_volumen'
              line_vol = (line.item&.volume_m3 || 0).to_f * line.item_qty.to_f
              factor = line_vol / total_vol if total_vol > 0
            when 'por_peso'
              line_weight = (line.item&.weight_kg || 0).to_f * line.item_qty.to_f
              factor = line_weight / total_weight if total_weight > 0
            else # directo u otros
              # Si es directo, se podría dividir equivalentemente por cantidad total de ítems
              # de forma igualitaria o proporcional. Por defecto prorrateamos por FOB si no hay match claro.
              line_fob = line.item_qty.to_f * line.price_unit.to_f
              factor = line_fob / total_fob if total_fob > 0
            end

            gasto_linea = monto_gasto * factor
            added_costs[line.id] ||= 0.0
            added_costs[line.id] += gasto_linea
          end
        end
      end

      # 2. Construir matriz de costos finales por línea
      desglose = []
      @importacion.purchase_orders.each do |po|
        po.purchase_order_lines.each do |line|
          qty = line.item_qty.to_f
          costo_fob_unit = line.price_unit.to_f
          gasto_extra_total = added_costs[line.id] || 0.0
          gasto_extra_unit = qty > 0 ? (gasto_extra_total / qty) : 0.0

          desglose << {
            line_id: line.id,
            item_id: line.item_id,
            item_code: line.item&.code,
            item_name: line.item&.name,
            qty: qty,
            costo_fob: costo_fob_unit,
            gasto_extra_unit: gasto_extra_unit,
            costo_landed: costo_fob_unit + gasto_extra_unit,
            gasto_total_linea: gasto_extra_total
          }
        end
      end
      desglose
    end
  end
end
