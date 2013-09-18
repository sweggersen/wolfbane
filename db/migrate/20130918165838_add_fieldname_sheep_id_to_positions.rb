class AddFieldnameSheepIdToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :sheep_id, :integer
  end
end
