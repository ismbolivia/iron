# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2026_04_09_235506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "account_expenses", force: :cascade do |t|
    t.integer "account_id"
    t.decimal "amount"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "expense_type", default: 0
    t.integer "expense_category", default: 0
  end

  create_table "account_sales", force: :cascade do |t|
    t.integer "account_id"
    t.integer "sale_id"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "account_transfers", force: :cascade do |t|
    t.integer "from_account_id"
    t.integer "to_account_id"
    t.decimal "amount", precision: 12, scale: 2
    t.decimal "exchange_rate", precision: 12, scale: 4, default: "1.0"
    t.text "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "from_box_id"
    t.integer "to_box_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.integer "currency_id"
    t.string "code"
    t.boolean "deprecated"
    t.string "internal_type"
    t.boolean "reconcile"
    t.text "note"
    t.integer "user_id"
    t.integer "company_id"
    t.integer "create_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.integer "departamento_id"
    t.integer "province_id"
    t.integer "zona_id"
    t.integer "avenida_id"
    t.string "calles"
    t.float "coordenadas"
    t.string "description"
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "avenidas", force: :cascade do |t|
    t.string "name"
    t.integer "zona_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.integer "bank_id"
    t.string "number"
    t.string "titular"
    t.integer "currency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banks", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "box_details", force: :cascade do |t|
    t.integer "box_id"
    t.string "payment_id"
    t.decimal "amount"
    t.integer "state"
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "box_purchase_order_payments", force: :cascade do |t|
    t.integer "box_id"
    t.integer "purchase_order_id"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "box_users", force: :cascade do |t|
    t.integer "box_id"
    t.integer "user_id"
    t.integer "acction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "boxes", force: :cascade do |t|
    t.string "user_id"
    t.string "name"
    t.text "description"
    t.string "currency_id"
    t.integer "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "branch_id"
    t.integer "box_type", default: 0
    t.string "code"
    t.integer "parent_box_id"
    t.index ["branch_id"], name: "index_boxes_on_branch_id"
    t.index ["parent_box_id"], name: "index_boxes_on_parent_box_id"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_branches_on_company_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "country_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pictures"
  end

  create_table "check_payments", force: :cascade do |t|
    t.integer "check_id"
    t.integer "payment_type_id"
    t.decimal "rode"
    t.integer "state"
    t.integer "sale_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checks", force: :cascade do |t|
    t.string "bank_id"
    t.integer "number"
    t.date "date_giro"
    t.date "date_payment"
    t.string "titular"
    t.decimal "amount"
    t.string "currency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "client_price_lists", force: :cascade do |t|
    t.integer "client_id"
    t.integer "price_list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "mobile"
    t.string "email"
    t.string "web_site"
    t.integer "price_list_id"
    t.integer "asig_a_user_id"
    t.string "nit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo"
    t.integer "state"
    t.integer "user_id"
    t.integer "address_id"
    t.float "saldo"
    t.integer "discount"
    t.float "credit_limit"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "sigla"
    t.string "nit"
    t.string "email"
    t.string "phone"
    t.string "company_registration"
    t.string "report_footer"
    t.boolean "mycompany"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logo"
    t.index ["country_id"], name: "index_companies_on_country_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "job"
    t.string "email"
    t.string "mobile"
    t.string "nit"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile"
    t.index ["client_id"], name: "index_contacts_on_client_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "phone_code"
    t.string "initials"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.decimal "rounding"
    t.boolean "active"
    t.string "currency_unit_label"
    t.string "currency_subunit_label"
    t.integer "create_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currency_rates", force: :cascade do |t|
    t.date "name"
    t.decimal "rate"
    t.integer "currency_id"
    t.integer "company_id"
    t.integer "create_uid"
    t.integer "currency_ref"
    t.boolean "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departamentos", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deposits", force: :cascade do |t|
    t.integer "bank_account_id"
    t.integer "client_id"
    t.decimal "rode"
    t.string "depositante"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "desposit_payments", force: :cascade do |t|
    t.string "payment_id"
    t.string "deposit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devolutions", force: :cascade do |t|
    t.integer "sale_id"
    t.integer "sale_detail_id"
    t.decimal "qty", precision: 15, scale: 3
    t.decimal "mount"
    t.text "obs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gastos_importaciones", force: :cascade do |t|
    t.integer "importacion_id"
    t.string "description"
    t.decimal "amount", precision: 12, scale: 2
    t.integer "gasto_type"
    t.integer "prorrateo_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "etapa"
    t.index ["importacion_id"], name: "index_gastos_importaciones_on_importacion_id"
  end

  create_table "importaciones", force: :cascade do |t|
    t.string "name"
    t.integer "state", default: 0
    t.string "container_type"
    t.date "eta_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pricing_logic"
  end

  create_table "inventories", force: :cascade do |t|
    t.string "ref"
    t.string "name_company"
    t.string "name_warehouse"
    t.string "ref_warehouse"
    t.integer "warehouse_id"
    t.decimal "quantity", precision: 15, scale: 3
    t.float "sales_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", default: 0
  end

  create_table "inventory_items", force: :cascade do |t|
    t.integer "inventory_id"
    t.integer "item_id"
    t.string "code_item"
    t.string "name_item"
    t.string "description_item"
    t.decimal "quantity_product", precision: 15, scale: 3
    t.float "price_purchase_total"
    t.float "price_sale_total"
    t.float "variance"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "physical_quantity", precision: 15, scale: 3
    t.decimal "quantity_variance", precision: 15, scale: 3
  end

  create_table "items", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.bigint "brand_id"
    t.bigint "unit_id"
    t.bigint "category_id"
    t.integer "stock"
    t.integer "min_stock"
    t.decimal "price", precision: 8, scale: 2
    t.decimal "cost", precision: 8, scale: 2
    t.integer "discount"
    t.boolean "active"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "warehouse_id"
    t.string "image"
    t.boolean "todiscount"
    t.boolean "sold"
    t.boolean "bought"
    t.decimal "weight_kg", precision: 10, scale: 4, default: "0.0"
    t.decimal "volume_m3", precision: 10, scale: 6, default: "0.0"
    t.index ["brand_id"], name: "index_items_on_brand_id"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["unit_id"], name: "index_items_on_unit_id"
    t.index ["warehouse_id"], name: "index_items_on_warehouse_id"
  end

  create_table "items_suppliers", force: :cascade do |t|
    t.integer "item_id"
    t.integer "supplier_id"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modulos", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.string "color", default: "btn btn-icons-navbar fcbtn  fcbtn  btn-primary btn-outline btn-1c", null: false
    t.string "icon", default: "fas fa-gem", null: false
    t.boolean "installed"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movements", force: :cascade do |t|
    t.decimal "qty_in", precision: 15, scale: 3
    t.decimal "qty_out", precision: 15, scale: 3
    t.integer "sale_detail_id"
    t.integer "stock_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "description"
  end

  create_table "payment_currencies", force: :cascade do |t|
    t.integer "currency_id"
    t.integer "payment_type_id"
    t.integer "sale_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_terms", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.text "note"
    t.integer "company_id"
    t.integer "create_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_type_bank_accounts", force: :cascade do |t|
    t.integer "payment_type_id"
    t.integer "bank_account_id"
    t.decimal "monto"
    t.integer "sale_id"
    t.integer "state"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_types", force: :cascade do |t|
    t.string "nethod"
    t.text "description"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "sale_id"
    t.integer "payment_type_id"
    t.decimal "rode"
    t.integer "num_payment"
    t.integer "discount"
    t.integer "state", default: 1
    t.decimal "saldo"
    t.integer "account_id"
    t.integer "bank_account_id"
    t.integer "check_payment_id"
    t.integer "payment_type_bank_accounts_id"
    t.integer "payment_currency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.integer "box_id"
    t.text "audit_note"
    t.decimal "commission_amount", precision: 12, scale: 2, default: "0.0"
    t.boolean "commission_paid", default: false
  end

  create_table "presentations", force: :cascade do |t|
    t.string "name"
    t.decimal "qty", precision: 15, scale: 3
    t.integer "unit_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_presentation"
    t.integer "parent_id"
    t.decimal "qty_in_parent", precision: 15, scale: 3
  end

  create_table "price_lists", force: :cascade do |t|
    t.string "name"
    t.decimal "utilidad"
    t.integer "state"
    t.date "date"
    t.integer "company_id"
    t.integer "user_uid"
    t.boolean "default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "list_type", default: 0
  end

  create_table "prices", force: :cascade do |t|
    t.string "name"
    t.decimal "price_purchase"
    t.decimal "utility"
    t.decimal "price_sale"
    t.integer "active"
    t.integer "item_id"
    t.integer "price_list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "opex_margin"
    t.decimal "comp_1_price"
    t.decimal "comp_2_price"
    t.decimal "comp_3_price"
  end

  create_table "proformas", force: :cascade do |t|
    t.integer "number"
    t.integer "sale_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "provinces", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.integer "departamento_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_order_lines", force: :cascade do |t|
    t.string "name"
    t.decimal "item_qty", precision: 12, scale: 4, default: "0.0"
    t.date "date_planned"
    t.integer "item_id"
    t.decimal "price_unit", precision: 8, scale: 4
    t.float "price_tax"
    t.integer "company_id"
    t.integer "state"
    t.decimal "qty_received", precision: 12, scale: 4, default: "0.0"
    t.integer "purchase_order_id"
    t.boolean "to_prices"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "discount"
  end

  create_table "purchase_order_lines_taxes", force: :cascade do |t|
    t.integer "purchase_order_line_id"
    t.integer "tax_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.string "name"
    t.date "date_order"
    t.integer "supplier_id"
    t.integer "currency_id"
    t.integer "state"
    t.text "note"
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "origen"
    t.date "date_aroved"
    t.date "date_planned"
    t.decimal "amount_untaxed"
    t.decimal "amount_tax"
    t.decimal "amount_total"
    t.integer "payment_term_id"
    t.integer "create_uid"
    t.integer "company_id"
    t.integer "importacion_id"
    t.index ["importacion_id"], name: "index_purchase_orders_on_importacion_id"
  end

  create_table "receptions", force: :cascade do |t|
    t.decimal "qty_in", precision: 12, scale: 4, default: "0.0"
    t.integer "total"
    t.date "fecha"
    t.text "ob"
    t.integer "warehouse_id"
    t.integer "user_id"
    t.integer "company_id"
    t.integer "purchase_order_line_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repackings", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "warehouse_id"
    t.integer "origin_stock_id"
    t.bigint "user_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_repackings_on_item_id"
    t.index ["user_id"], name: "index_repackings_on_user_id"
    t.index ["warehouse_id"], name: "index_repackings_on_warehouse_id"
  end

  create_table "rols", force: :cascade do |t|
    t.string "name"
    t.integer "permision"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sale_details", force: :cascade do |t|
    t.integer "sale_id"
    t.integer "number"
    t.integer "item_id"
    t.decimal "qty", precision: 15, scale: 3
    t.decimal "price"
    t.integer "discount"
    t.integer "price_id"
    t.decimal "price_sale"
    t.integer "priority"
    t.boolean "todiscount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "presentation_id"
  end

  create_table "sales", force: :cascade do |t|
    t.integer "number"
    t.date "date"
    t.integer "state"
    t.integer "user_id"
    t.integer "discount"
    t.boolean "credit"
    t.integer "discount_total"
    t.date "credit_expiration"
    t.boolean "penalty"
    t.integer "number_sale"
    t.integer "invoiced"
    t.boolean "canceled"
    t.boolean "completed"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
    t.integer "status_priority", default: 99
    t.string "payment_status_cache"
    t.integer "priority"
    t.boolean "show_bs", default: false
    t.bigint "branch_id"
    t.text "observation_note"
    t.datetime "observed_at"
    t.integer "observed_by_user_id"
    t.text "resolution_note"
    t.index ["branch_id"], name: "index_sales_on_branch_id"
    t.index ["client_id"], name: "index_sales_on_client_id"
    t.index ["observed_by_user_id"], name: "index_sales_on_observed_by_user_id"
  end

  create_table "setting_currency_companies", force: :cascade do |t|
    t.integer "company_id"
    t.integer "currency_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_adjustments", force: :cascade do |t|
    t.integer "warehouse_id"
    t.integer "item_id"
    t.string "adjustment_type"
    t.decimal "quantity", precision: 15, scale: 3
    t.string "reason"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stock_id"
    t.integer "purchase_order_line_id"
    t.integer "presentation_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.decimal "qty_in", precision: 12, scale: 4, default: "0.0"
    t.decimal "qty_out", precision: 12, scale: 4, default: "0.0"
    t.decimal "total", precision: 12, scale: 4, default: "0.0"
    t.integer "item_id"
    t.integer "warehouse_id"
    t.integer "purchase_order_line_id"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "presentation_id"
    t.string "lote"
    t.date "expiration_date"
    t.integer "repacking_id"
    t.index ["presentation_id"], name: "index_stocks_on_presentation_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "display_name"
    t.integer "is_company"
    t.integer "address_id"
    t.string "nit"
    t.integer "job_id"
    t.string "phone"
    t.string "mobile"
    t.string "email"
    t.string "web_syte"
    t.text "description"
    t.integer "company_id"
    t.integer "create_uid"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "imagesupplier"
  end

  create_table "taxes", force: :cascade do |t|
    t.string "name"
    t.string "type_tax_use"
    t.boolean "tax_adjustement"
    t.string "amount_type"
    t.boolean "active"
    t.integer "company_id"
    t.decimal "amount"
    t.integer "account_id"
    t.integer "refund_account_id"
    t.text "description"
    t.boolean "price_include"
    t.string "include_base_amount"
    t.boolean "analytic"
    t.string "tax_exigible"
    t.integer "cash_basis_account"
    t.integer "create_uid"
    t.integer "write_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "towns", force: :cascade do |t|
    t.string "name"
    t.integer "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transfer_details", force: :cascade do |t|
    t.bigint "transfer_id"
    t.bigint "item_id"
    t.decimal "quantity"
    t.string "observation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "purchase_order_line_id"
    t.integer "presentation_id"
    t.index ["item_id"], name: "index_transfer_details_on_item_id"
    t.index ["transfer_id"], name: "index_transfer_details_on_transfer_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.bigint "origin_branch_id"
    t.bigint "destination_branch_id"
    t.date "date"
    t.integer "state"
    t.bigint "user_id"
    t.text "observations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "origin_warehouse_id"
    t.integer "destination_warehouse_id"
    t.index ["destination_branch_id"], name: "index_transfers_on_destination_branch_id"
    t.index ["origin_branch_id"], name: "index_transfers_on_origin_branch_id"
    t.index ["user_id"], name: "index_transfers_on_user_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "allow_decimals", default: false
  end

  create_table "user_modulos", force: :cascade do |t|
    t.integer "user_id"
    t.integer "modulo_id"
    t.boolean "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.string "name"
    t.integer "rol_id"
    t.string "initials"
    t.bigint "branch_id"
    t.decimal "commission_rate", precision: 10, scale: 2, default: "0.0"
    t.string "phone"
    t.string "mobile"
    t.index ["branch_id"], name: "index_users_on_branch_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "warehouses", force: :cascade do |t|
    t.string "ref"
    t.string "name"
    t.string "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.bigint "branch_id"
    t.index ["branch_id"], name: "index_warehouses_on_branch_id"
  end

  create_table "zonas", force: :cascade do |t|
    t.string "name"
    t.integer "province_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "day"
  end

  add_foreign_key "boxes", "boxes", column: "parent_box_id"
  add_foreign_key "boxes", "branches"
  add_foreign_key "branches", "companies"
  add_foreign_key "companies", "countries"
  add_foreign_key "contacts", "clients"
  add_foreign_key "items", "brands"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "units"
  add_foreign_key "items", "warehouses"
  add_foreign_key "repackings", "items"
  add_foreign_key "repackings", "users"
  add_foreign_key "repackings", "warehouses"
  add_foreign_key "sales", "branches"
  add_foreign_key "sales", "clients"
  add_foreign_key "stocks", "presentations"
  add_foreign_key "transfer_details", "items"
  add_foreign_key "transfer_details", "transfers"
  add_foreign_key "transfers", "branches", column: "destination_branch_id"
  add_foreign_key "transfers", "branches", column: "origin_branch_id"
  add_foreign_key "transfers", "users"
  add_foreign_key "users", "branches"
  add_foreign_key "warehouses", "branches"
end
