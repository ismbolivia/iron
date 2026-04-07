
Rails.application.routes.draw do
  resources :branches do
    member do
      get :warehouses
    end
  end
  resources :transfer_details
  resources :transfers do
    member do
      patch :send_transit
      patch :receive
    end
  end
  resources :client_price_lists
  resources :box_purchase_order_payments
  resources :account_expenses
  resources :account_transfers, only: [:new, :create]
  resources :payment_currencies
  resources :payment_type_bank_accounts
  resources :desposit_payments
  resources :check_payments
  resources :bank_accounts
  resources :deposits
  resources :devolutions
  resources :proformas
  resources :premium_sales do
    member do
      post :add_item
      post :remove_item
    end
  end
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
  resources :price_lists do
    collection do
      get :get_category_rows
    end
    member do
      get :builder
      post :toggle_item
      post :toggle_category_items
      get :price_list_item
      patch :toggle_state
    end
  end
  get '/price_list_for_sale', to: 'price_lists#getPriceListForSale'
  resources :prices
    get '/price_item_add', to: 'prices#priceItemAdd'
  resources :receptions
  resources :stocks do
    member do
      get :print_label
    end
  end
  resources :stock_adjustments, only: [:create, :new, :destroy]
  resources :purchase_order_lines_taxes
  resources :payment_terms
  resources :currency_rates
  resources :currencies
  resources :taxes
  resources :accounts
  resources :suppliers
  resources :payments do
    member do
      post :approve
      post :reject
    end
  end
  get '/get_payment_pdf', to: 'payments#getPaymentsPdf'
  get '/get_payment_range_pdf', to: 'payments#getPaymentsRangePdf'
  get '/payments_pos_search', to: 'payments#pos_search'
  get '/sales_portfolio_report', to: 'sales_reports#portfolio'
  get '/sales_profitability_report', to: 'sales_reports#profitability'
  
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
  resources :inventories do
    member do
      patch :apply
      get :download_template
      post :upload_template
    end
  end
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
  resources :warehouses do
    member do
      post 'transfer_item', to: 'warehouses#transfer_item', as: 'transfer_item'
    end
  end
  resources :companies
  resources :countries
   get '/to_country/:id', to: 'countries#report_sales'
   get '/country_departamentos', to: 'countries#getDepartamentos'
  resources :sales do
    resources :sale_details
    member do
      get :note_sale
      get :dispatch_note
      post :observe
      post :confirm_observed
    end
  end
  get '/change_discount_sale_detail',  to: 'sale_details#changeDiscountSaleDetails'  
  resources :purchase_orders do
    member do
      post :confirm_reception
    end
    resources :purchase_order_lines
  end
  get '/getpurchase_order', to: 'purchase_orders#getQty'
	 get '/brands_suggestion', to: 'brands_suggestion#index'
   get '/validate_suggested_brand', to: 'validate_suggested_brand#index'
  resources :items do
    collection { post :import }
    member do
      get :available_lots
      get :print_available_stocks
    end
  end
  resources :towns
  resources :units
  resources :categories do
    collection do
      get :workspace
      post :assign_items
      post :update_item_field
    end
  end
  resources :brands
  devise_for :users
  resources :users
  get 'pos', to: 'pos#index'
  get 'pos/search_products', to: 'pos#search_products'
  get 'pos/search_clients', to: 'pos#search_clients'
  post 'pos/process_sale', to: 'pos#process_sale'
  
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
   get 'reports/sales_by_period', to: 'reports#sales_by_period'
   get 'reports/purchase_predictions', to: 'reports#purchase_predictions'
   get 'reports/purchase_prediction_item', to: 'reports#purchase_prediction_item'

   # Modulo de Compras V2 - Aislado según Plan
   namespace :purchases_v2 do
     get 'dashboard', to: 'dashboard#index'
     get 'dashboard/search_items', to: 'dashboard#search_items'
     get 'dashboard/add_item_row', to: 'dashboard#add_item_row'
     post 'dashboard/generate_draft', to: 'dashboard#generate_draft'
     resources :imports do
       collection do
         post :create_from_purchase_order
       end
       member do
         post :add_expense
         delete :remove_expense
         post :update_prices
         post :add_purchase_order
         delete :remove_purchase_order
         post :update_item_dims
         post :update_price_margins
         post :update_state
         post :confirm_reception
       end
     end
      resources :repackings, only: [:new, :create, :index, :show]
      resources :receptions, only: [:new, :create, :show] do
        member do
          get :print_labels
        end
      end
   end
end
