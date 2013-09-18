class AddFieldnameFarmerToSheep < ActiveRecord::Migration
  def change
    add_column :sheep, :farmer, :integer
  end
end
