class AddAuditNoteToPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :audit_note, :text
  end
end
