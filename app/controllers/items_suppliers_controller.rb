class ItemsSuppliersController < ApplicationController
  before_action :set_items_supplier, only: [:show, :edit, :update, :destroy]
  before_action :set_combo_values, only: [:new, :edit, :update]

  # GET /items_suppliers
  # GET /items_suppliers.json
  def index
    @items_suppliers = ItemsSupplier.all
  end

  # GET /items_suppliers/1
  # GET /items_suppliers/1.json
  def show
  end

  # GET /items_suppliers/new
  def new
    @items_supplier = ItemsSupplier.new
     if params[:item_id].present?
     @items_supplier.item_id = params[:item_id]

     elsif params[:supplier_id].present?
       @items_supplier.supplier_id = params[:supplier_id]
    end 
    
  end

  # GET /items_suppliers/1/edit
  def edit
  end

  # POST /items_suppliers
  # POST /items_suppliers.json
  def create
    @items_supplier = ItemsSupplier.new(item_id: params[:item_id], supplier_id: params[:supplier_id] )
    @is_item = params[:is_item].to_i
    if @items_supplier.save             
      messagess = 'successesfull' 
      @supplier =  @items_supplier.supplier
      @item = Item.find(@items_supplier.item_id)
    else
      errores = "errors"
    end
  end

  # PATCH/PUT /items_suppliers/1
  # PATCH/PUT /items_suppliers/1.json
  def update
    respond_to do |format|
      if @items_supplier.update(items_supplier_params)
        format.html { redirect_to @items_supplier, notice: 'Items supplier was successfully updated.' }
        format.json { render :show, status: :ok, location: @items_supplier }
      else
        format.html { render :edit }
        format.json { render json: @items_supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items_suppliers/1
  # DELETE /items_suppliers/1.json
  def destroy
      @items_supplier.destroy
      @item =  @items_supplier.item
      @supplier =  @items_supplier.supplier
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_items_supplier
      @items_supplier = ItemsSupplier.find(params[:id])
    end
    def set_combo_values
       @suppliers = [] 
       @items = []
      if params[:item_id].present?
         @suppliers = Supplier.where.not( id: Item.find(params[:item_id]).suppliers.ids)
      elsif  params[:supplier_id].present?
         @items = Item.where.not(id: Supplier.find(params[:supplier_id]).items.ids)    
      end 
     
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def items_supplier_params
      params.require(:items_supplier).permit(:item_id, :supplier_id, :state)
    end
end