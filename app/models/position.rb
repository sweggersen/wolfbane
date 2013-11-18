# Position class, inherits ActiveRecord::Base which handles the database interaction.
class Position < ActiveRecord::Base
  # Sets up a many-to-one relation to Sheep
  belongs_to :sheep
  def timestamp
    created_at.localtime.strftime "%Y %d/%m %X"
  end
end
