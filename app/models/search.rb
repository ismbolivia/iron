class Search

  def initialize(page, page_size, keywords, current_user , data_condition, filter)
    @page = page
    @page_size = page_size
    @offset = page_size * page
    @keywords = keywords
    @current_user = current_user
    @data_condition = data_condition
    @filter = filter
  end

  def inventories_by_ref
    if @keywords.present?
       inventories = Inventory.where(ref_condition).order(:ref).offset(@offset).limit(@page_size)
       @number_of_records = Inventory.where(ref_condition).count
    else
       inventories = Inventory.order(:ref).offset(@offset).limit(@page_size)
       @number_of_records = Inventory.count
    end
      return inventories, number_of_pages
  end
  def inventory_items_by_name
    if @keywords.present?
       inventory_items = InventoryItem.where(name_item_condition).order(:name_item).offset(@offset).limit(@page_size)
       @number_of_records = InventoryItem.where(name_item_condition).count
    else
       inventory_items = InventoryItem.order(:name_item).offset(@offset).limit(@page_size)
        @number_of_records = InventoryItem.count
    end
      return inventory_items, number_of_pages
  end

def brands_by_name
    if @keywords.present?
        brands = Brand.where(name_condition).order(:name).offset(@offset).limit(@page_size)
        @number_of_records = Brand.where(name_condition).count
      else
        brands = Brand.order(:name).offset(@offset).limit(@page_size)
        @number_of_records = Brand.count
      end
      
      return brands, number_of_pages
  end
  def payments_by_num
    payments_query = Payment.joins(:sale)
    payments_query = payments_query.where(sales: { user_id: @current_user.id }) unless @current_user.is_admin?

    if @keywords.present?
      # Intentar buscar por número de pago o referencia de factura (si aplica)
      payments_query = payments_query.where("CAST(payments.num_payment AS TEXT) LIKE ?", "%#{@keywords}%")
    end

    @number_of_records = payments_query.count
    payments = payments_query.order(created_at: :desc).offset(@offset).limit(@page_size)

    return payments, number_of_pages
  end

  def categories_by_name
    if @keywords.present?
        categories = Category.where(name_condition).order("unaccent(lower(name)) ASC").offset(@offset).limit(@page_size)
        @number_of_records = Category.where(name_condition).count
      else
        categories = Category.order("unaccent(lower(name)) ASC").offset(@offset).limit(@page_size)
        @number_of_records = Category.count
      end
      
      return categories, number_of_pages
  end
  
  def units_by_name
   if @keywords.present?
     units = Unit.where(name_condition).order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Unit.where(name_condition).count
   else
     units = Unit.order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Unit.count
   end
 
   return units, number_of_pages
 end

 # code for search items by description
  def items_by_description
    base = Item.left_outer_joins(:category)
    if @keywords.present?
        items = base.where(description_condition).order("categories.name ASC, items.priority ASC, items.name ASC").offset(@offset).limit(@page_size)
        @number_of_records = base.where(description_condition).count
      else
        items = base.where(active: true).order("categories.name ASC, items.priority ASC, items.description ASC").offset(@offset).limit(@page_size)
        @number_of_records = base.where(active:true).count
      end
      
      return items, number_of_pages
  end
  def price_list_item_by_name(pl)
    if @keywords.present?
        pattern = "%#{I18n.transliterate(@keywords.downcase)}%"
        items =  pl.items.where("items.active = ? AND unaccent(lower(items.name)) LIKE ?", true, pattern).order(:name).offset(@offset).limit(@page_size)
        @number_of_records = pl.items.where("items.active = ? AND unaccent(lower(items.name)) LIKE ?", true, pattern).count
      else
        items = pl.items.where(active: true).order(:name).offset(@offset).limit(@page_size)
        @number_of_records = pl.items.where(active:true).count
      end
      
      return items, number_of_pages
  end
 # -------------------------------------------------------------where('identifier LIKE ?', pattern)
  def users_by_description
    if @keywords.present?
        users = User.where(name_condition).order(:name).offset(@offset).limit(@page_size)
        @number_of_records = Item.where(name_condition).count
      else
        users = User.order(:name).offset(@offset).limit(@page_size)
        @number_of_records = User.count
      end
      
      return users, number_of_pages
  end
 
 def towns_by_name
   if @keywords.present?
     towns = Town.where(name_condition).order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Town.where(name_condition).count
   else
     towns = Town.order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Town.count
   end
 
   return towns, number_of_pages
 end

  def countries_by_name
   if @keywords.present?
     countries = Country.where(name_condition).order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Country.where(name_condition).count
   else
     countries = Country.order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Country.count
   end
 
   return countries, number_of_pages
 end

