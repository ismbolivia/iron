class Report
 def initialize(data_init, data_limit, current_user, current_box )
    @data_init = data_init
    @data_limit = data_limit
    @current_user = current_user
    @box = current_box
  
  end
  def date_by_range
  	boxes_details = [] 
  	 if @data_init.present?
  	 	if @data_limit.present?
        if @data_init == @data_limit
          boxes_details = condition_range_to_day
        else
  	 			boxes_details = condition_range_date
        end
  	 	end
  	 	
  	 end
  	 boxes_details
  end
  private
  def condition_range_date
    boxes_details = @box.box_details.where(:created_at=> @data_init..@data_limit).order(:created_at) 
  end
  def condition_range_to_day
     boxes_details = @box.box_details.where("created_at = ?", @data_init).order(:created_at) 
  end

end