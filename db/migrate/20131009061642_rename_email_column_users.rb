class RenameEmailColumnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :email, :login
  end
end
