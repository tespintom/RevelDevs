class AddWinnerIdToGameTable < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :winner_id, :bigint
  end
end
