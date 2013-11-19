class PositionsController < ApplicationController
  # Built-in forgery protection is overridden to allow for the
  # posting of positions with a script.
  protect_from_forgery except: :create
  before_action :set_position, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @position = Position.new
  end

  def edit
  end

  # Saving a new position in the database.
  # Verifies that the sheep reporting a position exists in the database.
  # Updates the sheep object with current position and attack status.
  # If sheep is under attack, mail farmer and backup
  def create
    @position = Position.new(position_params)
    @sheep = Sheep.find_by_serial @position.sheep_id
    unless @sheep
      redirect_to root_path, notice: "No sheep with id #{@position.sheep_id}"
      return
    end
    @position.sheep_id = @sheep.id


    respond_to do |format|
      if @position.save
        @sheep.latitude = @position.latitude
        @sheep.longitude = @position.longitude
        @sheep.attacked = @position.attacked
        @sheep.save
        if @position.attacked
          @owner = Farmer.find_by_id @sheep.farmer_id
          FarmerMailer.alert_email(@owner, @sheep).deliver
          unless @owner.backup.blank?
            FarmerMailer.alert_email(Farmer.find_by_email(@owner.backup), @sheep).deliver
          end
          # hook into mail sender here
          format.html { redirect_to root_path, notice: 'Attack registered' }
          format.json { render action: 'show', status: :created, location: @position }
        else
          format.html { redirect_to root_path, notice: 'Position was successfully created.' }
          format.json { render action: 'show', status: :created, location: @position }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @position.update(position_params)
        format.html { redirect_to @position, notice: 'Position was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @position.destroy
    respond_to do |format|
      format.html { redirect_to positions_url }
      format.json { head :no_content }
    end
  end

  private
    # Set current position object in the controller
    def set_position
      @position = Position.find(params[:id])
    end

    # Restrict legal parameters
    def position_params
      params.require(:position).permit(:sheep_id, :latitude, :longitude, :attacked)
    end
end
