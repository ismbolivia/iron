class SalesController < ApplicationController
   before_action :set_sale, only: [:create, :show, :edit, :update, :destroy]
   before_action :set_combo_values, only: [:new, :edit, :update, :create]
    before_action :set_index, only: [:index]
    PAGE_SIZE = 10
    load_and_authorize_resource
  # GET /sales
  # GET /sales.json
  def index
    if params[:client_id].present?
     @page = (params[:page] || 0).to_i
     @keywords = params[:keywords]
     search = Search.new(@page, PAGE_SIZE, @keywords, current_user, params[:client_id], params[:filter])
     @sales, @number_of_pages = search.mysales
    else
    unsaved_sales = Sale.where(state: "draft", user: current_user)
    unsaved_sales.each do |sale|
    sale.destroy_sale_details_all  
    sale.destroy
    end

    unsaved_clients = Client.where(state: "draft", user_id: current_user.id)
    unsaved_clients.each do |client|
    client.destroy
    end
    @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]

    search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil, params[:filter])
    @sales, @number_of_pages = search.sales

    end

    @title = "Reporte de ventas: "+current_user.name
     @url_sale_pdfs = "/sales"+".pdf?data_init="+@data_init.to_s+"&data_limit="+(@data_limit.to_date).to_s+"&filter="+@filter.to_s
     respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'sales/pdfs/sale_report', 
          pdf: 'Reporte de ventas',
          title: 'Extracto de ventas',
          orientation: 'Landscape',
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

  # GET /sales/1
  # GET /sales/1.json
  def show   
    respond_to do |format|
        format.html
        format.json
        format.pdf {
          render template: 'sales/proforma', 
          layout: 'pdf_layout.html.erb',
          pdf: 'Nota',
          title: 'Proforma',
          orientation: 'Portrait',
          page_height:  215,
          page_width:   163,
          print_media_type:  false,
          
          margin:  { 
                  left: 15,
                  top: 13,
                  right: 1}, 

           footer: {
             right: '[page] de [topage]',
         
          
        }                        
         
        }
      end
  end
  
  def sale_details
     @sale_details =  Sale.find(params[:current_sale_id]).sale_details
    
  end
  def set_penalty
    @sale = Sale.find(params[:sale_id])
    if Date.today >= @sale.created_at
      @sale.penalty = params[:valor]
      @sale.save
      result = [valid: true, notice: '¡Se penalizo con exito !']
    else
      result = [valid: false, notice: '¡No es posible penalizar a un esta dentro el tiempo establecido!'] 
    end
    
   render json: result
  end
  def set_canceled
    @sale = Sale.find(params[:sale_id])
    if @sale.payments.count <= 0
      @sale.canceled = params[:valor]
      if @sale.total_final <= 0
        if @sale.save
          		@sale.annulled!         result = [valid: true, notice: '¡Se anulo con exito !']   
        end
      else
          result = [valid: false, notice: '¡Antes de anular debe realizar las devoluciones de los items detalle !']
      end  
    else
      result = [valid: false, notice: '¡No se puede anular la venta !']  
    end
     render json: result
  end

  # GET /sales/new
  def new 
    unsaved_sales = Sale.where(state: "draft", user: current_user, discount: "0")
    unsaved_sales.each do |sale|
      # se debe obtimisar el codigo se esta repidiendo muchas veses
      # sale.sale_details.each do |sale_details|        
      #   movements = sale_details.movements
      #   movements.each do |movement|
      #   stock = Stock.find(movement.stock_id)
      #   stock.qty_out -= movement.qty_out
      #   stock.state = 'disponible'
      #   stock.save
      #   movement.destroy
      #   end
      #   sale_details.destroy
      # end
    sale.destroy_sale_details_all
    sale.destroy
    end
    last_sale = Sale.where(state: "confirmed", user: current_user).maximum('number')
    last_sale_all = Sale.where(state: "confirmed").maximum('number_sale')
    number_sale =  (last_sale_all != nil) ? last_sale_all + 1 : 1
    
    number =  (last_sale != nil) ? last_sale + 1 : 1
    @sale = Sale.create(date: Date::current, number: number, state: "draft", user: current_user, client_id: params[:client], credit_expiration: Date::current, number_sale: number_sale, completed:false, canceled:false,  discount: "0")
    @sale.por_facturar!
    @sale.sale_details.build
    params[:sale_id] = @sale.id.to_s
    
  end

  # GET /sales/1/edit
  def edit
    
  end

  # POST /sales
  # POST /sales.json
  def create
  end
  # PATCH/PUT /sales/1
  # PATCH/PUT /sales/1.json
  def update
     @sale.update(sale_params)
      last_sale_all = Sale.where(state: "confirmed").maximum('number_sale')
      if @sale.is_can_sale       
           if @sale.draft?
              number_sale =  (last_sale_all != nil) ? last_sale_all + 1 : 1
              @sale.number_sale = number_sale
           end
          @sale.confirmed! 
           @sale.discount_total = @sale.discount    
           @sale.penalty = false
          
           
           # @sale.total = @sale.total_final        
      respond_to do |format|
          if @sale.update(sale_params)
            format.html { redirect_to sales_url, notice: 'Venta actualizada.'}
            format.json { render :show, status: :ok, location: @sale }
          else
            format.html { render :edit }
            format.json { render json: @sale.errors, status: :unprocessable_entity }
          end
      end
    else
      respond_to do |format|        
        format.html { redirect_to new_sale_path(client: @sale.client.id), alert: '¡Venta no realizada usted no agrego items o supero el limite de creito que dispone.!' }
      end
    end
  end
  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    msm = 'La venta ya se efectuo. No se puede eliminar  .'
    if @sale.payments.count == 0
       @sale.destroy_sale_details_all
       @sale.destroy
       msm = 'Venta eliminada.'
    end
   
    respond_to do |format|
      format.html { redirect_to sales_url, notice: msm }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.

     def set_index
       @data_init = params[:data_init].try(:to_date) || 30.days.ago.to_date
       @data_limit = params[:data_limit].try(:to_date) || Date.current
       @mystate =  params[:state]
       @filter = params[:filter]
       ranges = (@data_init..@data_limit+1)

       if current_user.is_admin?
         @sale_report_rage = Sale.where(created_at: ranges).order(created_at: :desc)
       else
         @sale_report_rage = Sale.where(created_at: ranges, user_id: current_user.id).order(created_at: :desc)
       end

       if @filter.present?
        @sale_report_rage = @sale_report_rage.where(payment_status_cache: @filter)
       end
       

       if current_user.is_admin?
       @column_data = Sale.states.keys.map do |state|
         { name: state.capitalize, data: group_by_period(Sale.where(state: state),ranges).sum(:total) }
        end
      @pie_chart = Sale.where(created_at: ranges).group(:state).sum(:total)
      else
         @column_data = Sale.states.keys.map do |state|
         { name: state.capitalize, data: group_by_period(Sale.where(state: state, user_id: current_user.id),ranges).sum(:total) }
        end
      @pie_chart = Sale.where(created_at: ranges, user_id: current_user.id).group(:state).sum(:total)
      end    

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


    def set_sale
        @sale = Sale.find(params[:id])
    end
   def set_combo_values

   @clients = Client.where(state: 1, asig_a_user_id: current_user.id).order(:name)
   end
    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      # params.require(:sale).permit(:number, :date, :state, :user_id)
        params.require(:sale).permit(:number, :date, :client_id, :credit, :discount_total, :total, :penalty, :credit_expiration, :discount, :number_sale, :invoiced, sale_details_attributes: [:id, :sale_id, :item_id, :number, :qty, :price, :price_list_id, :_destroy] )
    end
end
