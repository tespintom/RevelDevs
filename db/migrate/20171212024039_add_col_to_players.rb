class AddColToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :game_id, :bigint
    add_column :players, :color, :string
  end
end
