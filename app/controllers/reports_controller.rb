class ReportsController < ApplicationController
  def sales_by_period
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @search = params[:search]

    # Base scope: Items
    items_scope = Item.all
    if @search.present?
      # Split terms to allow flexible search (e.g. "Brocas 12" matches "Brocas HSS-G 12")
      terms = @search.split(/\s+/)
      conditions = terms.map do |term|
        "(items.name ILIKE ? OR items.code ILIKE ?)"
      end.join(" AND ")
      
      # Flatten the values (term, term) for each condition
      values = terms.flat_map { |t| ["%#{t}%", "%#{t}%"] }
      
      items_scope = items_scope.where(conditions, *values)
    end

    # We need to join with sale_details and sales to get quantities
    # and we conditional sum based on the date ranges relative to @date.
    
    # Define ranges
    day_range = @date..@date
    week_range = @date.beginning_of_week..@date.end_of_week
    month_range = @date.beginning_of_month..@date.end_of_month
    quarter_range = @date.beginning_of_quarter..@date.end_of_quarter
    
    # Semester calculation
    semester_start = @date.month <= 6 ? @date.beginning_of_year : @date.beginning_of_year + 6.months
    semester_end = semester_start + 6.months - 1.day
    semester_range = semester_start..semester_end
    
    year_range = @date.beginning_of_year..@date.end_of_year
    
    # Previous years ranges
    last_year_range = (@date - 1.year).beginning_of_year..(@date - 1.year).end_of_year
    year_minus_2_range = (@date - 2.years).beginning_of_year..(@date - 2.years).end_of_year
    year_minus_3_range = (@date - 3.years).beginning_of_year..(@date - 3.years).end_of_year

    # Build the aggregation query
    # Note: We use LEFT JOIN so we still see products with 0 sales if filtering only by product name (optional, but usually good).
    # However, if the table gets too big, maybe we only want sold items?
    # "buscar producto especifico" implies showing what matches the search.
    
    @products_data = items_scope
      .left_joins(sale_details: :sale)
      # Including both confirmed (1) and canceled (2) states as valid sales based on user feedback and system logic (paid sales can be 'canceled')
      .select(
        "items.id",
        "items.name",
        "items.code",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date = '#{@date}' THEN sale_details.qty ELSE 0 END) as qty_day",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{week_range.begin}' AND '#{week_range.end}' THEN sale_details.qty ELSE 0 END) as qty_week",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{month_range.begin}' AND '#{month_range.end}' THEN sale_details.qty ELSE 0 END) as qty_month",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{quarter_range.begin}' AND '#{quarter_range.end}' THEN sale_details.qty ELSE 0 END) as qty_quarter",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{semester_range.begin}' AND '#{semester_range.end}' THEN sale_details.qty ELSE 0 END) as qty_semester",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{year_range.begin}' AND '#{year_range.end}' THEN sale_details.qty ELSE 0 END) as qty_year",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{last_year_range.begin}' AND '#{last_year_range.end}' THEN sale_details.qty ELSE 0 END) as qty_last_year",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{year_minus_2_range.begin}' AND '#{year_minus_2_range.end}' THEN sale_details.qty ELSE 0 END) as qty_year_minus_2",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{year_minus_3_range.begin}' AND '#{year_minus_3_range.end}' THEN sale_details.qty ELSE 0 END) as qty_year_minus_3"
      )
      .group("items.id")
      .order("items.priority ASC, items.name ASC")
      
      # Determine if we paginate. For now, let's limit to 50 if no search, or paginate?
      # User didn't ask for pagination but dynamic table.
  end

  def purchase_predictions
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @search = params[:search]

    @suppliers = Supplier.all.order(:name)
    @supplier_id = params[:supplier_id]

    # Base scope: Items
    items_scope = Item.all
    
    if @supplier_id.present?
      items_scope = items_scope.joins(:suppliers).where(suppliers: { id: @supplier_id })
    end

    if @search.present?
      terms = @search.split(/\s+/)
      conditions = terms.map do |term|
        "(items.name ILIKE ? OR items.code ILIKE ? OR suppliers.name ILIKE ?)"
      end.join(" AND ")
      
      values = terms.flat_map { |t| ["%#{t}%", "%#{t}%", "%#{t}%"] }
      
      items_scope = items_scope.left_joins(:suppliers).where(conditions, *values)
    end

    @products_data = calculate_purchase_stats(items_scope, @date)
  end

  def purchase_prediction_item
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    item_scope = Item.where(id: params[:item_id])
    
    # We get a collection, but we only want the first (and only) result
    @product = calculate_purchase_stats(item_scope, @date).first
    
    if @product
      render partial: 'reports/prediction_row', locals: { product: @product, date: @date }
    else
      head :not_found
    end
  end

  private

  def calculate_purchase_stats(scope, date)
    # Define ranges
    prev_day = date - 1.day
    week_range = date.beginning_of_week..date.end_of_week
    month_range = date.beginning_of_month..date.end_of_month
    quarter_range = date.beginning_of_quarter..date.end_of_quarter
    
    semester_start = date.month <= 6 ? date.beginning_of_year : date.beginning_of_year + 6.months
    semester_end = semester_start + 6.months - 1.day
    semester_range = semester_start..semester_end
    
    year_range = date.beginning_of_year..date.end_of_year
    last_year_range = (date - 1.year).beginning_of_year..(date - 1.year).end_of_year
    year_minus_2_range = (date - 2.years).beginning_of_year..(date - 2.years).end_of_year
    year_minus_3_range = (date - 3.years).beginning_of_year..(date - 3.years).end_of_year

    scope
      .left_joins(sale_details: :sale)
      .left_joins(:suppliers)
      .select(
        "items.id",
        "items.name",
        "items.code",
        "items.stock",
        "min(items.min_stock) as min_stock",
        "string_agg(DISTINCT suppliers.name, ', ') as supplier_names",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date = '#{date}' THEN sale_details.qty ELSE 0 END) as qty_day",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{week_range.begin}' AND '#{week_range.end}' THEN sale_details.qty ELSE 0 END) as qty_week",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{month_range.begin}' AND '#{month_range.end}' THEN sale_details.qty ELSE 0 END) as qty_month",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{quarter_range.begin}' AND '#{quarter_range.end}' THEN sale_details.qty ELSE 0 END) as qty_quarter",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{semester_range.begin}' AND '#{semester_range.end}' THEN sale_details.qty ELSE 0 END) as qty_semester",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{year_range.begin}' AND '#{year_range.end}' THEN sale_details.qty ELSE 0 END) as qty_year",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{last_year_range.begin}' AND '#{last_year_range.end}' THEN sale_details.qty ELSE 0 END) as qty_last_year",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{year_minus_2_range.begin}' AND '#{year_minus_2_range.end}' THEN sale_details.qty ELSE 0 END) as qty_year_minus_2",
        "SUM(CASE WHEN sales.state IN (#{Sale.states[:confirmed]}, #{Sale.states[:canceled]}) AND sales.date BETWEEN '#{year_minus_3_range.begin}' AND '#{year_minus_3_range.end}' THEN sale_details.qty ELSE 0 END) as qty_year_minus_3"
      )
      .group("items.id")
      .order("items.priority ASC, items.name ASC")
  end
end
