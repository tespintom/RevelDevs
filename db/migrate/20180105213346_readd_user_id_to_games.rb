class ReaddUserIdToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :user_id, :bigint
  end
end
