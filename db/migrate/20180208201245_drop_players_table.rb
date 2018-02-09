class DropPlayersTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :players do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.bigint "game_id"
      t.string "color"
    end
  end
end
