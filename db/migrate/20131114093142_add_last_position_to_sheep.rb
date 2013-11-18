class AddLastPositionToSheep < ActiveRecord::Migration
  def change
    add_column :sheep, :last_position, :integer
  end
end
