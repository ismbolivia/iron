json.extract! tax, :id, :name, :type_tax_use, :tax_adjustement, :amount_type, :active, :company_id, :amount, :account_id, :refund_account_id, :description, :price_include, :include_base_amount, :analytic, :tax_exigible, :cash_basis_account, :create_uid, :write_uid, :created_at, :updated_at
json.url tax_url(tax, format: :json)
