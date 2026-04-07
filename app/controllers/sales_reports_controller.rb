class SalesReportsController < ApplicationController
  def portfolio
    @title = "Cartera y Análisis de Ventas"
    
    # 1. Filtros por Defecto (Parametrizables)
    @vendedor_id = params[:vendedor_id]
    @depto_id = params[:depto_id]
    @estado_pago = params[:estado_pago] || 'todas' # 'todas', 'por_cobrar', 'pagadas'
    @desde = params[:desde].present? ? params[:desde].to_date : Date.today.beginning_of_month
    @hasta = params[:hasta].present? ? params[:hasta].to_date : Date.today
    
    # 2. Consultar Ventas de origen con Eager Loading (Optimizado)
    @sales = Sale.includes(:user, :payments, :sale_details, client: { address: :departamento })
                 .where(state: [:confirmed, :canceled])
                 .where(date: @desde..@hasta)
                 .order('date ASC')
                 
    # Filtro por Vendedor
    @sales = @sales.where(user_id: @vendedor_id) if @vendedor_id.present?
    
    # Filtro por Departamento (Lugar)
    if @depto_id.present?
      @sales = @sales.joins(client: :address).where(addresses: { departamento_id: @depto_id })
    end
    
    # 3. Filtrar por Estado (Optimizado en SQL usando el cache)
    if @estado_pago == 'por_cobrar'
      @sales = @sales.where.not(payment_status_cache: ['PAGADA', 'ANULADO'])
    elsif @estado_pago == 'pagadas'
      @sales = @sales.where(payment_status_cache: 'PAGADA')
    end

    @sales_list_all = @sales.to_a 

    # 5. Totales para KPIs (Tarjetas) antes de paginar
    @total_ventas = @sales_list_all.sum { |s| s.total_final.to_f }.round(2)
    @total_pagos  = @sales_list_all.sum { |s| s.total_pagos.to_f }.round(2)
    @total_deuda  = (@total_ventas - @total_pagos).round(2)

    # 6. Paginación en memoria
    @page_size = 50
    @page = (params[:page] || 0).to_i
    @number_of_records = @sales_list_all.size
    @number_of_pages = (@number_of_records % @page_size) == 0 ? (@number_of_records / @page_size) - 1 : (@number_of_records / @page_size)
    @number_of_pages = [@number_of_pages, 0].max

    @sales_list = @sales_list_all[(@page * @page_size), @page_size] || []

    # 4. Agrupación para la planilla detallada (por Cliente) alfabéticamente
    @grouped_sales = @sales_list.group_by { |s| s.client }
                                .sort_by { |client, _| (client&.name || '').downcase }
    
    

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Extracto_Ventas_#{@desde}_#{@hasta}",
               template: 'sales_reports/portfolio.pdf.erb',
               layout: 'pdf_layout.html.erb',
               orientation: 'Portrait',
               footer: {
                 right: 'Página [page] de [topage]',
                 font_size: 9
               }
      end
    end
  end
  def profitability
    @title = "Resumen de Rentabilidad y Resultados"
    
    @desde = params[:desde].present? ? params[:desde].to_date : Date.today.beginning_of_month
    @hasta = params[:hasta].present? ? params[:hasta].to_date : Date.today
    @vendedor_id = params[:vendedor_id]

    # 1. INGRESOS: Ventas del periodo (Confirmadas)
    @sales = Sale.where(state: :confirmed, date: @desde..@hasta)
    @sales = @sales.where(user_id: @vendedor_id) if @vendedor_id.present?
    
    @total_ventas = @sales.sum { |s| s.total_final.to_f }.round(2)

    # 2. COSTO DE MERCADERÍA VENDIDA (COGS)
    @sale_details = SaleDetail.joins(:sale).where(sales: { state: :confirmed, date: @desde..@hasta })
    @sale_details = @sale_details.where(sales: { user_id: @vendedor_id }) if @vendedor_id.present?
    @total_costo_mercaderia = 0.0

    @sale_details.each do |detail|
      qty = detail.qty.to_f
      # Intentar obtener el costo de compra histórico o configurado en la lista de precios de forma segura
      price_record = detail.price_id.present? ? Price.find_by(id: detail.price_id) : nil
      costo_item = price_record.present? ? price_record.price_purchase.to_f : detail.item&.cost.to_f
      costo_item = detail.item&.cost.to_f if costo_item <= 0 # Fallback al costo base de seguridad
      @total_costo_mercaderia += qty * costo_item
    end
    @total_costo_mercaderia = @total_costo_mercaderia.round(2)

    # 3. GASTOS OPERATIVOS (GENERALES) del Periodo
    @expenses = AccountExpense.where(created_at: @desde.beginning_of_day..@hasta.end_of_day)
    @expenses = @expenses.joins(:account).where(accounts: { user_id: @vendedor_id }) if @vendedor_id.present?
    @total_gastos = @expenses.sum(:amount).to_f.round(2)
    @total_gastos_fijos = @expenses.where(expense_type: :fijo).sum(:amount).to_f.round(2)
    @total_gastos_variables = @expenses.where(expense_type: :variable).sum(:amount).to_f.round(2)
    @expenses_by_category = {}

    @expenses.each do |expense|
      cat = expense.expense_category
      @expenses_by_category[cat] ||= 0.0
      @expenses_by_category[cat] += expense.amount.to_f
    end

    # 4. BALANCE
    @utilidad_bruta = (@total_ventas - @total_costo_mercaderia).round(2)
    @utilidad_neta = (@utilidad_bruta - @total_gastos).round(2)
  end
end
