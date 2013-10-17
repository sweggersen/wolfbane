class Sheep < ActiveRecord::Base
  belongs_to :farmer
  default_scope -> { order('serial ASC') }
  validates :farmer_id, presence: true
  has_many :positions
  has_many :medicals
  def serial_num
    sprintf "%04d", serial
  end
end
