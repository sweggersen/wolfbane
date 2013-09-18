class AddIndexToFarmersEmail < ActiveRecord::Migration
  def change
    add_index :farmers, :email, unique: true
  end
end
