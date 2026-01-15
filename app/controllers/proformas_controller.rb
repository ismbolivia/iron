class ProformasController < ApplicationController
  before_action :set_proforma, only: [:show, :edit, :update, :destroy]

  # GET /proformas
  # GET /proformas.json
  def index
    @proformas = Proforma.all
  end

  # GET /proformas/1
  # GET /proformas/1.json
  def show
    respond_to do |format|
  
        @sale = @proforma.sale
        format.html { redirect_to @proforma, notice: 'Proforma genarada con exito.' }
        format.json { render :show, status: :created, location: @proforma }
         format.pdf {
          render template: 'sales/proforma', 
          layout: 'pdf_layout.html.erb',
          pdf: 'Nota',
          title: 'Proforma',
          orientation: 'Portrait',
          page_height:  215,
          page_width:   163,
          print_media_type:  false,
          
          margin:  { 
                  left: 15,
                  top: 13,
                  right: 1}, 

           footer: {
             right: '[page] de [topage]',
         
          
        }                        
         
        }
          end
  end

  # GET /proformas/new
  def new
     @proforma = Proforma.new
     @proforma.sale_id = params[:sale_id]
     last_proforma = Proforma.all.maximum('number')
    number =  (last_proforma != nil) ? last_proforma + 1 : 1
    @proforma.number = number
    @proforma.save
  end

  # GET /proformas/1/edit
  def edit
  end

  # POST /proformas
  # POST /proformas.json
  def create
    @proforma = Proforma.new(proforma_params)
    last_proforma = Proforma.all.maximum('number')
    number =  (last_proforma != nil) ? last_proforma + 1 : 1
    @proforma.number = number

    respond_to do |format|
      if @proforma.save
        @sale = @proforma.sale
        format.html { redirect_to @proforma, notice: 'Proforma was successfully created.' }
        format.json { render :show, status: :created, location: @proforma }
         format.pdf {
          render template: 'sales/proforma', 
          layout: 'pdf_layout.html.erb',
          pdf: 'Nota',
          title: 'Proforma',
          orientation: 'Portrait',
          page_height:  215,
          page_width:   163,
          print_media_type:  false,
          
          margin:  { 
                  left: 15,
                  top: 13,
                  right: 1}, 

           footer: {
             right: '[page] de [topage]',
         
          
        }                        
         
        }
      else
        format.html { render :new }
        format.json { render json: @proforma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proformas/1
  # PATCH/PUT /proformas/1.json
  def update
    respond_to do |format|
      if @proforma.update(proforma_params)
        format.html { redirect_to @proforma, notice: 'Proforma was successfully updated.' }
        format.json { render :show, status: :ok, location: @proforma }
      else
        format.html { render :edit }
        format.json { render json: @proforma.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proformas/1
  # DELETE /proformas/1.json
  def destroy
    @proforma.destroy
    respond_to do |format|
      format.html { redirect_to proformas_url, notice: 'Proforma was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proforma
       @proforma = Proforma.find(params[:id])
      # @sale = Sale.find(params[:sale_id].to_i)
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def proforma_params
      params.require(:proforma).permit(:number, :sale_id)
    end
end
