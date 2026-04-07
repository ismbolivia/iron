class AddTypeAndCategoryToAccountExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :account_expenses, :expense_type, :integer, default: 0
    add_column :account_expenses, :expense_category, :integer, default: 0
  end
end