def companies_by_name
   if @keywords.present?
     companies = Company.where(name_condition).order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Company.where(name_condition).count
   else
     companies = Company.order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Company.count
   end
 
   return companies, number_of_pages
 end

 def warehouse_by_name
   if @keywords.present?
      warehouses = Warehouse.where(name_condition).order(:name).offset(@offset).limit(@page_size)
      @number_of_records = Warehouse.where(name_condition).count
   else
     warehouses = Warehouse.order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Warehouse.count
   end
 
   return warehouses, number_of_pages
 end

  def clients_by_name
    if @current_user.rol.permision >= 6
       if @keywords.present?
        clients = Client.where(state: true).where(name_condition).order(:name).offset(@offset).limit(@page_size)
        @number_of_records = Client.where( state: true).where(name_condition).count
      else
       clients = Client.where(state: true). order(:name).offset(@offset).limit(@page_size)
       @number_of_records = Client.count
     end
  else
    if @keywords.present?
      clients = Client.where( state: true, asig_a_user_id: @current_user.id).where(name_condition).order(:name).offset(@offset).limit(@page_size)
      @number_of_records = Client.where( state: true, asig_a_user_id: @current_user.id).where(name_condition).count
   else
     clients = Client.where(state: true, asig_a_user_id: @current_user.id). order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Client.count
   end
    end
   
   return clients, number_of_pages
 end

 def suppliers_by_name
   if @keywords.present?
      suppliers = Supplier.where(name_condition).order(:name).offset(@offset).limit(@page_size)
      @number_of_records = Supplier.where(name_condition).count
   else
     suppliers = Supplier.where(state: "confirmed"). order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Supplier.count
   end
 
   return suppliers, number_of_pages
 end


def purchase_order_by_name
   if @keywords.present?
      purchase_orders = PurchaseOrder.where(name_condition).order(:name).offset(@offset).limit(@page_size)
      @number_of_records = PurchaseOrder.where(name_condition).count
   else
     purchase_orders = PurchaseOrder.all. order(created_at: :desc).offset(@offset).limit(@page_size)
     @number_of_records = PurchaseOrder.count
   end
 
   return purchase_orders, number_of_pages
 end

