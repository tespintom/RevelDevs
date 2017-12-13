class AddColToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :white_player_id, :bigint
    add_column :games, :black_player_id, :bigint
  end
end
