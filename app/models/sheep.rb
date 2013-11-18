# Sheep class, inherits ActiveRecord::Base which handles the database interaction.
class Sheep < ActiveRecord::Base
  # Sets up a many-to-one relation with Farmer
  belongs_to :farmer
  # Default ordering, sorted by serial, ascending
  default_scope -> { order('serial ASC') }
  # Ensures that the sheep belongs to a farmer before saving in database
  validates :farmer_id, presence: true
  # Ensures that the Serial is unique
  validates :serial, uniqueness: true
  attr_accessor :upper_serial
  # Sets up a one-to-many relation with Positions
  has_many :positions
  # Sets up a one-to-many relation with Medicals
  has_many :medicals
  # Convenience method for printing sheep with leading zeros
  def serial_num
    sprintf "%08d", serial
  end
end
