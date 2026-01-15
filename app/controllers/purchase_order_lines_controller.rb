class PurchaseOrderLinesController < ApplicationController
  before_action :set_purchase_order_line, only: [:new, :create, :destroy]
  before_action :set_combo_values, only: [:new, :edit, :update, :create]
  load_and_authorize_resource
  # GET /purchase_order_lines
  # GET /purchase_order_lines.json
 

  # GET /purchase_order_lines/1
  # GET /purchase_order_lines/1.json
 
  # GET /purchase_order_lines/new
  def new
    @purchase_order_lines = @purchase_order.purchase_order_lines.build
    @purchase_order_lines.item = Item.first
    @purchase_order_lines.date_planned = Date::current
    get_taxes
    @supplier_id =  params[:supplier]
     # @purchase_order_line.purchase_order_id = params[:purchase_order_id]
  end

  # GET /purchase_order_lines/1/edit
  def edit
   purchase_order_line = PurchaseOrderLine.find(params[:id])
   purchase_order_line.to_prices = false
   purchase_order_line.save
    @pol_prices = PurchaseOrderLine.where(to_prices: true).limit(10).order(:id)
     
  end

  # POST /purchase_order_lines
  # POST /purchase_order_lines.json
  def create


      item_exists = false
      
      
     @purchase_order_line = PurchaseOrderLine.new(purchase_order_lines_params)
     @purchase_order_line.name = Item.find( params[:purchase_order_lines][:item_id]).name
     @purchase_order_line.state = 'borrador'
     @pol_prices = PurchaseOrderLine.where(to_prices: true).order(:id)
    if @purchase_order_line.save

        params[:taxes][:id].each do |tax|
          if !tax.empty?
            purchase_order_line_tax = PurchaseOrderLinesTax.new
            purchase_order_line_tax.purchase_order_line_id = @purchase_order_line.id
            purchase_order_line_tax.tax_id = tax
            purchase_order_line_tax.save
             # @purchase_order.purchase_order_lines.purchase_order_line_taxes.build(:tax_id => tax)        
          end
        end
        # purchase_order_line_tax.purchase_order_line_id = @purchase_order_line.id
        # purchase_order_line_tax.tax_id = params[:tax_id]
        # purchase_order_line_tax.save

        messagess = 'successesfull'  
      else
        errores = "errors"
    end

  end
  # PATCH/PUT /purchase_order_lines/1
  # PATCH/PUT /purchase_order_lines/1.json
  def update
    respond_to do |format|
      if @purchase_order_line.update(purchase_order_lines_params)
        format.html { redirect_to @purchase_order_line, notice: 'Purchase order line was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase_order_line }
      else
        format.html { render :edit }
        format.json { render json: @purchase_order_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_order_lines/1
  # DELETE /purchase_order_lines/1.json
  def destroy
     @purchase_order_line = PurchaseOrderLine.find(params[:id])

     if params[:state]
        @purchase_order_line.state = 'confirmado'
        @purchase_order_line.to_prices = true
        @purchase_order_line.save
        if @purchase_order_line.purchase_order.confirmed
          purchase_order = @purchase_order_line.purchase_order 
          purchase_order.state = 'confirmado'
          purchase_order.save
        end

      else
         deletes = @purchase_order_line.purchase_order_lines_taxes
         deletes.destroy_all
        @purchase_order_line.destroy
     end
 
     respond_to do |format|
        format.js { render layout: false }       
     end     
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_order_line
        @purchase_order = PurchaseOrder.find(params[:purchase_order_id].to_i)     
    end
    def set_combo_values
        # @taxes = Tax.where(active: true).order(:name)
        
   end
    def get_taxes
      @all_taxes = Tax.all
      @purchase_order_lines_tax = PurchaseOrderLinesTax.new
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_order_lines_params
      params.require(:purchase_order_lines).permit(:id, :name, :item_qty, :date_planned, :item_id, :price_unit, :price_tax, :company_id, :state, :qty_received, :purchase_order_id, :to_prices, :_destroy)
    end
end