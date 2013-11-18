class FarmersController < ApplicationController
  before_action :signed_in_farmer, only: [:index, :show, :edit, :update]
  before_action :correct_farmer, only: [:edit, :update]
  before_action :set_farmer, only: [:show, :edit, :update, :destroy]

  # Listing all farmers, paginated with 30 listings per page
  def index
    @farmers = Farmer.paginate(page: params[:page])
  end

  def show
  end

  def new
    @farmer = Farmer.new
  end

  def edit
  end

  # Saving a new farmer in database, with messages and redirects
  def create
    @farmer = Farmer.new(farmer_params)

    respond_to do |format|
      if @farmer.save
        sign_in @farmer
        format.html { redirect_to @farmer, notice: 'Welcome to Wolfbane. May your sheep live long and prosper.' } #sheep_index_path
        format.json { render action: 'show', status: :created, location: @farmer }
      else
        format.html { render action: 'new' }
        format.json { render json: @farmer.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updating a farmer, with messages and redirects
  def update
    respond_to do |format|
      if @farmer.update(farmer_params)
        format.html { redirect_to @farmer, notice: 'Farmer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @farmer.errors, status: :unprocessable_entity }
      end
    end
  end

  # Deleting a farmer, with messages and redirects
  def destroy
    @farmer.destroy
    respond_to do |format|
      format.html { redirect_to farmers_url }
      format.json { head :no_content }
    end
  end

  private
    # Set the current farmer object in the controller
    def set_farmer
      @farmer = Farmer.find(params[:id])
    end

    # Restrict legal parameters
    def farmer_params
      params.require(:farmer).permit(:email, :name, :phone, :backup, :password,
                                     :password_confirmation)
    end

    # Ensure that the farmer object is the logged in user
    # If not, redirect to main page
    def correct_farmer
      @farmer = Farmer.find(params[:id])
      redirect_to root_url unless current_user?(@farmer)
    end
end
