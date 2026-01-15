class PresentationsController < ApplicationController
  before_action :set_presentation, only: [:show, :edit, :update, :destroy]
  before_action :set_combo, only: [:new, :edit, :update]
  # GET /presentations
  # GET /presentations.json
    load_and_authorize_resource
  def index
    @presentations = Presentation.all
  end

  # GET /presentations/1
  # GET /presentations/1.json
  def show
  end

  # GET /presentations/new
  def new
    @presentation = Presentation.new
    @is_item_presentation = nil
    if params[:item_id].present?
       @presentation.item_id = params[:item_id] 
       @presentation.unit_id = Item.find(params[:item_id]).unit_id 
       @units = Unit.where(id: Item.find(params[:item_id]).unit_id)
       @is_item_presentation = false
    else
        @is_item_presentation = true
    end
       
  end

  # GET /presentations/1/edit
  def edit
  end

  # POST /presentations
  # POST /presentations.json
  def create
    @presentation = Presentation.new(presentation_params)
 
      if @presentation.save
        @item = @presentation.item
        @is_can = params[:is_item_presentation] 
        messagess = 'successesfull'
      else
        errores = "errors"
      end

  end

  # PATCH/PUT /presentations/1
  # PATCH/PUT /presentations/1.json
  def update
    respond_to do |format|
      if @presentation.update(presentation_params)
        format.html { redirect_to @presentation, notice: 'Presentation was successfully updated.' }
        format.json { render :show, status: :ok, location: @presentation }
      else
        format.html { render :edit }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /presentations/1
  # DELETE /presentations/1.json
  def destroy
    @presentation.destroy
    respond_to do |format|
      format.html { redirect_to presentations_url, notice: 'Presentation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def  set_combo
      @units = Unit.all
      @items = Item.all
    end
    def set_presentation
      @presentation = Presentation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def presentation_params
      params.require(:presentation).permit(:name, :qty, :unit_id, :item_id, :image_presentation)
    end
end
