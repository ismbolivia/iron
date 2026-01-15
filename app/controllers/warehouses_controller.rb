class WarehousesController < ApplicationController
   before_action :set_warehouse, only: [:show, :edit, :update, :destroy]
   before_action :set_combo_values, only: [:new, :edit, :update, :create]
   load_and_authorize_resource
  PAGE_SIZE = 5
  # GET /warehouses
  # GET /warehouses.json
  def index
     @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]

    search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil)
    @warehouses, @number_of_pages = search.warehouse_by_name
  end

  # GET /warehouses/1
  # GET /warehouses/1.json
  def show
      
          @warehouse_items = @warehouse.items.order(:id)
          @title = "Productos del almacen "+ @warehouse.name
             respond_to do |format|
              format.html
              format.json
              format.pdf {
                render pdf: 'pdf',
                        template: 'warehouses/reports/list_pdf',
                        title: 'Productos',
                        orientation: 'Portrait',
                        page_size: 'Letter',
                        print_media_type: true,          
                        header: {
                        html: {
                          template: 'layouts/partials/pdf_header',
                        }
                       }
               # footer: {
                #html: {
                 # template: 'layouts/partials/pdf_header',
                  #font_size: 5,
                #}
              #}
               # margin: {

               #  right: 2,
               #  left: 3 }
              }
              
          end 
  end

  # GET /warehouses/new
  def new
    @warehouse = Warehouse.new
    last_warehouse = Warehouse.count
    number =  (last_warehouse != nil) ? last_warehouse + 1 : 1
    @warehouse.ref = "A"+number.to_s
  end

  # GET /warehouses/1/edit
  def edit
  end

  # POST /warehouses
  # POST /warehouses.json
  def create
    @warehouse = Warehouse.new(warehouse_params)
    last_warehouse = Warehouse.count
     number =  (last_warehouse != nil) ? last_warehouse + 1 : 1
     @warehouse.ref = "A"+number.to_s
    respond_to do |format|
      if @warehouse.save
        format.html { redirect_to @warehouse, notice: 'Warehouse was successfully created.' }
        format.json { render :show, status: :created, location: @warehouse }
      else
        format.html { render :new }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /warehouses/1
  # PATCH/PUT /warehouses/1.json
  def update
    respond_to do |format|
      if @warehouse.update(warehouse_params)
        format.html { redirect_to @warehouse, notice: 'Warehouse was successfully updated.' }
        format.json { render :show, status: :ok, location: @warehouse }
      else
        format.html { render :edit }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /warehouses/1
  # DELETE /warehouses/1.json
  def destroy
    @warehouse.destroy
    respond_to do |format|
      format.html { redirect_to warehouses_url, notice: 'Warehouse was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_combo_values
    @companies = Company.all.order(:name)
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_warehouse
      @warehouse = Warehouse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def warehouse_params
      params.require(:warehouse).permit(:ref, :name, :description, :active, :company_id)
    end
end
