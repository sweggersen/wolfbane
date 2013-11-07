class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]

  # GET /positions
  # GET /positions.json
  def index
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
  end

  # GET /positions/new
  def new
    @position = Position.new
  end

  # GET /positions/1/edit
  def edit
  end

  # POST /positions
  # POST /positions.json
  def create
    @position = Position.new(position_params)
    @sheep = Sheep.find_by_id @position.sheep_id
    unless @sheep
      redirect_to root_path, notice: "No sheep with id #{@position.sheep_id}"
      return
    end


    respond_to do |format|
      if @position.save
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

  # PATCH/PUT /positions/1
  # PATCH/PUT /positions/1.json
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

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position.destroy
    respond_to do |format|
      format.html { redirect_to positions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      params.require(:position).permit(:sheep_id, :latitude, :longitude, :attacked)
    end
end
