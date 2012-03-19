class ChangePswdColName < ActiveRecord::Migration
  def change
    rename_column :users, :hashed_pswd, :password_digest
  end
end
