class MedicalsController < ApplicationController
  before_action :set_medical, only: [:show, :edit, :update, :destroy]

  # Listing is not used, since Medicals is listed on the Sheep view
  def index
  end

  def show
  end

  # New medicals are created on the Sheep view
  def new
  end

  def edit
  end

  # Saving a new medical in database, with messages and redirects
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

  # Updating a medical, with messages and redirects
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

  # Deleting a medical, with messages and redirects
  def destroy
    @medical.destroy
    respond_to do |format|
      format.html { redirect_to Sheep.find_by_id @medical.sheep_id }
      format.json { head :no_content }
    end
  end

  private
    # Set the current medical object in the controller
    def set_medical
      @medical = Medical.find(params[:id])
    end

    # Restrict legal parameters
    def medical_params
      params.require(:medical).permit(:sheep_id, :datetime, :weight, :notes)
    end
end