def addresses_by_calles
   if @keywords.present?
      addresses = Address.where(calles_condition).order(:calles).offset(@offset).limit(@page_size)
      @number_of_records = Address.where(calles_condition).count
   else
     addresses = Address.order(:calles).offset(@offset).limit(@page_size)
     @number_of_records = Address.count
   end
 
   return addresses, number_of_pages
 end

 def contacts_by_name
   if @keywords.present?
      contacts = Contact.where(name_condition).order(:name).offset(@offset).limit(@page_size)
      @number_of_records = Contact.where(name_condition).count
   else
     contacts = Contact.order(:name).offset(@offset).limit(@page_size)
     @number_of_records = Contact.count
   end
 
   return contacts, number_of_pages
 end


  def sales
    sales_query = Sale.joins(:client)
    sales_query = sales_query.where(user_id: @current_user.id) unless @current_user.is_admin?

    if @filter.present?
      if Sale::PAYMENT_STATUSES.value?(@filter)
        sales_query = sales_query.where(sales: { payment_status_cache: @filter })
      elsif Sale.states.keys.include?(@filter)
        sales_query = sales_query.where(sales: { state: Sale.states[@filter] })
      end
    end

    if @keywords.present?
      pattern = "%#{I18n.transliterate(@keywords.downcase)}%"
      
      # Subquery for items to avoid Cartesian product and DISTINCT performance hit
      item_exists_subquery = <<-SQL
        EXISTS (
          SELECT 1 FROM sale_details 
          JOIN items ON items.id = sale_details.item_id 
          WHERE sale_details.sale_id = sales.id 
          AND (unaccent(lower(items.name)) LIKE :p OR unaccent(lower(items.code)) LIKE :p)
        )
      SQL

      sales_query = sales_query.where(
        "(unaccent(lower(clients.name)) LIKE :p OR " \
        "unaccent(lower(clients.nit)) LIKE :p OR " \
        "CAST(sales.number_sale AS TEXT) LIKE :p OR " \
        "#{item_exists_subquery})",
        p: pattern
      )
    end

    @number_of_records = sales_query.count
    sales = sales_query.order("sales.status_priority" => :asc, "sales.number_sale" => :desc)
                       .offset(@offset).limit(@page_size)
    return sales, number_of_pages
  end
  def mysales
    sales_query = Sale.joins(:client)
    sales_query = sales_query.where(sales: { client_id: @data_condition })
    sales_query = sales_query.where(user_id: @current_user.id) unless @current_user.is_admin?

    if @filter.present?
      if Sale::PAYMENT_STATUSES.value?(@filter)
        sales_query = sales_query.where(sales: { payment_status_cache: @filter })
      elsif Sale.states.keys.include?(@filter)
        sales_query = sales_query.where(sales: { state: Sale.states[@filter] })
      end
    end

    if @keywords.present?
      pattern = "%#{I18n.transliterate(@keywords.downcase)}%"
      
      item_exists_subquery = <<-SQL
        EXISTS (
          SELECT 1 FROM sale_details 
          JOIN items ON items.id = sale_details.item_id 
          WHERE sale_details.sale_id = sales.id 
          AND (unaccent(lower(items.name)) LIKE :p OR unaccent(lower(items.code)) LIKE :p)
        )
      SQL

      sales_query = sales_query.where(
        "(unaccent(lower(clients.name)) LIKE :p OR " \
        "unaccent(lower(clients.nit)) LIKE :p OR " \
        "CAST(sales.number_sale AS TEXT) LIKE :p OR " \
        "#{item_exists_subquery})",
        p: pattern
      )
    end

    @number_of_records = sales_query.count
    sales = sales_query.order("sales.status_priority" => :asc, "sales.number_sale" => :desc)
                       .offset(@offset).limit(@page_size)
    return sales, number_of_pages
  end

private
  def calles_condition
    ["unaccent(lower(calles)) LIKE ?", "%#{I18n.transliterate(@keywords.downcase)}%"]
  end
  def name_condition
    ["unaccent(lower(name)) LIKE ?", "%#{I18n.transliterate(@keywords.downcase)}%"]
  end

  def name_item_condition
    ["unaccent(lower(name_item)) LIKE ?", "%#{I18n.transliterate(@keywords.downcase)}%"]
  end

  def description_condition
    pattern = "%#{I18n.transliterate(@keywords.downcase)}%"
    ["unaccent(lower(code)) LIKE ? OR unaccent(lower(name)) LIKE ?", pattern, pattern]
  end



  def ref_condition
     ["unaccent(lower(ref)) LIKE ?", "%#{I18n.transliterate(@keywords.downcase)}%"]
  end
  def number_of_pages
    number_of_pages = (@number_of_records % @page_size) == 0 ? 
                          @number_of_records / @page_size - 1 : @number_of_records / @page_size
  end
end

