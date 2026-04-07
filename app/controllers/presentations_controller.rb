class PresentationsController < ApplicationController
  before_action :set_presentation, only: [:show, :edit, :update, :destroy]
  before_action :set_combo, only: [:new, :edit, :update]
  # GET /presentations
  # GET /presentations.json
    load_and_authorize_resource
  def index
    @page = params[:page].present? ? params[:page].to_i : 0
    @keywords = params[:keywords]
    
    @presentations = Presentation.all
    if @keywords.present?
       @presentations = @presentations.left_joins(:item).where("LOWER(presentations.name) LIKE ? OR LOWER(items.name) LIKE ?", "%#{@keywords.downcase}%", "%#{@keywords.downcase}%")
    end
    
    @per_page = 10
    total_count = @presentations.count
    @number_of_pages = (total_count / @per_page.to_f).ceil - 1
    @number_of_pages = 0 if @number_of_pages < 0
    
    @presentations = @presentations.order(:name).limit(@per_page).offset(@page * @per_page)
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
    @is_item_presentation = @presentation.item_id.nil?
    respond_to do |format|
      format.html
      format.js
    end
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
    @is_can = params[:is_item_presentation]
    respond_to do |format|
      if @presentation.update(presentation_params)
        @item = @presentation.item
        format.html { redirect_to @presentation, notice: 'Presentation was successfully updated.' }
        format.json { render :show, status: :ok, location: @presentation }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  # DELETE /presentations/1
  # DELETE /presentations/1.json
  def destroy
    @item = @presentation.item
    @presentation.destroy
    respond_to do |format|
      format.html { redirect_to presentations_url, notice: 'Presentation was successfully destroyed.' }
      format.json { head :no_content }
      format.js
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
      params.require(:presentation).permit(:name, :qty, :unit_id, :item_id, :image_presentation, :parent_id, :qty_in_parent)
    end
end
