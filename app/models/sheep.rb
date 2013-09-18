class Sheep < ActiveRecord::Base
  belongs_to :farmer
  has_many :positions
  has_many :medicals
end
