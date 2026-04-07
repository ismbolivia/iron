module PurchasesV2
  class IntelligenceService
    def self.analyze_rotation(supplier_id = nil, months = 1.5, limit = 50, item_id = nil)
      months = months.to_f > 0 ? months.to_f : 1.5
      limit = limit.to_i > 0 ? limit.to_i : 50
      
      # Determinamos las fechas para los periodos
      d1_start = 1.day.ago.to_date
      d7_start = 7.days.ago.to_date
      d30_start = 30.days.ago.to_date
      d90_start = 90.days.ago.to_date
      d180_start = 180.days.ago.to_date
      d365_start = 365.days.ago.to_date
      
      current_year = Date.today.year
      current_month = Date.today.month.to_f
      y0, y1, y2, y3 = current_year, current_year - 1, current_year - 2, current_year - 3

      valid_priorities = [1, 2, 3, 4, 5]

      # Query optimizada: stock y precio_last como subconsultas para evitar Cartesian products y N+1
      query = Item.select(
                    "items.id",
                    "items.name",
                    "items.description",
                    "items.stock",
                    "(SELECT COALESCE(SUM(qty_in - qty_out), 0) FROM stocks WHERE stocks.item_id = items.id) AS calculated_stock",
                    "(SELECT price_unit FROM purchase_order_lines WHERE purchase_order_lines.item_id = items.id ORDER BY created_at DESC LIMIT 1) AS last_purchase_price",
                    "COALESCE(SUM(CASE WHEN sales.date >= '#{d1_start}' THEN sale_details.qty ELSE 0 END), 0) AS qty_1d",
                    "COALESCE(SUM(CASE WHEN sales.date >= '#{d7_start}' THEN sale_details.qty ELSE 0 END), 0) AS qty_7d",
                    "COALESCE(SUM(CASE WHEN sales.date >= '#{d30_start}' THEN sale_details.qty ELSE 0 END), 0) AS qty_30d",
                    "COALESCE(SUM(CASE WHEN sales.date >= '#{d90_start}' THEN sale_details.qty ELSE 0 END), 0) AS qty_90d",
                    "COALESCE(SUM(CASE WHEN sales.date >= '#{d180_start}' THEN sale_details.qty ELSE 0 END), 0) AS qty_180d",
                    "COALESCE(SUM(CASE WHEN sales.date >= '#{d365_start}' THEN sale_details.qty ELSE 0 END), 0) AS qty_365d",
                    "COALESCE(SUM(CASE WHEN EXTRACT(YEAR FROM sales.date) = #{y0} THEN sale_details.qty ELSE 0 END), 0) AS year_0_qty",
                    "COALESCE(SUM(CASE WHEN EXTRACT(YEAR FROM sales.date) = #{y1} THEN sale_details.qty ELSE 0 END), 0) AS year_1_qty",
                    "COALESCE(SUM(CASE WHEN EXTRACT(YEAR FROM sales.date) = #{y2} THEN sale_details.qty ELSE 0 END), 0) AS year_2_qty",
                    "COALESCE(SUM(CASE WHEN EXTRACT(YEAR FROM sales.date) = #{y3} THEN sale_details.qty ELSE 0 END), 0) AS year_3_qty"
                  )
                  .joins("LEFT JOIN units ON units.id = items.unit_id")
                  .joins("LEFT JOIN categories ON categories.id = items.category_id")
                  .joins("LEFT JOIN sale_details ON sale_details.item_id = items.id")
                  .joins("LEFT JOIN sales ON sales.id = sale_details.sale_id AND sales.status_priority IN (#{valid_priorities.join(',')})")
                  .group("items.id, items.name, items.description, items.stock, categories.name, items.priority, units.name")
                  .select("categories.name AS category_name", "items.priority AS item_priority", "units.name AS unit_name")
                  .order("categories.name ASC, items.priority ASC")

      if item_id.present?
        query = query.where(id: item_id)
      elsif supplier_id.present?
        query = query.joins(:items_suppliers).where(items_suppliers: { supplier_id: supplier_id })
      end
      
      # Limitamos directamente en SQL para evitar procesar toda la DB
      items_data = query.limit(limit).to_a

      items_data.map do |item|
        # Priorizamos el cálculo de la tabla stocks (qty_in - qty_out)
        stock_val = (item.attributes['calculated_stock'] || item.stock || 0).to_i
        
        data = {
          id: item.id,
          name: item.name,
          stock_actual: stock_val,
          last_price: item.attributes['last_purchase_price'].to_f,
          qty_1d: item.qty_1d.to_f,
          qty_7d: item.qty_7d.to_f,
          qty_30d: item.qty_30d.to_f,
          qty_90d: item.qty_90d.to_f,
          qty_180d: item.qty_180d.to_f,
          qty_365d: item.qty_365d.to_f,
          hist_yr_0_qty: item.year_0_qty.to_f,
          hist_yr_0_avg: (item.year_0_qty.to_f / current_month),
          hist_yr_1_qty: item.year_1_qty.to_f,
          hist_yr_1_avg: (item.year_1_qty.to_f / 12.0),
          hist_yr_2_qty: item.year_2_qty.to_f,
          hist_yr_2_avg: (item.year_2_qty.to_f / 12.0),
          hist_yr_3_qty: item.year_3_qty.to_f,
          hist_yr_3_avg: (item.year_3_qty.to_f / 12.0),
          category_name: item.attributes['category_name'],
          unit_name: item.attributes['unit_name'],
          priority: item.attributes['item_priority'],
          years: [y0, y1, y2, y3]
        }

        # Cálculo de Inteligencia de Abastecimiento (Lógica Ponderada)
        recent_speed = data[:qty_30d]
        curr_year_speed = data[:hist_yr_0_avg]
        prev_year_speed = data[:hist_yr_1_avg]
        
        weighted_monthly_speed = (recent_speed * 0.5) + (curr_year_speed * 0.3) + (prev_year_speed * 0.2)
        target_stock = weighted_monthly_speed * months
        suggested = [0, (target_stock - data[:stock_actual])].max
        
        # Cálculo de días restantes de stock
        daily_speed = weighted_monthly_speed / 30.0
        days_remaining = daily_speed > 0 ? (data[:stock_actual] / daily_speed).to_i : 999
        is_critical = days_remaining < 15 # Alerta si queda menos de 15 días de stock
        
        data.merge(
          suggested_qty: suggested.round, 
          coverage_months: months, 
          days_remaining: days_remaining, 
          is_critical: is_critical
        )
      end
    end
  end
end
