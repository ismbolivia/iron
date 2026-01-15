class BoxesController < ApplicationController
  before_action :set_box, only: [:show, :edit, :update, :destroy]
  before_action :set_combo_values, only: [:new, :edit, :update, :create]
  before_action :set_index, only: [:show]
    load_and_authorize_resource
  # GET /boxes
  # GET /boxes.json
  def index
    @boxes = Box.all
  end

  # GET /boxes/1
  # GET /boxes/1.json
  def show
    @title = "Ingresos y salidas de la  "+@box.name
    if @mystate == "input"
      @title = "Ingresos a la  "+@box.name
    end
      if @mystate == "output"
      @title = "Salidas de la  "+@box.name
    end
    
    @url_pdfs = "/boxes/"+@box.id.to_s+".pdf?data_init="+@data_init.to_s+"&data_limit="+(@data_limit.to_date+1).to_s+"&state="+ @mystate.to_s

    respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'boxes/report', 
          pdf: 'pdf',
          title: 'Reporte de etradas salidas',
          # orientation: 'Landscape',
          page_size: 'Letter',
          print_media_type: true,          
          header: {
          html: {
            template: 'layouts/partials/pdf_header'
          }
         },
          footer: {
          html: {
            template: 'layouts/partials/pdf_header',
          }
        }
     
        }
        
       end 
  end
  
  # GET /boxes/new
  def new
    @box = Box.new
    @currencies = Currency.all

    

  end

  # GET /boxes/1/edit
  def edit
  end

  # POST /boxes
  # POST /boxes.json
  def create
    @box = Box.new(box_params)
    @box.user_id = current_user.id 
    @box.active = true
    respond_to do |format|
      if @box.save
        format.html { redirect_to @box, notice: 'Box was successfully created.' }
        format.json { render :show, status: :created, location: @box }
      else
        format.html { render :new }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boxes/1
  # PATCH/PUT /boxes/1.json
  def update
    respond_to do |format|
      if @box.update(box_params)
        format.html { redirect_to @box, notice: 'Box was successfully updated.' }
        format.json { render :show, status: :ok, location: @box }
      else
        format.html { render :edit }
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boxes/1
  # DELETE /boxes/1.json
  def destroy
    @box.destroy
    respond_to do |format|
      format.html { redirect_to boxes_url, notice: 'Box was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
     def set_index
       @data_init = params[:data_init].try(:to_date) || 30.days.ago.to_date
       @data_limit = params[:data_limit].try(:to_date) || Date.current
       @mystate =  params[:state]
       ranges = (@data_init..@data_limit)
       # report = Report.new(@data_init, @data_limit, current_user, @box)
       if @mystate.present?
         @box_details_rage=@box.box_details.where(state: @mystate).where(created_at: ranges).order(created_at: :desc)
         
       else         
       @box_details_rage = @box.box_details.where(created_at: ranges).order(created_at: :desc)        
       end
      @column_data = @box.box_details.states.keys.map do |state|
        { name: state.capitalize, data: group_by_period(@box.box_details.where(state: state),ranges).sum(:amount) }
        end
      @pie_chart = @box.box_details.where(created_at: ranges).group(:state).sum(:amount)
    end

    def group_by_period(data, ranges)
        diff = @data_limit - @data_init
        if diff< 31
          data.group_by_day(:created_at, range: ranges, format: "%b %d")
        elsif diff < 91
           data.group_by_week(:created_at, range: ranges, format: Proc.new {|date| format_week_label(date)})
         else
           data.group_by_month(:created_at, range: ranges, format:"%b %Y")
        end
    end
    def format_week_label(date)
        start_date = date.to_date
        end_date = start_date + 6
        label = "#{start_date.strftime('%b %d')} -" 
        label += start_date.month == end_date.month ? end_date.strftime('%d') : end_date.strftime('%b %d')
      label
    end

    def set_box
      @box = Box.find(params[:id])
    end
    def set_combo_values
   @currencies = Currency.all
  
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def box_params
      params.require(:box).permit(:user_id, :name, :description, :currency_id, :active)
    end
end
