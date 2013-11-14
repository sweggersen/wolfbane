class Sheep < ActiveRecord::Base
  belongs_to :farmer
  default_scope -> { order('serial ASC') }
  validates :farmer_id, presence: true
  has_many :positions
  has_many :medicals
  attr_accessor :latitude, :longitude
  def serial_num
    sprintf "%04d", serial
  end
  def latitude
    update_position if @lat.nil?
    @lat
  end
  def longitude
    update_position if @long.nil?
    @long
  end
  private
    def update_position
      unless positions.empty?
        last = positions.last
        @lat = last.latitude
        @long = last.longitude
      end
    end
end
