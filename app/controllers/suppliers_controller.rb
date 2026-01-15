class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => [:mysuppliers]
  PAGE_SIZE = 10
  # GET /suppliers
  # GET /suppliers.json
  def index

    @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]

    search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil, params[:filter])
    @suppliers, @number_of_pages = search.suppliers_by_name



  end
  def mysuppliers
      @mysuppliers = Supplier.all
  end
  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
    @addresses = []
  end

  # GET /suppliers/1/edit
  def edit
    @addresses = Address.where(id: @supplier.address_id)
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
      @addresses = []
    @supplier = Supplier.new(supplier_params)
    @supplier.state = 'confirmed'
    @supplier.create_uid =current_user.id

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to @supplier, notice: 'Supplier was successfully created.' }
        format.json { render :show, status: :created, location: @supplier }
      else
        format.html { render :new }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
     @addresses = []
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to @supplier, notice: 'Supplier was successfully updated.' }
        format.json { render :show, status: :ok, location: @supplier }
      else
        format.html { render :edit }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @supplier.destroy
    respond_to do |format|
      format.html { redirect_to suppliers_url, notice: 'Supplier was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:supplier).permit(:name, :display_name, :is_company, :address_id, :nit, :job_id, :phone, :mobile, :email, :web_syte, :description, :imagesupplier, :company_id)
    end
end


