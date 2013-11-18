class ForeignKeyIndices < ActiveRecord::Migration
  def change
    add_index :sheep, :farmer_id, :name => 'farmer_id_ix'
    add_index :medicals, :sheep_id, :name => 'sheep_id_med_ix'
    add_index :positions, :sheep_id, :name => 'sheep_id_pos_ix'
  end
end
