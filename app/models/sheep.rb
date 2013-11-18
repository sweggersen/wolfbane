class Sheep < ActiveRecord::Base
  belongs_to :farmer
  default_scope -> { order('serial ASC') }
  validates :farmer_id, presence: true
  validates :serial, uniqueness: true
  attr_accessor :upper_serial
  has_many :positions
  has_many :medicals
  def serial_num
    sprintf "%04d", serial
  end
  #def latitude
    #update_position if @lat.nil?
    #@lat
  #end
  #def longitude
    #update_position if @long.nil?
    #@long
  #end
  #private
    #def update_position
      #last = nil
      #if @last_position.nil?
        #if positions.empty?
          #@lat = 63.6268 - ((rand * 4) / 50)
          #@long = 11.5668 + ((rand * 4) / 50)
          #return
        #end
        #last = positions.last
        #@last_position = last.id
        #@lat = last.latitude
        #@long = last.longitude
        #save
      #else
        #last = Position.find_by_id last_position
      #end
      #@lat = last.latitude
      #@long = last.longitude
    #end
end
