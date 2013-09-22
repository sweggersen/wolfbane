class ChangeBackupFieldInFarmers < ActiveRecord::Migration
  def up
    change_column :farmers, :backup, :string
  end
  def down
    change_column :farmers, :backup, :integer
  end
end
