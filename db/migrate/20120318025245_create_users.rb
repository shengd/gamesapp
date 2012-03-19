class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :email
      t.string :hashed_pswd
      t.string :salt

      t.timestamps
    end
  end
end
