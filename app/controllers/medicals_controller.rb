class MedicalsController < ApplicationController
  before_action :set_medical, only: [:show, :edit, :update, :destroy]

  # GET /medicals
  # GET /medicals.json
  def index
  end

  # GET /medicals/1
  # GET /medicals/1.json
  def show
  end

  # GET /medicals/new
  def new
#    @medical = Medical.new
  end

  # GET /medicals/1/edit
  def edit
  end

  # POST /medicals
  # POST /medicals.json
  def create
    @medical = Medical.new(medical_params)
    respond_to do |format|
      if @medical.save
        format.html { redirect_to Sheep.find_by_id @medical.sheep_id }
        format.json { render action: 'show', status: :created, location: @medical }
      else
        format.html { render action: 'new' }
        format.json { render json: @medical.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medicals/1
  # PATCH/PUT /medicals/1.json
  def update
    respond_to do |format|
      if @medical.update(medical_params)
        format.html { redirect_to @medical, notice: 'Medical was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @medical.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medicals/1
  # DELETE /medicals/1.json
  def destroy
    @medical.destroy
    respond_to do |format|
      format.html { redirect_to Sheep.find_by_id @medical.sheep_id }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medical
      @medical = Medical.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medical_params
      params.require(:medical).permit(:sheep_id, :datetime, :weight, :notes)
    end
end
