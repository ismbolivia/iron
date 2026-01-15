class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :set_combo_values, only: [:new, :edit, :update, :create]
  before_action :set_index, only: [:index] 
  before_action :set_show, only: [:show, :edit]
  load_and_authorize_resource :except => [:cliente_sale]
  PAGE_SIZE = 5

  # GET /clients
  # GET /clients.json
  def index
    @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]
    search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil, @filter)
    @clients, @number_of_pages = search.clients_by_name

    @title = "Reporte de ventas"
     @url_sale_pdfs = "/clients"+".pdf?data_init="+@data_init.to_s+"&data_limit="+(@data_limit.to_date+1).to_s+"&filter="+@filter.to_s
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
  
  def myclients
    @myclients = Client.where(asig_a_user_id: current_user.id)   
  end
  def my_sales
     @client = Client.find(params[:client_id])
      @title= "Mis ventas ("+ @client.name + ")"
     @sales = @client.sales.order(number_sale: :desc).limit(20) 
  end
  def my_payments
    lists = []
    @client= Client.find(params[:client_id])
     @title= "Mis pagos ("+ @client.name + ")"
    @sales = @client.sales
     @sales.each do |sale|
      lists +=  sale.payments      
     end 
     @payments = lists.sort.reverse!

  end
  def to_payments
     @client= Client.find(params[:client_id])
     @title= "Ventas por cobrar ("+ @client.name + ")"
      @sales =  @client.sales.where(completed: false, canceled: false).order(number_sale: :desc).limit(20)
  end
  def to_invocing
    @invoiced = params[:invoiced]
    @client=  Client.find(params[:client_id])
      if  @invoiced == "facturado"
         @title= "Ventas facturadas ("+ @client.name + ")"
      end
       if  @invoiced == "por_facturar"
         @title= "Ventas sin facturar ("+ @client.name + ")"
      end    
    @sales = @client.sales.where(invoiced: @invoiced, canceled: false ).order(number_sale: :desc).limit(20)
  end
  def cliente_sale
      client = []
      if params[:client_id].present?
        client_id = params[:client_id]
        client = Client.where(id: client_id)
      end

      if !client.empty?
        result = [valid: true, discount: client.first.discount, limit_credit: client.first.credit_limit,
        address: client.first.address.get_direccion_all, telf: client.first.phones, price_list_id: client.first.price_list_id, line_credit_available: client.first.line_credit_available ]
      else
        result = [valid: false, discount: 0 ,limit_credit: 0,
        address: "", telf: "" ]
      end
      render json: result
  end
  # GET /clients/1
  # GET /clients/1.json
  def show
     @user_asig = User.find(@client.asig_a_user_id)
     @title = "Reporte de ventas de: "+ @client.name
       @url_sale_pdfs = "/clients/"+@client.id.to_s+".pdf?data_init="+@data_init.to_s+"&data_limit="+(@data_limit.to_date+1).to_s+"&filter="+@filter.to_s
     respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'sales/pdfs/sale_report', 
          pdf: 'Reporte de ventas',
          title: 'Extracto de ventas',
          orientation: 'Portrait',
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

  # GET /clients/new
  def new
    @client = Client.new
     @addresses = []
     @all_price_lists = PriceList.all.order(:name)
      @client_price_list = ClientPriceList.new
    # @address= Address.new
  end
  def new_sales_pdf
    @client = Client.find(params[:client_id])
    condition = params[:condition]
    @sales = []
      @sales = @client.sales.order(number_sale: :desc)
      @title = "Ventas al cliente ("+ @client.name + ")"
      @url_pdfs = "/clients_sales_pdf.pdf?client_id="+@client.id.to_s    
    @sales
    respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'clients/pdf', 
          pdf: 'pdf',
          title: 'Ventas',
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
         # margin: {

         #  right: 2,
         #  left: 3 }
        }
        
       end 
  end

  def to_payment_pdf 
     @client = Client.find(params[:client_id])
     @title= "Ventas por cobrar ("+ @client.name + ")"
      @sales =  @client.sales.where(completed: false, canceled: false).order(number_sale: :desc)
      @url_pdfs = "/clients_to_payment_pdf.pdf?client_id="+@client.id.to_s
      respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'clients/pdf', 
          pdf: 'pdf',
          title: 'Ventas',
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

  def to_invocing_pdf
    @invoiced = params[:invoiced]
    @client=  Client.find(params[:client_id])
      if  @invoiced == "facturado"
         @title= "Ventas facturadas ("+ @client.name + ")"
      end
       if  @invoiced == "por_facturar"
         @title= "Ventas sin facturar ("+ @client.name + ")"
      end    
    @sales = @client.sales.where(invoiced: @invoiced, canceled: false ).order(number_sale: :desc)
      @url_pdfs = "/clients_to_invoiced_pdf.pdf?client_id="+@client.id.to_s+"&invoiced="+@invoiced.to_s
      respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'clients/pdf', 
          pdf: 'pdf',
          title: 'Ventas',
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

  def new_payments_pdf
    lists = []
    @client= Client.find(params[:client_id])
    @title= "Pagos de ("+ @client.name + ")"
    @sales = @client.sales
    @sales.each do |sale|
      lists +=  sale.payments      
     end 
     @url_pdfs = "/clients_payments_pdf.pdf?client_id="+@client.id.to_s
     @payments = lists.sort.reverse!

     respond_to do |format|
        format.html
        format.json
        format.js
        format.pdf {
          render template: 'clients/payment', 
          pdf: 'pdf',
          title: 'Pagos',
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
  # GET /clients/1/edit
  def edit
    @addresses = Address.where(id: @client.address_id)
    @user_asig = User.find(@client.asig_a_user_id)
      @all_price_lists = PriceList.all
      @client_price_list = ClientPriceList.new
  end

  # POST /clients
  # POST /clients.json
  def create
    @addresses = []
    @client = Client.new(client_params)
    @client.state = 1
    @client.saldo = 0
    @client.user_id = current_user.id
    @client.asig_a_user_id = current_user.id
    @client.discount = 0
    respond_to do |format|
      if @client.save
        # params[:price_lists][:ids].each do |price_list|
        #   if !price_list.empty?
        #     client_price_list = ClientPriceList.new
        #     client_price_list.client_id = @client.id 
        #     client_price_list.price_list_id = price_list
        #     client_price_list.save
        #      # @purchase_order.purchase_order_lines.purchase_order_line_taxes.build(:tax_id => tax)        
        #   end
        # end
        format.html { redirect_to @client, notice: 'Client was successfully created.', flash: {success: 'Pattern Created Successfully'} }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
         @client.save

        # params[:price_lists][:ids].each do |price_list|
        #   if !price_list.empty?
        #      @client.client_price_lists.destroy_all
        #     client_price_list = ClientPriceList.new
        #     client_price_list.client_id = @client.id 
        #     client_price_list.price_list_id = price_list
        #     client_price_list.save
        #      # @purchase_order.purchase_order_lines.purchase_order_line_taxes.build(:tax_id => tax)        
        #   end
        # end
        format.html { redirect_to clients_url, notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    if @client.sales.count.equal? 0 and @client.contacts.count.equal? 0
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Cliente eliminado satisfactoriamente.' }
      format.json { head :no_content }
    end
  else
    respond_to do |format|
      format.html { redirect_to clients_url, alert: 'El cliente tiene actividades registradas no se puede eliminar.' }
      format.json { head :no_content }
     end
    end
  end
  private
    def set_show
      @data_init = params[:data_init].try(:to_date) || 30.days.ago.to_date
       @data_limit = params[:data_limit].try(:to_date) || Date.current
       @mystate =  params[:state]
       @filter = params[:filter]
       ranges = (@data_init..@data_limit)

       # report = Report.new(@data_init, @data_limit, current_user, @box)
       if @filter == ""       
          @sale_report_rage = @client.sales.where(created_at: ranges ).joins(:client).order(name: :ASC)        
       else  
          @sale_report_rage = @client.sales.where( state: @filter, created_at: ranges).joins(:client).order(name: :ASC)     
       end
        @column_data = Sale.states.keys.map do |state|
         { name: state.capitalize, data: group_by_period(Sale.where(state: state, client_id: @client.id),ranges).sum(:total) }
        end
      @pie_chart = Sale.where(created_at: ranges, client_id: @client.id).group(:state).sum(:total)
    end
   def set_index
       @data_init = params[:data_init].try(:to_date) || 30.days.ago.to_date
       @data_limit = params[:data_limit].try(:to_date) || Date.current
       @mystate =  params[:state]
       @filter = params[:filter]
       ranges = (@data_init..@data_limit)

       # report = Report.new(@data_init, @data_limit, current_user, @box)
       if @filter == ""
        if current_user.is_admin?
          @sale_report_rage = Sale.where(created_at: ranges).joins(:client).order(name: :ASC)
        else
          @sale_report_rage = Sale.where(created_at: ranges,  user_id: current_user.id ).joins(:client).order(name: :ASC)
        end
       else   
        if current_user.is_admin?     
          @sale_report_rage = Sale.where( state: @filter, created_at: ranges).joins(:client).order(name: :ASC)      
        else   
          @sale_report_rage = Sale.where( state: @filter, created_at: ranges,  user_id: current_user.id ).joins(:client).order(name: :ASC)      
        end
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
  def set_combo_values

    @price_lists = PriceList.all
    @users = User.all

  end
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :address_id, :phone, :mobile, :email, :web_site, :photo, :saldo , :discount, :credit_limit, :price_list_id, :asig_a_user_id, :nit )
    end
end