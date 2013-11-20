# Position class, inherits ActiveRecord::Base which handles the database interaction.
class Position < ActiveRecord::Base
  # Sets up a many-to-one relation to Sheep
  belongs_to :sheep
  # Convert time to localtime and convert to nicer format'
  def timestamp
    created_at.localtime.strftime "%Y %d/%m %X"
  end
  # Limit position coordinates to 6 digits after comma
  def human_coord(float)
    sprintf "%9.6f", float
  end
  def human_lat
    human_coord(latitude)
  end
  def human_long
    human_coord(longitude)
  end
end
