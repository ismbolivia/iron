class ReceptionsController < ApplicationController
  before_action :set_reception, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /receptions
  # GET /receptions.json
  def index
    @receptions = Reception.all
  end

  # GET /receptions/1
  # GET /receptions/1.json
  def show
  end

  # GET /receptions/new
  def new
    @reception = Reception.new
    @reception.purchase_order_line_id = params[:purchase_order_line_id]
 
    # @reception.total = PurchaseOrderLine.find(params[:purchase_order_line_id]).item_qty
  end

  # GET /receptions/1/edit
  def edit
  end

  # POST /receptions
  # POST /receptions.json
  def create
    @reception = Reception.new(reception_params)     
      if @reception.save
         @purchase_order_line = @reception.purchase_order_line
         if   @purchase_order_line.item_qty > @purchase_order_line.qty_received
              @purchase_order_line.state = 'parcial'
              @purchase_order_line.save
          elsif @purchase_order_line.item_qty == @purchase_order_line.qty_received
            
               @purchase_order_line.state = 'recivido'
                @purchase_order_line.save
          else     
            @errores = "La cantidad ingresada es mayor al  pidio!"
         end
       messagess = 'successesfull' 
       @purchase_order = @purchase_order_line.purchase_order
      else
       errores = "errors"
      end
   
  end

  # PATCH/PUT /receptions/1
  # PATCH/PUT /receptions/1.json
  def update
    respond_to do |format|
      if @reception.update(reception_params)
        format.html { redirect_to @reception, notice: 'Reception was successfully updated.' }
        format.json { render :show, status: :ok, location: @reception }
      else
        format.html { render :edit }
        format.json { render json: @reception.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receptions/1
  # DELETE /receptions/1.json
  def destroy
    @reception.destroy
    respond_to do |format|
      format.html { redirect_to receptions_url, notice: 'Reception was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reception
      @reception = Reception.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reception_params
      params.require(:reception).permit(:qty_in, :total, :fecha, :ob, :warehouse_id, :user_id, :company_id, :purchase_order_line_id)
    end
end



