class CreateMedicals < ActiveRecord::Migration
  def change
    create_table :medicals do |t|
      t.timestamp :datetime
      t.integer :weight
      t.string :notes

      t.timestamps
    end
  end
end
