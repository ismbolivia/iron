class AddPaymentStatusCacheToSales < ActiveRecord::Migration[5.2]
  def change
    add_column :sales, :payment_status_cache, :string
  end
end
