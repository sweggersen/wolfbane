class AddFieldnameSheepIdToMedicals < ActiveRecord::Migration
  def change
    add_column :medicals, :sheep_id, :integer
  end
end
