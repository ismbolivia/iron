class AddOrigenToPurchaseOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :purchase_orders, :origen, :string
    add_column :purchase_orders, :date_aroved, :date
    add_column :purchase_orders, :date_planned, :date
    add_column :purchase_orders, :amount_untaxed, :decimal
    add_column :purchase_orders, :amount_tax, :decimal
    add_column :purchase_orders, :amount_total, :decimal
    add_column :purchase_orders, :payment_term_id, :integer
    add_column :purchase_orders, :create_uid, :integer
    add_column :purchase_orders, :company_id, :integer
       
  end
end
