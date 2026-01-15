Rails.application.routes.draw do
  resources :client_price_lists
  resources :box_purchase_order_payments
  resources :account_expenses
  resources :payment_currencies
  resources :payment_type_bank_accounts
  resources :desposit_payments
  resources :check_payments
  resources :bank_accounts
  resources :deposits
  resources :devolutions
  resources :proformas
#   resources :products do
#   collection { post :import }
# end
  resources :items_suppliers
  resources :box_users
  resources :checks
  resources :banks
  resources :box_details
  resources :boxes
  resources :account_sales
  resources :presentations
  resources :setting_currency_companies
  resources :movements
  resources :price_lists
  get '/price_list_item', to: 'price_lists#price_list_item'
  get '/price_list_for_sale', to: 'price_lists#getPriceListForSale'
  resources :prices
    get '/price_item_add', to: 'prices#priceItemAdd'
  resources :receptions
  resources :stocks
  resources :purchase_order_lines_taxes
  resources :payment_terms
  resources :currency_rates
  resources :currencies
  resources :taxes
  resources :accounts
  resources :suppliers
  resources :payments
  get '/get_payment_pdf', to: 'payments#getPaymentsPdf'
  get '/get_payment_range_pdf', to: 'payments#getPaymentsRangePdf'
  
  resources :payment_types
  resources :addresses
  resources :provinces 
   get '/provincia_zonas', to: 'provinces#getZonas'
  resources :avenidas
  resources :zonas
  get '/zona_avenidas', to: 'zonas#getAvenidas'
  resources :departamentos  
   get '/departamento_provincias', to: 'departamentos#getProvincias'
  resources :user_modulos
  resources :modulos
  resources :rols
  resources :inventory_items
  resources :inventories
  resources :contacts
  resources :clients
  get '/clients_sales_pdf', to: 'clients#new_sales_pdf'
  get '/clients_to_payment_pdf', to: 'clients#to_payment_pdf'
  get '/clients_payments_pdf', to: 'clients#new_payments_pdf'
  get '/mySales', to: 'clients#my_sales'
  get '/my_payments', to: 'clients#my_payments'
  get '/to_payments', to: 'clients#to_payments'
  get '/to_invocings', to: 'clients#to_invocing' 
  get '/clients_to_invoiced_pdf', to: 'clients#to_invocing_pdf'
  resources :warehouses
  resources :companies
  resources :countries
   get '/to_country/:id', to: 'countries#report_sales'
   get '/country_departamentos', to: 'countries#getDepartamentos'
  resources :sales do
    resources :sale_details
  end
  get '/change_discount_sale_detail',  to: 'sale_details#changeDiscountSaleDetails'  
  resources :purchase_orders do
  resources :purchase_order_lines
 end
  get '/getpurchase_order', to: 'purchase_orders#getQty'
	 get '/brands_suggestion', to: 'brands_suggestion#index'
   get '/validate_suggested_brand', to: 'validate_suggested_brand#index'
  resources :items do
  collection { post :import }
 end
  resources :towns
  resources :units
  resources :categories
  resources :brands
  devise_for :users
  resources :users
  get '/items_view_list', to: 'items#items_view_list'
  get '/items_view_kamback', to: 'items#items_view_kamback'
  get 'home/index'
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  get '/items_suggestion', to: 'items_suggestion#index'
  get '/validate_suggested_item', to: 'validate_suggested_item#index'
  get '/validate_suggested_item_purchase', to: 'validate_suggested_item#purchase_item_suggested'
  
  get '/validate_country', to: 'countries#validate'
  get '/stocks_validate_qty', to: 'stocks#validate'

  # obtener cliente en las ventas
   get '/clients_get_client', to: 'clients#cliente_sale'
   get '/sale_set_penalty', to: 'sales#set_penalty'
   get '/sale_set_canceled', to: 'sales#set_canceled'
   get '/prices_get_price_list', to: 'price_lists#price_list_price'

   get '/sales_suggestion', to: 'sales_suggestion#index'
   get '/validate_suggested_sale', to: 'validate_suggested_sale#index'
  # add code modify by hot discounts remy
   get '/suggested_saldo_by_discount', to: 'validate_suggested_sale#saldo'

   get '/prices_select', to: 'prices#myprice'
   get '/myclients', to: 'clients#myclients'
   get '/mysuppliers', to: 'suppliers#mysuppliers'

   get '/validate_account_currency', to: 'accounts#currency'
   get 'items_pdf', to: 'items#new_pdf'
   get 'sale_details_sale', to: 'sales#sale_details'
   get '/payment_pdf', to: 'payments#recibo'
end
