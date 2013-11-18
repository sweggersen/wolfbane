class SheepController < ApplicationController
  before_action :signed_in_farmer
  before_action :set_sheep, only: [:show, :edit, :update, :destroy]

  def index
    @sheep = current_user.sheep
    @sortedSheep = current_user.sheep.order('serial ASC').all
    @sheepNew = current_user.sheep.new
  end

  # Displays a single sheep
  # Creates a medical object to hold the input of a new medical
  # Find medical history of sheep, and paginates with 5 medicals per page
  def show
    @medical = @sheep.medicals.build(sheep_id: @sheep.id)
    @medicals = @sheep.medicals.order('datetime DESC').paginate(page: params[:page], per_page: 5)
    @positions = @sheep.positions.order('created_at DESC').paginate(page: params[:page], per_page: 10)
  end

  def new
    @sheep = current_user.sheep.new
  end

  def edit
  end

  # Creating of new Sheep
  # If birthyear is unset, set it to the current year
  # If an upper serial is specified, create sheep in the range
  # [serial, upper_serial], all with the same birthyear
  # If some of the serials in this range are occupied, they will
  # be reported to the user, but the sheep with valid serials will be created.
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
    elsif (@sheep.upper_serial.to_i - @sheep_upper.serial.to_i) > 100
      repond_to do |format|
        format.html { redirect_to sheep_index_url,
                      notice: "Cannot create more than 100 sheep at once" }
        format.json { redirect_to sheep_index_url }
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

  # Updating a sheep, with messages and redirects
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

  # Deleting a sheep, with messages and redirects
  def destroy
    @sheep.destroy
    respond_to do |format|
      format.html { redirect_to sheep_index_url }
      format.json { head :no_content }
    end
  end

  private
    # Set the current sheep object in the controller
    def set_sheep
      @sheep = current_user.sheep.find(params[:id])
    end

    # Restrict legal parameters
    def sheep_params
      params.require(:sheep).permit(:serial, :upper_serial, :birthyear)
    end
end
