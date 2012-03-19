class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.integer :user_id
      t.string :filename
      t.string :classname

      t.timestamps
    end
  end
end
