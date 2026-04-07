class PosController < ApplicationController
  # Layout especial para POS (pantalla completa, sin sidebar si es posible)
  layout 'application' 

  def index
    # Cargamos productos para la vista inicial
    @categories = Category.all
    # Loaded addresses for the new client modal
    @addresses = Address.all.limit(50)
    # Only load items assigned to current user for initial performance
    @clients = Client.where(asig_a_user_id: current_user.id).limit(20) 
    
    # Load data for helper dropdowns in manual address creation
    @countries = Country.all
    @users_for_assignment = User.all.order(:name)
    # @mycompany is set by ApplicationController
    @default_country = @mycompany&.country || Country.find_by(name: 'Bolivia') || Country.first
    
    if @default_country
      @departamentos = @default_country.departamentos
      @default_departamento = @departamentos.find_by(name: 'Cochabamba') || @departamentos.first
      
      if @default_departamento
        @provinces = @default_departamento.provinces
        @default_province = @provinces.find_by(name: 'Cercado') || @provinces.first
        
        if @default_province
           @zonas = @default_province.zonas
           @default_zona = @zonas.first
        else
           @zonas = [] 
        end
      else
        @provinces = []
        @zonas = []
      end
      @departamentos = Departamento.all
      @provinces = []
      @zonas = []
    end 
    
    # Get Exchange Rate (USD to BOB)
    # Assuming primary currency is USD (ID 1) and ref is BOB (ID 2)
    @currency_rate_obj = CurrencyRate.where(currency_id: 1, currency_ref: 2, state: true).first
    @exchange_rate = @currency_rate_obj&.rate || 6.97
    
    # Logic for Editing Sale
    if params[:sale_id].present?
      @sale = Sale.find(params[:sale_id])
      # Validate permissions or ownership if needed
      
      @client_edit = @sale.client
      
      # Prepare cart items
      @cart_items_data = @sale.sale_details.map do |sd|
        item = sd.item
        {
          id: item.id,
          name: item.name,
          price: sd.price.to_f, # Original base price
          qty: sd.qty,
          discount: sd.discount,
          stock: item.get_total_stock, # Current stock
          unit: (item.unit.name rescue ''),
          image: (item.image.url(:medium) rescue nil)
        }
      end.to_json
      
      @sale_edit_data = {
          id: @sale.id,
          date: @sale.date,
          credit_expiration: @sale.credit_expiration,
          discount: @sale.discount_total, # Global discount
          credit: @sale.credit,
          show_bs: @sale.show_bs,
          type: @sale.state # 'quoted' or 'confirmed'
      }.to_json
    end
  end

  def search_clients
    term = params[:term]
    clients = Client.where(asig_a_user_id: current_user.id) # Solo mis clientes
    
    if term.present?
      clients = clients.where("name ILIKE ?", "%#{term}%")
    end
    
    render json: clients.limit(20).includes(:sales => {:sale_details => :devolutions}, address: [:country, :departamento, :province, :zona, :avenida]).map { |c| 
      {
        id: c.id, 
        name: c.name,
        phone: c.phone,
        mobile: c.mobile,
        address: (c.address.get_direccion_cli rescue ''),
        credit_limit: c.credit_limit,
        credit_available: c.line_credit_available,
        discount: c.discount
      }
    }
  end

  # API endpoint para buscar productos vía AJAX
  def search_products
    term = params[:term]
    category_id = params[:category_id]
    
    # Removemos chequeo estricto de stock > 0 por ahora para depuración
    # products = Item.where("stock > 0") 
    products = Item.all
    
    if term.present?
      products = products.where("name ILIKE ? OR code ILIKE ?", "%#{term}%", "%#{term}%")
    end
    
    if category_id.present?
      products = products.where(category_id: category_id)
    end
    
    # Limitamos
    products = products.limit(50)
    
    # Mapeamos manual para asegurar datos correctos
    products_json = products.map do |p|
      # Lote activo filtrado por sucursal (si aplica)
      branch_id = current_user&.branch_id
      active_lot_data = p.available_lots_data.select do |l| 
        # Si no hay sucursal en el usuario, mostramos todo. Si hay, filtramos.
        s = Stock.find(l[:stock_id])
        branch_id.blank? || s.warehouse&.branch_id == branch_id
      end.first

      {
        id: p.id,
        name: p.name, 
        price: p.price_default, 
        stock: p.get_stock_by_branch(branch_id), 
        active_lot_stock: active_lot_data ? active_lot_data[:qty_available] : 0,
        available_lots: p.available_lots_data, 
        has_adjustment: p.has_adjustment,
        has_repacking: p.has_repacking,
        code: p.code,
        category_id: p.category_id,
        unit: (p.unit.name rescue ''), 
        image_url: (p.image.url(:medium) rescue nil), 
        todiscount: p.todiscount,
        # Priorizamos mostrar las presentaciones que realmente tienen stock en lotes
        presentations: p.presentations.order(qty: :desc).map { |pr| { id: pr.id, name: pr.name, qty: pr.qty, price: pr.price.to_f } }
      }
    end
    
    render json: products_json
  end

  def process_sale
    ActiveRecord::Base.transaction do
      type = params[:type] # 'sale' or 'quote'
      state = (type == 'quote') ? :quoted : :confirmed
      
      # Generar número de venta (solo para confirmed)
      number_sale = nil
      if state == :confirmed
         # last_sale = Sale.where(state: "confirmed").maximum('number_sale')
         # number_sale = (last_sale || 0) + 1
         # Usamos el mismo cálculo que SalesController si es posible, o simplificado:
         last_sale_all = Sale.where(state: "confirmed").maximum('number_sale')
         number_sale = (last_sale_all || 0) + 1
      elsif state == :quoted
         last_quote = Sale.where(state: "quoted").maximum('number_sale')
         number_sale = (last_quote || 0) + 1
      end

      # Validar credit expiration
      credit_expiration = params[:credit_expiration]
      if params[:credit].to_s == 'false' || params[:credit].blank?
        credit_expiration = Date.today
      end

      if params[:sale_id].present?
         # UPDATE EXISTING SALE
         @sale = Sale.find(params[:sale_id])
         
         # 1. Restore Stock (Destroy old details)
         # Using model method that handles stock restoration if confirmed
         @sale.destroy_sale_details_all 
         
         # 2. Update Attributes
         @sale.update!(
            client_id: params[:client_id],
            date: params[:date] || Date.today,
            credit_expiration: credit_expiration,
            state: state,
            branch_id: current_user.branch_id,
            discount: params[:discount].to_f || 0,
            discount_total: (params[:discount].to_f || 0).to_i,
            show_bs: params[:show_bs] == 'true' || params[:show_bs] == true,
            credit: params[:credit]
         )
      else
          # CREATE NEW SALE
          @sale = Sale.create!(
            user: current_user,
            client_id: params[:client_id],
            date: params[:date] || Date.today,
            credit_expiration: credit_expiration,
            state: state,
            branch_id: current_user.branch_id,
            number: (Sale.maximum(:number) || 0) + 1,
            number_sale: number_sale, 
            discount: params[:discount].to_f || 0,
            discount_total: (params[:discount].to_f || 0).to_i, 
            show_bs: params[:show_bs] == 'true' || params[:show_bs] == true,
            credit: params[:credit]
          )
      end

      # Crear Detalles y Descontar Stock
      if params[:items].present?
        # params[:items] puede venir como hash {"0"=>...}
        items = params[:items].respond_to?(:values) ? params[:items].values : params[:items]
        
        items.each_with_index do |item_data, index|
            item = Item.find(item_data[:id])
            is_todiscount = item.todiscount

            # Force discount to 0 if item is not discountable
            discount_val = is_todiscount ? (item_data[:discount].to_f || 0) : 0
            
            qty_val = item_data[:qty].to_f
            price_val = item_data[:price].to_f
            presentation_id = item_data[:presentation_id]
            
            # If a presentation is selected, we MUST convert to raw units (pieces) 
            # for SaleDetail consistency and correct inventory deduction.
            if presentation_id.present?
                pres = Presentation.find_by(id: presentation_id)
                if pres && pres.qty.to_i > 0
                    actual_units_per_box = pres.qty.to_f
                    qty_val = qty_val * actual_units_per_box
                    price_val = price_val / actual_units_per_box # Store as unit price
                end
            end

            detail = @sale.sale_details.create!(
                item_id: item_data[:id],
                qty: qty_val,
                price: price_val,
                price_sale: (price_val * (1 - (discount_val / 100))).round(4), 
                discount: discount_val,
                number: index + 1,
                todiscount: is_todiscount, 
                presentation_id: presentation_id,
                priority: 1 # Default
            )
            
            # SOLO descontar si es venta confirmada
            # El descuento se hace automáticamente al llamar a recalculate_stock_fifo al final
        end
      end

      # Al finalizar la creación/actualización de todos los detalles, procesamos el stock de una sola vez
      if state == :confirmed
        @sale.recalculate_stock_fifo
      elsif @sale.annulled? || @sale.draft?
        @sale.restore_all_stock
      end

      # Crear Proforma si es venta confirmada
      if state == :confirmed
        Proforma.create!(sale: @sale)
      end
    end
    
    render json: { success: true, sale_id: @sale.id }
  rescue => e
    render json: { success: false, error: e.message }, status: 500
  end
end
