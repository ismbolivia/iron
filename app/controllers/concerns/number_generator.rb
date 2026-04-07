module NumberGenerator
  extend ActiveSupport::Concern

  def generate_next_number(model_class, scope_condition = {})
    # Find the maximum number in the confirmed scope
    # Sale controller logic:
    # last_sale = Sale.where(state: "confirmed", user: current_user).maximum('number')
    # number = (last_sale != nil) ? last_sale + 1 : 1
    
    # We need a flexible way to define scope.
    # For now, let's keep it simple and adaptable.
    
    query = model_class.all
    query = query.where(scope_condition) if scope_condition.present?
    
    last_number = query.maximum(:number)
    (last_number || 0) + 1
  end
end
