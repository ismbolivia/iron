class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  skip_load_and_authorize_resource only: [:workspace, :assign_items, :update_item_field]
  PAGE_SIZE = 10
  # GET /categories
  # GET /categories.json
  def index
    @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]

    search = Search.new(@page, PAGE_SIZE, @keywords, current_user, nil, nil)
    @categories, @number_of_pages = search.categories_by_name
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def workspace
    authorize! :manage, Category
    @categories = Category.all.order("unaccent(lower(name)) ASC")
    @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]
    @category_filter = params[:category_filter]

    items_query = Item.where(active: true)
    
    if @keywords.present?
      items_query = items_query.where("unaccent(lower(items.name)) LIKE :p OR unaccent(lower(items.code)) LIKE :p", p: "%#{I18n.transliterate(@keywords.downcase)}%")
    end

    if @category_filter.present?
      if @category_filter == 'none'
        items_query = items_query.where(category_id: nil)
      else
        items_query = items_query.where(category_id: @category_filter)
      end
    end

    @number_of_records = items_query.count
    @items = items_query.order(:priority, :name).offset(@page * 20).limit(20)
    @number_of_pages = (@number_of_records % 20) == 0 ? @number_of_records / 20 - 1 : @number_of_records / 20

    respond_to do |format|
      format.html
      format.js
    end
  end

  def assign_items
    authorize! :manage, Category
    category_id = params[:category_id] == 'none' ? nil : params[:category_id]
    item_ids = params[:item_ids]

    if item_ids.present? && item_ids.is_a?(Array)
      Item.where(id: item_ids).update_all(category_id: category_id)
      render json: { success: true, message: "Productos asignados con éxito" }
    else
      render json: { success: false, message: "No se seleccionaron productos o formato inválido" }, status: :unprocessable_entity
    end
  end

  def update_item_field
    authorize! :manage, Category
    item = Item.find_by(id: params[:item_id])
    field = params[:field]
    value = params[:value]

    valid_fields = ['code', 'priority', 'name']
    if valid_fields.include?(field) && item && item.update(field => value)
       render json: { success: true, message: "Actualizado correctamente" }
    else
       render json: { success: false, message: "Error al actualizar" }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :pictures)
    end
end

