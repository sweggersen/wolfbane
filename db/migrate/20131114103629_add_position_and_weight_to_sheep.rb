class AddPositionAndWeightToSheep < ActiveRecord::Migration
  def change
    remove_column :sheep, :last_position
    add_column :sheep, :latitude, :float
    add_column :sheep, :longitude, :float
    add_column :sheep, :attacked, :boolean
    add_column :sheep, :birthyear, :integer
  end
end
