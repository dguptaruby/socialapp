class CampainsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_campain, only: [:show, :edit, :update, :destroy]

  # GET /campains
  # GET /campains.json
  def index
    @campains = Campain.paginate(:page => params[:page], :per_page => 10)
  end

  # GET /campains/1
  # GET /campains/1.json
  def show
    
  end

  # GET /campains/new
  def new
    @campain = Campain.new
  end

  # GET /campains/1/edit
  def edit
  end

  # POST /campains
  # POST /campains.json
  def create
    @campain = Campain.new(campain_params)
    respond_to do |format|
      if @campain.save
        format.html { redirect_to campains_path, notice: 'Campain was successfully created.' }
        format.json { render :show, status: :created, location: @campain }
      else
        format.html { render :new }
        format.json { render json: @campain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campains/1
  # PATCH/PUT /campains/1.json
  def update
    respond_to do |format|
      if @campain.update(campain_params)
        format.html { redirect_to @campain, notice: 'Campain was successfully updated.' }
        format.json { render :show, status: :ok, location: @campain }
      else
        format.html { render :edit }
        format.json { render json: @campain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campains/1
  # DELETE /campains/1.json
  def destroy
    @campain.destroy
    respond_to do |format|
      format.html { redirect_to campains_url, notice: 'Campain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def login
    user = Campain.koala(request.env['omniauth.auth']['credentials'],session["id"])
    session["id"] = nil
    folder = 'public/profile_picture/'.+(user[1]["name"].to_s.gsub!(' ','_').+("_profile.png"))
    open(folder, 'wb') do |file|   
      file << open(user[1]['picture']['data']['url'].to_s).read
    end
    redirect_to "http://www.facebook.com/photo.php?fbid=#{user[0]["id"]}&makeprofile=1"
  end

  def update_profile
    session["id"] = params[:id]
    redirect_to "/auth/facebook" and return
    redirect_to action: login, id: params[:id]
  end

  def subscription
    Subscription.create!(email: params["subscribe"]) if params["subscribe"].present?
    redirect_to root_path
  end

  def contact
    Contact.create!(name: params["InputName"], email: params["InputEmail"], message: params['InputMessage'])
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campain
      @campain = Campain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campain_params
      params.require(:campain).permit(:title, :description, :cover)
    end
end