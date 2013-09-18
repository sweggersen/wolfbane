class CreateSheep < ActiveRecord::Migration
  def change
    create_table :sheep do |t|
      t.integer :serial

      t.timestamps
    end
  end
end
