class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.text :name
      t.integer :maxplayers
      t.integer :result_id
      t.integer :player_started_id  
      t.timestamps
    end
  end
end