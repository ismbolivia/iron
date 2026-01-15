class ClientPriceListsController < ApplicationController
  before_action :set_client_price_list, only: [:show, :edit, :update, :destroy]
  before_action :set_values, only: [:new, :edit, :update]
  # load_and_authorize_resource
  # GET /client_price_lists
  # GET /client_price_lists.json
  def index
    @client_price_lists = ClientPriceList.all
  end

  # GET /client_price_lists/1
  # GET /client_price_lists/1.json
  def show
  end

  # GET /client_price_lists/new
  def new
    @client = Client.find(params[:client_id])
    @client_price_list = ClientPriceList.new
    # @price_lists =  PriceList.all
  end

  # GET /client_price_lists/1/edit
  def edit
  end
  # POST /client_price_lists
  # POST /client_price_lists.json
  def create
     @client_price_list = ClientPriceList.new(client_id: params[:client_id], price_list_id: params[:price_list_id])
      if @client_price_list.save

         messagess = 'successesfull' 
      else
        errores = "errors"
      end
      @client =  @client_price_list.client

  end

  # PATCH/PUT /client_price_lists/1
  # PATCH/PUT /client_price_lists/1.json
  def update
    respond_to do |format|
      if @client_price_list.update(client_price_list_params)
        format.html { redirect_to @client_price_list, notice: 'Client price list was successfully updated.' }
        format.json { render :show, status: :ok, location: @client_price_list }
      else
        format.html { render :edit }
        format.json { render json: @client_price_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client_price_lists/1
  # DELETE /client_price_lists/1.json
  def destroy
     @client = @client_price_list.client
    @client_price_list.destroy
  end
  private
   def set_values
       @price_lists = [] 
      
      if params[:client_id].present?
         @price_lists =  PriceList.where.not( id: Client.find(params[:client_id]).price_lists.ids)      
      end 
      @price_lists
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_client_price_list
      @client_price_list = ClientPriceList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_price_list_params
      params.require(:client_price_list).permit(:client_id, :price_list_id)
    end
end
