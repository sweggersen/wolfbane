class CreateFarmers < ActiveRecord::Migration
  def change
    create_table :farmers do |t|
      t.string :email
      t.string :name
      t.string :password
      t.string :phone

      t.timestamps
    end
  end
end
