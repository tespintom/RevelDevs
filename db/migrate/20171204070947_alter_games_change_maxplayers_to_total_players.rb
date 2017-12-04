class AlterGamesChangeMaxplayersToTotalPlayers < ActiveRecord::Migration[5.1]
  def change
    rename_column :games, :maxplayers, :total_players
  end
end
