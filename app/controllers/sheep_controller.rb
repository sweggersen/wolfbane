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
    @medicals = @sheep.medicals.order('datetime DESC').paginate(page: params[:medicals], per_page: 5)
    @positions = @sheep.positions.order('created_at DESC').paginate(page: params[:positions], per_page: 7)
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
          format.html { redirect_to sheep_index_url, notice: 'Sau med samme id finnes' }
          format.json { render json: @sheep.errors, status: :unprocessable_entity }
        end
      end
    elsif (@sheep.serial.to_i > @sheep.upper_serial.to_i)
      respond_to do |format|
        format.html { redirect_to sheep_index_url,
                      notice: "Siste Serialnummer kan ikke være større enn det første." }
        format.json { redirect_to sheep_index_url }
      end
    elsif (@sheep.upper_serial.to_i - @sheep.serial.to_i) > 100
      respond_to do |format|
        format.html { redirect_to sheep_index_url,
                      notice: "Kan ikke lage mer enn 100 sauer om gangen." }
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
          format.html { redirect_to sheep_index_url, notice: "Sau ble laget."}
          format.json { redirect_to sheep_index_url }
        else
          format.html { redirect_to sheep_index_url, notice: "#{(n - invalid.size)+1} sauer ble laget." }
          format.json { redirect_to sheep_index_url }
        end
      end
    end
  end

  # Updating a sheep, with messages and redirects
  def update
    respond_to do |format|
      if @sheep.update(sheep_params)
        format.html { redirect_to @sheep, notice: 'Sau ble oppdatert.' }
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
