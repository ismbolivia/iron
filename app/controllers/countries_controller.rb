class CountriesController < ApplicationController

  before_action :set_country, only: [:show, :edit, :update, :destroy, :report_sales]
  before_action :set_show, only: [:report_sales]

  load_and_authorize_resource :except => [:getDepartamentos]
  PAGE_SIZE = 5
  # GET /countries
  # GET /countries.json
  def index
   @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]

    search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil)
    @countries, @number_of_pages = search.countries_by_name
  end

  # GET /countries/1
  # GET /countries/1.json
  def show
       @countries = Country.all
  end
    def report_sales
    @url_sale_pdfs = "/to_country/"+@country.id.to_s+".pdf?data_init="+@data_init.to_s+"&data_limit="+(@data_limit.to_date+1).to_s+"&filter="+@filter.to_s
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
         margin:  {
                    left: 20} ,
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

  # GET /countries/new
  def new
    @country = Country.new
   
  end

  # GET /countries/1/edit
  def edit
  end
  def getDepartamentos
    departamentos = []
    if params[:country_id].present?
      departamentos = Country.find(params[:country_id]).departamentos
      
    end

   if !departamentos.empty?
      result = [valid: true, id: params[:country_id], dep: departamentos]
    else
      result = [valid: false, id: params[:country_id], dep: departamentos]
    end
    render json: result
  end

  # POST /countries
  # POST /countries.json
  def create
    @country = Country.new(country_params) 

      if @country.save
        @mensajes = "coreccto"
         @departamentos = @country.departamentos   
      else
        @merror = "errores"
      end  
    
  end

  # PATCH/PUT /countries/1
  # PATCH/PUT /countries/1.json
  def update
    respond_to do |format|
      if @country.update(country_params)
        format.html { redirect_to countries_url, notice: 'Country was successfully updated.' }
        format.json { render :show, status: :ok, location: @country }
      else
        format.html { render :edit }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /countries/1
  # DELETE /countries/1.json
  def destroy
    @country.destroy
    respond_to do |format|
      format.html { redirect_to countries_url, notice: 'Country was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def validate    

  end


  private
    def set_show
     @title = "Reporte de ventas"
      @data_init = params[:data_init].try(:to_date) || "01/01/2021".to_date

       @data_limit = params[:data_limit].try(:to_date) || Date.current
       @mystate =  params[:state]
       @filter = params[:filter]
       ranges = (@data_init..@data_limit)
       # @sale_report_rage = Sale.where( created_at: ranges).joins(:client).order(name: :ASC)

        addresses = @country.addresses
        @daddress = addresses.ids

        if current_user.is_admin?
             clients =Client.where(address_id: @daddress)
          else
             clients =Client.where(address_id: @daddress, asig_a_user_id: current_user.id)
          end
            cli = clients.ids
            sales = Sale.where(client_id: cli )
            @mysales = sales
        if @filter == ""
          @sale_report_rage = sales.where(created_at: ranges).joins(:client).order(name: :ASC)
        else
          @sale_report_rage = sales.where(state: @filter, created_at: ranges).joins(:client).order(name: :ASC)
        end
        @sale_report_rage
       if current_user.is_admin?
       @column_data =   @mysales.states.keys.map do |state|
         { name: state.capitalize, data: group_by_period(  @mysales.where(state: state),ranges).sum(:total) }
        end
      @pie_chart =   @mysales.where(created_at: ranges).group(:state).sum(:total)
      else
        @column_data =   @mysales.states.keys.map do |state|
         { name: state.capitalize, data: group_by_period(  @mysales.where(state: state, user_id: current_user.id),ranges).sum(:total) }
        end
      @pie_chart =   @mysales.where(created_at: ranges, user_id: current_user.id).group(:state).sum(:total)
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
    # Use callbacks to share common setup or constraints between actions.
    def set_country
      @country = Country.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def country_params
      params.require(:country).permit(:name, :code, :phone_code, :initials)
    end
end
