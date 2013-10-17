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
      params.require(:sheep).permit(:serial)
    end
end
