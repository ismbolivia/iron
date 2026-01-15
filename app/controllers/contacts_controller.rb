class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
    before_action :set_combo_values, only: [:new, :edit, :update, :create]
    load_and_authorize_resource
  PAGE_SIZE = 5
  # GET /contacts
  # GET /contacts.json
  def index
    @page = (params[:page] || 0).to_i
    @keywords = params[:keywords]

    search = Search.new(@page, PAGE_SIZE, @keywords)
    @contacts, @number_of_pages = search.contacts_by_name
  
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    if params[:client_id].present?
      @client = Client.find(params[:client_id])
       @contact.client_id =  @client.id
    end
    
    
    @myClients = Client.where(asig_a_user_id: current_user.id)
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)
   
      if @contact.save   
      @client = @contact.client    
      else       
      end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end
     def set_combo_values
      @clients = Client.all.order(:name)
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :title, :job, :email, :mobile, :nit, :client_id, :profile)
    end
end
