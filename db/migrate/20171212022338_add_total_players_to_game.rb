class AddTotalPlayersToGame < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :total_players, :integer
  end
end
