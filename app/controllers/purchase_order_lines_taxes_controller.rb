class PurchaseOrderLinesTaxesController < ApplicationController
  before_action :set_purchase_order_lines_tax, only: [:show, :edit, :update, :destroy]

  # GET /purchase_order_lines_taxes
  # GET /purchase_order_lines_taxes.json
  def index
    @purchase_order_lines_taxes = PurchaseOrderLinesTax.all
  end

  # GET /purchase_order_lines_taxes/1
  # GET /purchase_order_lines_taxes/1.json
  def show
  end

  # GET /purchase_order_lines_taxes/new
  def new
    @purchase_order_lines_tax = PurchaseOrderLinesTax.new
  end

  # GET /purchase_order_lines_taxes/1/edit
  def edit
  end

  # POST /purchase_order_lines_taxes
  # POST /purchase_order_lines_taxes.json
  def create
    @purchase_order_lines_tax = PurchaseOrderLinesTax.new(purchase_order_lines_tax_params)

    respond_to do |format|
      if @purchase_order_lines_tax.save
        format.html { redirect_to @purchase_order_lines_tax, notice: 'Purchase order lines tax was successfully created.' }
        format.json { render :show, status: :created, location: @purchase_order_lines_tax }
      else
        format.html { render :new }
        format.json { render json: @purchase_order_lines_tax.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchase_order_lines_taxes/1
  # PATCH/PUT /purchase_order_lines_taxes/1.json
  def update
    respond_to do |format|
      if @purchase_order_lines_tax.update(purchase_order_lines_tax_params)
        format.html { redirect_to @purchase_order_lines_tax, notice: 'Purchase order lines tax was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase_order_lines_tax }
      else
        format.html { render :edit }
        format.json { render json: @purchase_order_lines_tax.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_order_lines_taxes/1
  # DELETE /purchase_order_lines_taxes/1.json
  def destroy
    @purchase_order_lines_tax.destroy
    respond_to do |format|
      format.html { redirect_to purchase_order_lines_taxes_url, notice: 'Purchase order lines tax was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase_order_lines_tax
      @purchase_order_lines_tax = PurchaseOrderLinesTax.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_order_lines_tax_params
      params.require(:purchase_order_lines_tax).permit(:purchase_order_line_id, :tax_id)
    end
end
