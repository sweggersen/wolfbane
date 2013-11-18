# Position class, inherits ActiveRecord::Base which handles the database interaction.
class Position < ActiveRecord::Base
  # Sets up a many-to-one relation to Sheep
  belongs_to :sheep
end
