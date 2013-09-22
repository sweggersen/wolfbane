class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
    add_column :farmers, :remember_token, :string
    add_index  :farmers, :remember_token
  end
end
