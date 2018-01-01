class AddStateToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :state, :string, default: "pending", null: false
  end
end
