class SheepController < ApplicationController
  before_action :signed_in_farmer
  before_action :set_sheep, only: [:show, :edit, :update, :destroy]

  # GET /sheep
  # GET /sheep.json
  def index
    @sheep = current_user.sheep
    #update_positions
    @sortedSheep = current_user.sheep.order('serial ASC').all
    @sheepNew = current_user.sheep.new
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
    @sheep.birthyear = DateTime.now.year if @sheep.birthyear.blank?
    if @sheep.upper_serial.blank?
      respond_to do |format|
        if @sheep.save
          format.html { redirect_to sheep_index_url }
          format.json { redirect_to sheep_index_url }
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
        new_sheep.birthyear = @sheep.birthyear
        new_sheep.farmer_id = current_user.id
        invalid << s unless new_sheep.save
      end
      n = @sheep.upper_serial.to_i - @sheep.serial.to_i
      respond_to do |format|
        if invalid.empty?
          format.html { redirect_to sheep_index_url,
                        notice: "#{n} sheep was successfully created."}
          format.json { redirect_to sheep_index_url }
        else
          n_invalid = invalid.size
          msg = "#{(n - n_invalid)+1} sheep was successfully created."
          msg += "\nThe following sheep ID's was taken: #{invalid.join(', ')}"

          format.html { redirect_to sheep_index_url, notice: msg }
          format.json { redirect_to sheep_index_url }
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
      #update_positions
      #@sheep.update_position
    end
    #def update_positions
      #@sheep.each do |s|
        #if s.latitude.nil? || s.latitude.empty?
          #if s.positions.empty?
            #s.latitude = 63.6268 - ((rand * 4) / 50)
            #s.longitude = 11.5668 + ((rand * 4) / 50)
            #s.attacked = false
          #else
            #last = s.positions.last
            #s.latitude = last.latitude
            #s.longitude = last.longitude
            #s.attacked = last.attacked
          #end
          #s.save
        #end
      #end
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sheep_params
      params.require(:sheep).permit(:serial, :upper_serial, :birthyear)
    end
end
