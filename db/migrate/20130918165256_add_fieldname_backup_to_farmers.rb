class AddFieldnameBackupToFarmers < ActiveRecord::Migration
  def change
    add_column :farmers, :backup, :integer
  end
end
