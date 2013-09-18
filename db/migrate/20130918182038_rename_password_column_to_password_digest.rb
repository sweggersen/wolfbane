class RenamePasswordColumnToPasswordDigest < ActiveRecord::Migration
  def self.up
    rename_column :farmers, :password, :password_digest
  end
  def self.down
    rename_column :farmers, :password_digest, :password
  end
end
