module DraftCleaner
  extend ActiveSupport::Concern

  def clean_old_drafts(model_class, user_scope_column = :user_id)
    # Define the condition for finding drafts
    # Standardize on 'draft' state if possible, or accept it as an argument?
    # For now, let's assume 'draft' is the state key
    
    condition = { state: 'draft' }
    
    # Add user scope if applicable
    if user_scope_column.present? && current_user.present?
       # Check if model has the column. Sale uses 'user', PurchaseOrder uses 'create_uid'
       # so we pass the column name
       condition[user_scope_column] = current_user.id
    end

    unsaved_records = model_class.where(condition)
    
    # Avoid deleting drafts generated from external modules (e.g. Inteligencia de Compras)
    if model_class.column_names.include?('origen')
      unsaved_records = unsaved_records.where(origen: [nil, ''])
    end
    
    unsaved_records.each do |record|
      # Sale has specific logic to destroy details, PurchaseOrder relies on dependent: :destroy
      if record.respond_to?(:destroy_sale_details_all)
          record.destroy_sale_details_all
      end
      record.destroy
    end
  end
end
