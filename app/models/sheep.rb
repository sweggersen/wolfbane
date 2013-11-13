class Sheep < ActiveRecord::Base
  attr_accessor :upper_serial
  belongs_to :farmer
  default_scope -> { order('serial ASC') }
  validates :farmer_id, presence: true
  validates :serial, uniqueness: true
  has_many :positions
  has_many :medicals
  def serial_num
    sprintf "%04d", serial
  end
end
