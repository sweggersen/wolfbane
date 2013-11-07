class RenameFarmerFieldToFarmerId < ActiveRecord::Migration
  def self.up
    rename_column :sheep, :farmer, :farmer_id
  end
  def self.down
    rename_column :sheep, :farmer_id, :farmer
  end
end
