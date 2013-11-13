class SheepController < ApplicationController
  before_action :signed_in_farmer
  before_action :set_sheep, only: [:show, :edit, :update, :destroy]

  # GET /sheep
  # GET /sheep.json
  def index
    @sheep = current_user.sheep
  end

  # GET /sheep/1
  # GET /sheep/1.json
  def show
    @medical = @sheep.medicals.build(sheep_id: @sheep.id)
    @medicals = @sheep.medicals.paginate(page: params[:page], per_page: 5)
  end

  # GET /sheep/new
  def new
    @sheep = current_user.sheep.new
  end

  # GET /sheep/1/edit
  def edit
  end

  # POST /sheep
  # POST /sheep.json
  def create
    @sheep = current_user.sheep.build(sheep_params)

    if @sheep.upper_serial.blank?
      respond_to do |format|
        if @sheep.save
          format.html { redirect_to @sheep, notice: 'Sheep was successfully created.' }
          #format.html { redirect_to sheep_index_url }
          format.json { render action: 'show', status: :created, location: @sheep }
          #format.json { head :no_content }
          
        else
          format.html { render action: 'new' }
          format.json { render json: @sheep.errors, status: :unprocessable_entity }
        end
      end
    else
      invalid = []
      (@sheep.serial.to_i .. @sheep.upper_serial.to_i).each do |s|
        new_sheep = Sheep.new
        new_sheep.serial = s
        new_sheep.farmer_id = current_user.id
        invalid << s unless new_sheep.save
      end
      n = @sheep.upper_serial.to_i - @sheep.serial.to_i
      respond_to do |format|
        if invalid.empty?
          format.html { redirect_to sheep_index_path, notice: "#{n} sheep was successfully created." }
          format.json { render action: 'show', status: :created, location: @sheep }
        else
          n_invalid = invalid.size
          msg = "#{(n - n_invalid)+1} sheep was successfully created."
          msg += "\nThe following sheep could not be created: #{invalid.join(', ')}"
          format.html { redirect_to sheep_index_path, notice: msg }
          format.json { render action: 'show', status: :created, location: @sheep }
        end
      end
    end
  end

  # PATCH/PUT /sheep/1
  # PATCH/PUT /sheep/1.json
  def update
    respond_to do |format|
      if @sheep.update(sheep_params)
        format.html { redirect_to @sheep, notice: 'Sheep was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sheep.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sheep/1
  # DELETE /sheep/1.json
  def destroy
    @sheep.destroy
    respond_to do |format|
      format.html { redirect_to sheep_index_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sheep
      @sheep = current_user.sheep.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sheep_params
      params.require(:sheep).permit(:serial, :upper_serial)
    end
end
