class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name # text is too big
      t.integer :black_player_id
      t.integer :white_player_id
      t.boolean :finished
      t.timestamps
    end
  end
end
